import 'package:flutter/material.dart';
import 'package:hunger_box/model/vendors.dart';

class InfoDesignWidget extends StatefulWidget {
  Vendors? model;
  BuildContext? context;

  InfoDesignWidget({this.model, this.context});

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 153, 153, 153),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
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
                      widget.model!.vendorAvatarUrl!,
                      height: 165,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  widget.model!.name!,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20,
                    //fontFamily: "Raleway-SemiBold",
                  ),
                ),
                Text(
                  widget.model!.email!,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 15,
                    fontFamily: "Raleway-Italic",
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
