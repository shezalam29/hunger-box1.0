//53
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItems {
  String? menuID;
  String? vendorUID;
  String? vendorName;
  String? itemDescription;
  String? itemID;
  String? itemTitle;
  double? price;
  Timestamp? datePublished;
  String? thumbnailUrl;
  String? status;

  MenuItems({
    this.menuID,
    this.vendorUID,
    this.itemID,
    this.price,
    this.vendorName,
    this.datePublished,
    this.thumbnailUrl,
    this.status,
    this.itemDescription,
    this.itemTitle,
  });

  MenuItems.fromJson(Map<String, dynamic> json) {
    menuID = json["menuID"];
    vendorUID = json["sellerUID"];
    itemTitle = json["itemTitle"];
    itemDescription = json["itemDescription"];
    price = json["price"].toDouble(); ////
    datePublished = json["datePublished"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
    vendorName = json["sellerName"];
    itemID = json["itemID"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["menuID"] = menuID;
    data["vendorID"] = vendorUID;
    data["itemTitle"] = itemTitle;
    data["menuDescription"] = itemDescription;
    data["itemID"] = itemID;
    data["vendorName"] = vendorName;
    data["price"] = price;
    data["datePublished"] = datePublished;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;

    return data;
  }
}
