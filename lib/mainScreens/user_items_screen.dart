import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hunger_box/global/global.dart';
import '../widgets/cart_button.dart';
import 'package:hunger_box/uploadScreen/items_upload_form.dart';

import '../widgets/user_items_design.dart';
import '../widgets/progress_bar.dart';

import 'package:badges/badges.dart' as badges;
import "package:image_picker/image_picker.dart";

class UserItemsScreen extends StatefulWidget {
  final Vendor? model;
  UserItemsScreen({this.model});

  @override
  State<UserItemsScreen> createState() => _UserItemsScreenState();
}

class _UserItemsScreenState extends State<UserItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const MyDrawer(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 120, 130, 100),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.model!.name.toString() +
            "'s menu"), // needs to be changed to reflect the vendor name the buyer clicked on
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 8),
            child: badges.Badge(
              position: badges.BadgePosition.topEnd(top: 0, end: 0),
              badgeAnimation: const badges.BadgeAnimation.rotation(
                animationDuration: Duration(seconds: 1),
                loopAnimation: false,
                curve: Curves.fastOutSlowIn,
                colorChangeAnimationCurve: Curves.easeInCubic,
              ),
              badgeContent: const Text(
                  '3'), // change this to reflect how many items are in the cart
              child: CartButton(),
            ),
          ),
        ],
      ),

      // ignore: prefer_const_constructors
      //drawer: MyDrawer(),
      body: Container(
        //margin: const EdgeInsets.only(left: 6.0, right: 6.0),
        child: CustomScrollView(slivers: [
          // SliverPersistentHeader(
          //     pinned: true,
          //     delegate: TextWidgetHeader(
          //         title: widget.model!.name.toString() + "'s menu")),
          StreamBuilder<QuerySnapshot>(
            // TODO need to fix this to run through FBH
            stream: FirebaseFirestore.instance
                .collection(vendorCllctn)
                .doc(widget.model!.uid)
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
                        return UserItemsDesignWidget(
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
