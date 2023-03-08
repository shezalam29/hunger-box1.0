import 'package:hunger_box/global/global.dart';

class Vendors {
  String? vendorUID;
  String? name;
  String? vendorAvatarUrl;
  String? email;

  Vendors({
    this.vendorUID,
    this.name,
    this.vendorAvatarUrl,
    this.email,
  });

  Vendors.fromJson(Map<String, dynamic> json) {
    vendorUID = json[VendorDoc.uid];
    name = json[VendorDoc.name];
    vendorAvatarUrl = json[VendorDoc.avatarUrl];
    email = json[VendorDoc.email];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      VendorDoc.uid: vendorUID,
      VendorDoc.name: name,
      VendorDoc.avatarUrl: vendorAvatarUrl,
      VendorDoc.email: email,
    };

    return data;
  }
}
