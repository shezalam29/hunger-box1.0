import 'package:flutter/material.dart';
import 'package:hunger_box/global/global.dart';
import 'package:hunger_box/model/items.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:badges/badges.dart' as badges;

class ItemDetailsScreen extends StatefulWidget {
  final MenuItem? model;
  ItemDetailsScreen({this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

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
                child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      print("cart button pressed");
                    }),
              ),
            ),
          ],
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
              padding: const EdgeInsets.only(
                left: 100.0,
                right: 100,
                top: 25,
                bottom: 25,
              ),
              child: NumberInputWithIncrementDecrement(
                controller: counterTextEditingController,
                incDecBgColor: Color.fromARGB(255, 120, 130, 100),
                min: 1,
                max: 9,
                initialValue: 1,
                buttonArrangement: ButtonArrangement.rightEnd,
              ),
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
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 120, 130, 100),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20)),
                onPressed: () {
                  // add item to cart not done
                },
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
