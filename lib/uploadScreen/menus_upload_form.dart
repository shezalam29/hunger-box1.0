import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

import "package:hunger_box/widgets/progress_bar.dart";
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import "package:image_picker/image_picker.dart";

import "../global/global.dart";
import "../widgets/error_dialog.dart";

class MenusUploadForm extends StatefulWidget {
  final XFile imageXFile;
  const MenusUploadForm({super.key, required this.imageXFile});

  @override
  State<MenusUploadForm> createState() =>
      _MenusUploadFormState(imageXFile: imageXFile);
}

class _MenusUploadFormState extends State<MenusUploadForm> {
  final XFile imageXFile;
  _MenusUploadFormState({required this.imageXFile});

  //text input Controllers
  TextEditingController menuInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool uploading = false;

  //Name of the image url
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  menusUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 120, 130, 100),
          ),
        ),
        title: const Text(
          "Menu Item Info",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: uploading
                ? null
                : () => validateUploadForm(), // check if uploding is true
            child: const Text(
              "+",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22, //just decrease it for add size
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(""),
          // ignore: sized_box_for_whitespace
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(imageXFile.path)),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),

          ListTile(
            leading: const Icon(
              Icons.title_rounded,
              color: Color.fromARGB(255, 120, 130, 100), //
            ),
            // ignore: sized_box_for_whitespace
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Item Name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Color.fromARGB(255, 120, 130, 100),
            ),
            // ignore: sized_box_for_whitespace
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: menuInfoController,
                decoration: const InputDecoration(
                  hintText: "General description",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          ListTile(
            leading: const Icon(Icons.attach_money_rounded,
                color: Color.fromARGB(255, 120, 130, 100)),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  validateUploadForm() async {
    if (menuInfoController.text.isNotEmpty &&
        titleController.text.isNotEmpty &&
        priceController.text.isNotEmpty) {
      setState(() {
        uploading = true;
      });

      //47
      //upload image
      String fileName =
          "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      String downloadUrl =
          await FBH.uploadImage(fileName, imageXFile.path, menusCllctn);
      //48
      //Save image into firebase
      uploadItem(downloadUrl);
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please enter required information",
            );
          });
    }
  }

  clearMenuUploadForm() {
    setState(() {
      menuInfoController.clear();
      titleController.clear();
      priceController.clear();
    });
  }

  //upload image to firebase
  // uploadImage(XFile) async {
  //   String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  //   storageRef.Reference reference =
  //       storageRef.FirebaseStorage.instance.ref().child("menus");

  //   storageRef.UploadTask uploadTask =
  //       reference.child(uniqueIdName + ".jpg").putFile(imageFile);

  //   storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

  //   String downloadURL = await taskSnapshot.ref.getDownloadURL();

  //   return downloadURL;
  // }

  //48
  uploadItem(String imgURL) {
    FBH.uploadMenuItem(
        sharedPreferences.getUID()!,
        MenuItem(
          menuID: uniqueIdName,
          vendorUID: sharedPreferences.getUID()!,
          menuTitle: titleController.text.toString(),
          menuInfo: menuInfoController.text.toString(),
          price: double.parse(priceController.text),
          datePublished: DateTime.now(),
          status: "available",
          thumbnailUrl: imgURL,
        ));
    closeWindow();
  }

  closeWindow() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return menusUploadFormScreen();
  }
}
