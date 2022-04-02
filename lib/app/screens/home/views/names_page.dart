// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/app/screens/home/controllers/home_controller.dart';
import 'package:todo_app/app/screens/home/views/add_name_page.dart';

class NamesPage extends GetView<HomeController> {
  NamesPage({Key? key, this.names, this.title, this.document})
      : super(key: key);

  final List? names;
  final String? title;
  final document;

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
        centerTitle: true,
      ),
      body: Obx(() {
        homeController.setNames(names);

        return ListView.builder(
          itemCount: homeController.names.value.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(homeController.names.value[index]['name']),
              // subtitle: Text(homeController.names.value[index]['phone']),
              // trailing: IconButton(
              //   icon: Icon(Icons.cancel),
              //   onPressed: () {
              //     names!.removeAt(index);
              //     homeController.deleteName(document, index);
              //   },
              //   // onPressed: () => print(document.get('ID') + ' ' + index.toString()),
              // ),
              // leading: Image.network(
              //   controller.names.value[index]['image'][0],
              //   width: 30,
              //   height: 30,
              //   fit: BoxFit.fill,
              // ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddNamePage(document));
          controller.update();
          // _displayTextInputDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
