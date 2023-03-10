import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hunger_box/mainScreens/vendor_home_screen.dart';
import 'package:hunger_box/mainScreens/menu_items_screen.dart';
import 'package:hunger_box/widgets/progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import '../global/global.dart';
import '../model/menus.dart';
import '../widgets/error_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class ItemsUploadScreen extends StatefulWidget {
  final Menus? model;
  final XFile imageXFile;
  const ItemsUploadScreen({super.key, required this.imageXFile, this.model});
  // widget depends on this model

  @override
  State<ItemsUploadScreen> createState() =>
      _ItemsUploadScreenState(imageXFile: imageXFile);
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  final XFile imageXFile;
  _ItemsUploadScreenState({required this.imageXFile});

  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool uploading = false;

  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  ItemsUploadScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 120, 130, 100),
          ),
        ),
        title: const Text(
          "Item Upload",
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
            clearMenuUploadForm();
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => VendorHomeScreen()));
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "+",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22, //just decrease it for add size
              ),
            ),

            onPressed: uploading
                ? null
                : () => validateUploadForm(), // check if uploding is true
          )
        ],
      ),
      body: ListView(children: [
        uploading == true ? linearProgress() : const Text(""),
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
          title: Container(
            width: 250,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: "Description",
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
              keyboardType: TextInputType.number,
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
      ]),
    );
  }

  clearMenuUploadForm() {
    setState(() {
      descriptionController.clear();
      titleController.clear();
      priceController.clear();
      // imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (descriptionController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          priceController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });

        //upload image
        String downloadUrl = await uploadImage(File(imageXFile.path));

        //Save image to firebase
        saveInfo(downloadUrl);
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Please enter requiered information",
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please choose an image for menu item",
            );
          });
    }
  }

  //upload image to firebase
  uploadImage(imageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("menuItems");

    storageRef.UploadTask uploadTask =
        reference.child(uniqueIdName + ".jpg").putFile(imageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  //Firebase data storing
  saveInfo(String downloadURL) {
    final ref = FirebaseFirestore.instance
        .collection("vendors")
        .doc(sharedPreferences.getUID())
        .collection("menus")
        .doc(widget.model!.menuID) // adds as sub collection of single menu
        .collection(
            "menuItems"); //here creates a vendor collection called menus with UID

    ref.doc(uniqueIdName).set({
      "itemID": uniqueIdName,
      "menuID": widget.model!.menuID,
      "vendorUID": sharedPreferences.getUID(),
      "vendorName": sharedPreferences.getName(),
      "itemTitle": titleController.text.toString(),
      "itemDescription": descriptionController.text.toString(),
      "price": double.parse(priceController.text),
      "datePublished": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadURL,
    }).then((value) {
      /// New collection of only menuItems///
      final menuItemsRef = FirebaseFirestore.instance.collection("menuItems");

      menuItemsRef.doc(uniqueIdName).set({
        "itemID": uniqueIdName,
        "menuID": widget.model!.menuID,
        "vendorID": sharedPreferences.getUID(),
        "vendorName": sharedPreferences.getName(),
        "itemTitle": titleController.text.toString(),
        "itemDescription": descriptionController.text.toString(),
        "price": double.parse(priceController.text),
        "datePublished": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadURL,
      });

      clearMenuUploadForm();
      setState(() {
        uniqueIdName = "";
        uploading = false;
      });
      closeWindow();
    });
  }

  closeWindow() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ItemsUploadScreen();
  }
}
