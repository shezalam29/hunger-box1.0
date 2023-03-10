//NEW

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/menu_items.dart';

class MenuItemsDesignWidget extends StatefulWidget {
  MenuItems? itemModel;
  BuildContext? context;

  MenuItemsDesignWidget({this.itemModel, this.context});

  @override
  State<MenuItemsDesignWidget> createState() => _MenuItemsDesignWidgetState();
}

class _MenuItemsDesignWidgetState extends State<MenuItemsDesignWidget> {
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
        onTap: () {
          /* 
         Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => //// Not implemented ///
       */
        },
        splashColor: Color.fromARGB(255, 139, 139, 139),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 185,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, //Align text to the left
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      widget.itemModel!.thumbnailUrl!,
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
                  widget.itemModel!.itemTitle!,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  r"$" + widget.itemModel!.price!.toStringAsFixed(2), //

                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
                Text(
                  widget.itemModel!.itemDescription!,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Color.fromARGB(255, 120, 130, 100),
                    fontSize: 14,
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
