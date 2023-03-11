import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hunger_box/global/global.dart';
import 'package:hunger_box/mainScreens/vendor_home_screen.dart';
import 'package:hunger_box/model/items.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VendorsItemDetailsScreen extends StatefulWidget {
  final MenuItem? model;
  VendorsItemDetailsScreen({this.model});

  @override
  State<VendorsItemDetailsScreen> createState() =>
      _VendorsItemDetailsScreenState();
}

class _VendorsItemDetailsScreenState extends State<VendorsItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  /////Local delete menu item function/////
  deleteMenuItem(String itemID) async {
    FirebaseFirestore.instance
        .collection("vendors")
        .doc(sharedPreferences.getUID())
        .collection("items")
        .doc(itemID)
        .delete();
    // Message after deletion
    Fluttertoast.showToast(msg: "Item Deleted Successfully.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(widget.model!.itemTitle
            .toString()), // needs to be changed to reflect the vendor name the buyer clicked on
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.model!.thumbnailUrl.toString(),
            height: 250,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.itemTitle.toString(),
              style: const TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.itemInfo.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.itemInfoLong.toString(),
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "\$${widget.model!.priceStr}",
              style: const TextStyle(fontSize: 25),
            ),
          ),
          //Delete Button
          Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 120, 130, 100),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20)),
                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  ///Alert messege to ensure deletion///
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content:
                            Text("Are you sure you want to delete this item?"),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Text("Yes"),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            onPressed: () {
                              /// Delete Menu function HERE////
                              deleteMenuItem(widget.model!.itemID);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => VendorHomeScreen(),
                                ),
                              );
                            },
                          ),
                          ElevatedButton(
                            child: Text("No"),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
