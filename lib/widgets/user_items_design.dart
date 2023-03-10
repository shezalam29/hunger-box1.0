//49

import 'package:flutter/material.dart';

// import 'package:hunger_box/model/menus.dart';
import 'package:hunger_box/global/global.dart';
import 'package:hunger_box/mainScreens/item_details_screen.dart';

class UserItemsDesignWidget extends StatefulWidget {
  MenuItem? model;
  BuildContext? context;

  UserItemsDesignWidget({this.model, this.context});

  @override
  State<UserItemsDesignWidget> createState() => _UserItemsDesignWidgetState();
}

class _UserItemsDesignWidgetState extends State<UserItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: .8,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => ItemDetailsScreen(model: widget.model)));
        },
        splashColor: const Color.fromARGB(255, 139, 139, 139),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 190,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, //Align text to the left
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      widget.model!.thumbnailUrl,
                      height: 120.0,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 1.0,
                ),
                Text(
                  widget.model!.itemTitle,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis, // text overflow
                    color: Colors.black,
                    fontSize: 20,
                    //fontFamily: "Raleway",
                  ),
                ),
                Text(
                  "\$${widget.model!.priceStr}",
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black,
                    fontSize: 17,
                    //fontFamily: "Raleway",
                  ),
                ),
                Text(
                  widget.model!.itemInfo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Color.fromARGB(255, 120, 130, 100),
                    fontSize: 14,
                    fontFamily: "Raleway-Italic",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
