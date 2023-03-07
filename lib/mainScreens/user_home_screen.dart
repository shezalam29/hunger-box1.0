import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hunger_box/global/global.dart';

import '../widgets/user_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hunger_box/model/vendors.dart';

import '../widgets/info_design.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget.dart';

/// !!!!!!!!!!!!!!!!! THIS IS JUST A COPY OF THE CURRENT VENDOR_HOME_SCREEN !!!!!!!!!!!!!!!!!
/// for testing purposes

class UserHomeScreen extends StatefulWidget {
  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final items = [
    "slider/burger.jpg",
    "slider/eggstoast.jpg",
    "slider/fish.jpg",
    "slider/pestopasta.jpg",
    "slider/pizzabowl.jpg",
    "slider/salmon.jpg",
    "slider/steakchips.jpg",
    "slider/tomatosoo.jpg",
    "slider/whitebread.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawerUser(),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 188, 169, 146),
              Color.fromARGB(255, 120, 130, 100),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: Text(sharedPreferences.getName() ?? "NO NAME FOUND"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("vendors").snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverAlignedGrid.count(
                      crossAxisCount: 1,
                      //staggeredTileBuilder: (c) => StaggeredGridTile.fit(1),
                      itemBuilder: (context, index) {
                        Vendors model = Vendors.fromJson(
                            snapshot.data!.docs[index].data()!
                                as Map<String, dynamic>);
                        return InfoDesignWidget(
                          model: model,
                          context: context,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }
}
