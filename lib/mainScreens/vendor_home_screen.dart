import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hunger_box/global/global.dart';
import 'package:hunger_box/uploadScreen/items_upload_form.dart';
import 'package:hunger_box/widgets/vendor_items_design.dart';

import '../widgets/drawer.dart';

//import '../widgets/user_items_design.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget.dart';

import "package:image_picker/image_picker.dart";

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 120, 130, 100),
          ),
        ),
        title: Text(sharedPreferences.getName() ?? "NO NAME FOUND"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: const Text(
                      "Item Image",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      SimpleDialogOption(
                        // ignore: sort_child_properties_last
                        child: const Text(
                          "Capture with Camera",
                          style:
                              TextStyle(color: Color.fromARGB(255, 95, 93, 93)),
                        ),
                        onPressed: () =>
                            pickImageAndRedirect(ImageSource.camera),
                      ),
                      SimpleDialogOption(
                        // ignore: sort_child_properties_last
                        child: const Text(
                          "Choose from Gallery",
                          style:
                              TextStyle(color: Color.fromARGB(255, 95, 93, 93)),
                        ),
                        onPressed: () =>
                            pickImageAndRedirect(ImageSource.gallery),
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
            },
          ),
        ],
      ),

      // ignore: prefer_const_constructors
      //drawer: MyDrawer(),
      body: Container(
        //margin: const EdgeInsets.only(left: 6.0, right: 6.0),
        child: CustomScrollView(slivers: [
          SliverPersistentHeader(
              pinned: true, delegate: TextWidgetHeader(title: "Your Menu")),
          StreamBuilder<QuerySnapshot>(
            // TODO need to fix this to run through FBH
            stream: FirebaseFirestore.instance
                .collection(vendorCllctn)
                .doc(FBH.currentUser!.uid)
                .collection(itemsCllctn)
                .snapshots(),
            builder: (context, snapshot) {
              // if not has data: display circular progress
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
                        MenuItem model = MenuItem.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return VendorItemsDesignWidget(
                          model: model,
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

  final ImagePicker _picker = ImagePicker();

  pickImageAndRedirect(ImageSource im) async {
    Navigator.pop(context);
    await _picker
        .pickImage(
      source: im,
      maxHeight: 720,
      maxWidth: 1280,
    )
        .then((img) {
      if (img != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemsUploadForm(imageXFile: img)));
      }
    });
  }
}
