import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hunger_box/global/global.dart';
import 'package:hunger_box/uploadScreen/menus_upload.dart';

import '../widgets/drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hunger_box/model/menus.dart';

import '../widgets/menu_info_design.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget.dart';

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
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const MenusUpload()));
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
            stream: FBH
                .getDocument(vendorCllctn, sharedPreferences.getUID()!)
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
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,

                      // staggeredTileBuilder: (c) => StaggeredTile.fit(1),
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
}
