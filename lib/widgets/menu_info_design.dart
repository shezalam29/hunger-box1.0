//49

import 'package:flutter/material.dart';

import 'package:hunger_box/global/global.dart';
import 'package:hunger_box/model/menu_items.dart';
import 'package:hunger_box/model/menus.dart';

import '../mainScreens/menu_items_screen.dart';

class InfoDesignWidget extends StatefulWidget {
  Menus? model;
  MenuItems? itemModel;
  BuildContext? context;

  InfoDesignWidget({this.model, this.context});

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: .8,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        // When an item is tapped
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => MenuItemsScreen(
                      model: widget.model, itemModel: widget.itemModel)));
        },
        splashColor: Color.fromARGB(255, 139, 139, 139),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 110,
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, //Align text to the left
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      widget.model!.thumbnailUrl!,
                      height: 180.0,
                      width: 190,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 1.0,
                  width: 1.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.model!.menuTitle!,
                        maxLines: 3,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis, // text overflow
                          color: Colors.black,
                          fontSize: 23,

                          fontFamily: "Raleway",
                        ),
                      ),
                      /*
                Text(
                  "\$${widget.model!.priceStr}",
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black,
                    fontSize: 17,
                    //fontFamily: "Raleway",
                  ),
                ),
                */
                      Text(
                        widget.model!.menuInfo!,
                        maxLines: 4,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Color.fromARGB(255, 120, 130, 100),
                          fontSize: 16,
                          fontFamily: "Raleway-Italic",
                        ),
                      ),
                    ],
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
