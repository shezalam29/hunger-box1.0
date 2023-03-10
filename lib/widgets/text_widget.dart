// Widget for header text
import 'package:flutter/material.dart';

class TextWidgetHeader extends SliverPersistentHeaderDelegate {
  String? title;
  TextWidgetHeader({this.title});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return InkWell(
        child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 80, 82, 71),
            ),
            height: 80.0,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: InkWell(
              child: ListTile(
                title: Text(
                  title!,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            )));
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
