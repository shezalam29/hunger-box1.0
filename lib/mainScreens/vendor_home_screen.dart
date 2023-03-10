import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hunger_box/global/global.dart';
import 'package:hunger_box/uploadScreen/menus_upload_form.dart';

import 'package:hunger_box/widgets/vendor_drawer.dart';

import '../model/menus.dart';
import '../widgets/menu_info_design.dart';
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
      drawer: const VendorDrawer(),
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
      body: Container(
        child: CustomScrollView(slivers: [
          SliverPersistentHeader(
              pinned: true, delegate: TextWidgetHeader(title: "Your Menus")),
          StreamBuilder<QuerySnapshot>(
            // TODO need to fix this to run through FBH
            stream: FirebaseFirestore.instance
                .collection(vendorCllctn)
                .doc(FBH.currentUser!.uid)
                .collection(menusCllctn)
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
                      crossAxisCount: 1,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      itemBuilder: (context, index) {
                        Menus model = Menus.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return InfoDesignWidget(
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
                builder: (c) => MenusUploadForm(imageXFile: img)));
      }
    });
  }
}
