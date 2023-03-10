import 'package:flutter/material.dart';
import 'package:hunger_box/mainScreens/user_items_screen.dart';
import 'package:hunger_box/global/global.dart';

class VendorsDesignWidget extends StatefulWidget {
  Vendor? model;
  BuildContext? context;

  VendorsDesignWidget({this.model, this.context});

  @override
  State<VendorsDesignWidget> createState() => _VendorsDesignWidgetState();
}

class _VendorsDesignWidgetState extends State<VendorsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 153, 153, 153),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => UserItemsScreen(model: widget.model)));
        },
        splashColor: const Color.fromARGB(255, 255, 255, 255),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 220,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, //Align text to the left
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      widget.model!.vendorAvatarUrl,
                      height: 165,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.model!.name,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                      //fontFamily: "Raleway-SemiBold",
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.model!.email,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 15,
                      fontFamily: "Raleway-Italic",
                    ),
                  ),
                ),
                // Divider(
                //   height: 4,
                //   thickness: 3,
                //   color: Colors.grey[300],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
