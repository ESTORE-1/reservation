import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var _user;

  late Stream<QuerySnapshot> stream;
  var name = ''.obs;

  var collectionRefrence;
  RxList names = [].obs;

  var id = ''.obs;

  setNames(List? names) {
    this.names.value = names!;
    update();
  }

  void getUserName() {
    var documents =
        FirebaseFirestore.instance.collection('Users').doc(_user.uid);

    documents.get().then((document) {
      name.value = _user.displayName ?? document["name"];
      update();
    });
  }

  @override
  void onInit() {
    _user = FirebaseAuth.instance.currentUser;
    collectionRefrence = FirebaseFirestore.instance
        .collection('reservations')
        .doc('Groups')
        .collection('Devices');
    stream = collectionRefrence.snapshots();

    getUserName();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getUserName();
  }

  void deleteFun(document) {
    collectionRefrence.doc(document.id).delete();
  }

  void deleteName(document, int index) async {
    final value = await FirebaseFirestore.instance
        .collection('reservations')
        .doc('Groups')
        .collection('Devices')
        .doc(document.id)
        .get();

    final data = value.data();

    List names =
        data!['names'].map((item) => item as Map<String, dynamic>).toList();

    // print(names);
    names.removeAt(index);

    await collectionRefrence
        .doc(document.id)
        .set({'ID': document.get('ID'), 'names': names}) // <-- New data
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));

    this.names.value = names;
  }

  void updateFun(document, List<String> fields, List<String> updateData) {
    for (var i = 0; i < fields.length; i++)
      collectionRefrence.doc(document.id).update({fields[i]: updateData[i]});
  }

  void addTask(String title, String duration, String description) async {
    collectionRefrence
        .add({'title': title, 'dur': duration, 'des': description});
  }

  void addDevice(String title) async {
    collectionRefrence.add({'ID': title, 'names': []});
  }

  Future<void> addName(document,
      {String? name, String? phone, String? note}) async {
    final value = await FirebaseFirestore.instance
        .collection('reservations')
        .doc('Groups')
        .collection('Devices')
        .doc(document.id)
        .get();

    final data = value.data();

    final names =
        data!['names'].map((item) => item as Map<String, dynamic>).toList();

    var item = {
      'name': '$name',
      'phone': '$phone',
      'note': '$note',
      'image': [
        'https://upload.wikimedia.org/wikipedia/en/thumb/6/62/UMID_EMV_sample.png/1200px-UMID_EMV_sample.png',
        'https://upload.wikimedia.org/wikipedia/en/thumb/6/62/UMID_EMV_sample.png/1200px-UMID_EMV_sample.png'
      ]
    };

    names.add(item);

    await collectionRefrence
        .doc(document.id)
        .update({'names': names}) // <-- New data
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));

    this.names.value = names;
    update();
  }

  showSheet(document, {name, dur, des}) async {
    List<String> fields = ['title', 'dur', 'des'];
    name.text = document.get('name');
    dur.text = document.get('dur');
    des.text = document.get('des');

    return showDialog(
        context: Get.overlayContext as BuildContext,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Title'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _textField(name, 'Add Task Title'),
                _textField(des, 'Add Task Description'),
                _textField(dur, 'Add Task Duration'),
              ],
            ),
            actions: [
              buildBlock(name, dur, des, document, fields, context),
              buildCancelButton(),
            ],
          );
        });
  }

  TextField _textField(controller, hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
      ),
    );
  }

  @override
  void onClose() {}

  Container buildCancelButton() {
    return Container(
      width: 125,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () => Get.back(),
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Cancel', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Container buildBlock(
      name, dur, des, document, List<String> fields, BuildContext context) {
    return Container(
      width: 125,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          List<String> updateData = [name.text, dur.text, des.text];
          updateFun(document, fields, updateData);
          Navigator.pop(context);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Update', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
