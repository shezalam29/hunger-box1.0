//49
import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? itemID;
  String? vendorUID;
  String? itemTitle;
  String? itemInfo;
  String? itemInfoLong;
  double? price;
  Timestamp? datePublished;
  String? thumbnailUrl;
  String? status;

  Items({
    this.itemID,
    this.vendorUID,
    this.itemTitle,
    this.price,
    this.itemInfo,
    this.itemInfoLong,
    this.datePublished,
    this.thumbnailUrl,
    this.status,
  });

  Items.fromJson(Map<String, dynamic> json) {
    itemID = json["itemID"];
    vendorUID = json["vendorUID"];
    itemTitle = json["itemTitle"];
    itemInfo = json["itemInfo"];
    itemInfoLong = json["itemInfoLong"];
    price = json["price"];
    datePublished = json["datePublished"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["itemID"] = itemID;
    data["vendorUID"] = vendorUID;
    data["itemTitle"] = itemTitle;
    data["itemInfo"] = itemInfo;
    data["price"] = price;
    data["datePublished"] = datePublished;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;

    return data;
  }
}
