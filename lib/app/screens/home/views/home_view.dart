import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:todo_app/app/screens/auth/controllers/auth_controller.dart';
import 'package:todo_app/app/screens/home/views/add_task_page.dart';
import 'package:todo_app/app/screens/home/views/names_page.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _duration = TextEditingController();
  final TextEditingController _description = TextEditingController();

  TextEditingController _textEditingController = TextEditingController();

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${controller.name}'),
        actions: [
          IconButton(
              onPressed: () async {
                authController.signOutMethod();
              },
              icon: Icon(Icons.power_settings_new_outlined)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((QueryDocumentSnapshot document) {
              return ListTile(
                onTap: () {
                  controller.names.value = [];
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NamesPage(
                        names: document.get('names'),
                        title: document.get('ID'),
                        document: document,
                      ),
                    ),
                  );
                },
                title: Text(document.get('ID')),
                trailing: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () => controller.deleteFun(document),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _displayTextInputDialog(context);
          // Get.to(AddTaskPage());
        },
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter name'),
            content: TextField(
              onSubmitted: (value) {},
              controller: _textEditingController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: [
              MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  if (_textEditingController.text.isNotEmpty)
                    controller.addDevice(_textEditingController.text);
                  // Get.snackbar('Error', 'Please enter device name',
                  //     snackPosition: SnackPosition.BOTTOM);

                  Navigator.pop(context);
                },
                child: Text(
                  'Add Device',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              MaterialButton(
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }
}
