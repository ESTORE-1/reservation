import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/screens/home/controllers/home_controller.dart';

class AddNamePage extends GetView<HomeController> {
  final document;

  AddNamePage(this.document);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phonelController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Name'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: _phonelController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Phone Number'),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(hintText: 'Note'),
            ),
            ///////////////////////////////////////////////////////
            ///
            MaterialButton(
              onPressed: () async {
                await controller.addName(
                  document,
                  name: _nameController.text,
                  phone: _phonelController.text,
                  note: _noteController.text,
                );
                Navigator.pop(context);
              },
              child: Text('add name'),
            )
          ],
        ),
      ),
    );
  }
}
