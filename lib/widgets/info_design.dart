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
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(47, 128, 237, 1),
          width: 0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        splashColor: Colors.orange,
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
                    borderRadius: BorderRadius.circular(10.0),
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
                    color: Color.fromARGB(190, 0, 0, 0),
                    fontSize: 20,
                    fontFamily: "Raleway",
                  ),
                ),
                Text(
                  widget.model!.email!,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 108, 39, 39),
                    fontSize: 12,
                    fontFamily: "Raleway",
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
