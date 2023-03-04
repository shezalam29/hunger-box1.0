//49
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Menus {
  String? menuID;
  String? vendorUID;
  String? menuTitle;
  String? menuInfo;
  String? price;
  Timestamp? datePublished;
  String? thumbnailUrl;
  String? status;

  Menus({
    this.menuID,
    this.vendorUID,
    this.menuTitle,
    this.price,
    this.menuInfo,
    this.datePublished,
    this.thumbnailUrl,
    this.status,
  });
  Menus.fromJson(Map<String, dynamic> json) {
    menuID = json["menuID"];
    vendorUID = json["vendorUID"];
    menuTitle = json["menuTitle"];
    menuInfo = json["menuInfo"];
    price = json["price"];
    datePublished = json["datePublished"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["menuID"] = menuID;
    data["vendorUID"] = vendorUID;
    data["menuTitle"] = menuTitle;
    data["menuInfo"] = menuInfo;
    data["price"] = price;
    data["datePublished"] = datePublished;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;

    return data;
  }
}
