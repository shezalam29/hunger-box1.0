import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hunger_box/global/global.dart';

import '../widgets/user_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hunger_box/model/vendors.dart';

import '../widgets/vendors_design.dart';
import '../widgets/progress_bar.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawerUser(),
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
            icon: const Icon(
              Icons.shopping_bag_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              // send user to cart screen
            },
          ),
          // Positioned(
          //   child: Stack(
          //     children: const [
          //       Icon(
          //         Icons.brightness_1,
          //         size: 20.0,
          //         color: Colors.green,
          //       ),
          //       // Positioned(
          //       //   top: 3,
          //       //   right: 5,
          //       //   child: Center(
          //       //     child: Text(
          //       //       "0",
          //       //       style: TextStyle(color: Colors.white, fontSize: 12),
          //       //     ),
          //       //   ),
          //       // ),
          //     ],
          //   ),
          // ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection(vendorCllctn).snapshots(),
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
                              as Map<String, dynamic>,
                        );
                        return VendorsDesignWidget(
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
