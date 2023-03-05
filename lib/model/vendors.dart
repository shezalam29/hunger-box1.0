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
    vendorUID = json["vendorUID"];
    name = json["name"];
    vendorAvatarUrl = json["vendorAvatarUrl"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["vendorUID"] = this.vendorUID;
    data["name"] = this.name;
    data["vendorAvatarUrl"] = this.vendorAvatarUrl;
    data["email"] = this.email;

    return data;
  }
}
