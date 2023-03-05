//49

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hunger_box/model/menus.dart';

class InfoDesignWidget extends StatefulWidget {
  Menus? model;
  BuildContext? context;

  InfoDesignWidget({this.model, this.context});

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: .8,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        splashColor: Colors.orange,
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
                      widget.model!.thumbnailUrl!,
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
                  widget.model!.menuTitle!,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis, // text overflow
                    color: Colors.black,
                    fontSize: 20,
                    //fontFamily: "Arial",
                  ),
                ),
                Text(
                  r"$" + widget.model!.price!,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black,
                    fontSize: 17,
                    // fontFamily: "Train",
                  ),
                ),
                Text(
                  widget.model!.menuInfo!,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Color.fromARGB(255, 120, 130, 100),
                    fontSize: 14,
                    //fontFamily: "Train",
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