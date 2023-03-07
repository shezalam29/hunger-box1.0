import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
//import "package:hunger_box/hungerbox_pref/hungerbox_pref.dart";
//import "package:hunger_box/global/global.dart";
import 'package:hunger_box/mainScreens/vendor_home_screen.dart';
import "package:hunger_box/widgets/progress_bar.dart";
import "package:image_picker/image_picker.dart";
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

import "../global/global.dart";
import "../widgets/error_dialog.dart";

class MenusUpload extends StatefulWidget {
  const MenusUpload({super.key});

  @override
  State<MenusUpload> createState() => _MenusUploadState();
}

class _MenusUploadState extends State<MenusUpload> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  //text input Controllers
  TextEditingController menuInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool uploading = false;

  //Name of the image url
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 120, 130, 100),
          ),
        ),
        title: const Text(
          "Add a new menu item",
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
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const VendorHomeScreen()));
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  takeImage(context);
                },
                child: const Icon(
                  Icons.add_box,
                  color: Color.fromARGB(255, 188, 169, 146),
                  size: 150.0,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 188, 169, 146),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                onPressed: () {
                  takeImage(context);
                },
                child: const Text(
                  "Add New Menu Item",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "Item Image",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              // ignore: sort_child_properties_last
              child: const Text(
                "Capture with Camera",
                style: TextStyle(color: Color.fromARGB(255, 95, 93, 93)),
              ),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              // ignore: sort_child_properties_last
              child: const Text(
                "Choose from Gallery",
                style: TextStyle(color: Color.fromARGB(255, 95, 93, 93)),
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

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
            clearMenuUploadForm();
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
                      image: FileImage(File(imageXFile!.path)),
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
    if (imageXFile != null) {
      if (menuInfoController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          priceController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });

        //47
        //upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));

        //48
        //Save image into firebase
        saveInfo(downloadUrl);
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Please enter required information",
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please choose an image for the menu item",
            );
          });
    }
  }

  clearMenuUploadForm() {
    setState(() {
      menuInfoController.clear();
      titleController.clear();
      priceController.clear();
      imageXFile = null;
      //uniqueIdName = "";
      //uploading = false;
    });
  }

  //upload image to firebase
  uploadImage(imageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("menus");

    storageRef.UploadTask uploadTask =
        reference.child(uniqueIdName + ".jpg").putFile(imageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  //48
  saveInfo(String downloadURL) {
    final ref = FirebaseFirestore.instance
        .collection("vendors")
        .doc(sharedPreferences.getUID())
        .collection("menus");

    ref.doc(uniqueIdName).set({
      "menuID": uniqueIdName,
      "vendorUID": sharedPreferences.getUID(),
      "menuTitle": titleController.text.toString(),
      "menuInfo": menuInfoController.text.toString(),
      "price": priceController.text.toString(),
      "datePublished": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadURL,
    });

    clearMenuUploadForm();
    setState(() {
      uniqueIdName = "";
      uploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }
}
