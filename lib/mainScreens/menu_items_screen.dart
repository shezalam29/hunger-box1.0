import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hunger_box/mainScreens/user_home_screen.dart';
import 'package:hunger_box/uploadScreen/items_upload_form.dart';
import 'package:hunger_box/widgets/menu_item_design.dart';
import 'package:hunger_box/widgets/text_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hunger_box/widgets/vendor_drawer.dart';

import '../global/global.dart';
import '../model/menu_items.dart';
import '../model/menus.dart';
import '../widgets/progress_bar.dart';

class MenuItemsScreen extends StatefulWidget {
  final Menus? model;
  final MenuItems? itemModel;
  MenuItemsScreen({this.model, this.itemModel}); // widget depends on this model

  @override
  State<MenuItemsScreen> createState() => _MenuItemsScreenState();
}

class _MenuItemsScreenState extends State<MenuItemsScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const VendorDrawer(),
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 120, 130, 100),
            ),
          ),
          title: Text("Welcome, " + sharedPreferences.getName()!,
              style: TextStyle(fontSize: 30, fontFamily: "Bebas")),
          centerTitle: true,
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
                icon: Icon(Icons.library_add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                            title: Text(
                              "Menu Image",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            children: [
                              SimpleDialogOption(
                                child: const Text(
                                  "Capture with Camera",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 95, 93, 93)),
                                ),
                                onPressed: captureImageWithCamera,
                              ),
                              SimpleDialogOption(
                                child: Text(
                                  "Select from Gallery",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 95, 93, 93)),
                                ),
                                onPressed: pickImageFromGallery,
                              ),
                              SimpleDialogOption(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ]);
                      });
                })
          ] //video 34. this line can be remove (default is true)
          ),
      body: Container(
        margin: EdgeInsets.only(left: 6.0, right: 6.0),
        child: CustomScrollView(slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(
                  title: widget.model!.menuTitle.toString() + "'s Menu Items")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                // Collection to get data to display
                .collection("vendors")
                .doc(sharedPreferences.getUID())
                .collection("menus")
                .doc(widget.model!.menuID)
                .collection("menuItems")
                .snapshots(),
            builder: (context, snapshot) {
              // if no data: display circular progress
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverAlignedGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,

                      // staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        MenuItems itemModel = MenuItems.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return MenuItemsDesignWidget(
                          itemModel: itemModel,
                          context: context,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          )
        ]),
      ),
    );
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker
        .pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1200,
    )
        .then((img) {
      if (img != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemsUploadScreen(
                      imageXFile: img,
                      model: widget.model,
                    )));
      }
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _picker
        .pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1200,
    )
        .then((img) {
      if (img != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemsUploadScreen(
                      imageXFile: img,
                      model: widget.model,
                    )));
      }
    });
  }
}
