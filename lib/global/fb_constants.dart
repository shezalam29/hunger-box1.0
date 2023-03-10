part of lib.globals;

/// Set of constants that the firebase uses

class _FirebaseDataObject {
  late Map<String, dynamic> fields;

  _FirebaseDataObject() {
    fields = {};
  }

  _FirebaseDataObject.fromKeys(List<String> keys) {
    fields = {for (var f in keys) f: null};
  }

  _FirebaseDataObject.fromMap(Map<String, dynamic> m) : fields = m;

  _FirebaseDataObject.fromJson(Map<String, dynamic> values,
      {List<String>? expected}) {
    if (expected != null) {
      fields = {
        for (var f in expected) f: values.containsKey(f) ? values[f] : null
      };
    } else {
      fields = values;
    }
  }
}

// ===========================================================================

const String vendorCllctn = "vendors";

class VendorDoc {
  static const String address = "address";
  static const String earnings = "earnings";
  static const String lat = "lat";
  static const String lng = "lng";
  static const String status = "status";
  static const String avatarUrl = "vendorAvatarUrl";
  static const String email = "email";
  static const String name = "name";
  static const String uid = "vendorUID";

  static const List<String> fields = [
    address,
    earnings,
    lat,
    lng,
    status,
    avatarUrl,
    email,
    name,
    uid,
  ];
}

class Vendor extends _FirebaseDataObject {
  Vendor({
    String address = "",
    double earnings = 0.00,
    String vendorEmail = "",
    String vendorAvatarUrl = "",
    double lat = -1,
    double lng = -1,
    String status = "",
    String vendorName = "",
    String vendorUID = "",
  }) : super.fromKeys(VendorDoc.fields) {
    fields[VendorDoc.address] = address;
    fields[VendorDoc.earnings] = earnings;
    fields[VendorDoc.lat] = lat;
    fields[VendorDoc.lng] = lng;
    fields[VendorDoc.status] = status;
    fields[VendorDoc.avatarUrl] = vendorAvatarUrl;
    fields[VendorDoc.email] = vendorEmail;
    fields[VendorDoc.name] = vendorName;
    fields[VendorDoc.uid] = vendorUID;
  }

  Vendor.fromJson(Map<String, dynamic> values, {List<String>? expected})
      : super.fromJson(values, expected: expected);

  Vendor.fromMap(Map<String, dynamic> m) : super.fromMap(m);

  String get address {
    return fields[VendorDoc.address];
  }

  String get email {
    return fields[VendorDoc.email];
  }

  String get name {
    return fields[VendorDoc.name];
  }

  String get uid {
    return fields[VendorDoc.uid];
  }

  dynamic get vendorAvatarUrl {
    return fields[VendorDoc.avatarUrl];
  }
} // Vendor

// ===========================================================================

const String studentCllctn = "students";

class StudentDoc {
  static const String points = "currentPoints";
  static const String email = "email";
  static const String name = "name";
  static const String avatarUrl = "studentAvatarUrl";
  static const String uid = "studentUID";

  /// Not yet implemented
  // static const String HUNTERID = "hunterId";
}

class Student {
  late Map<String, dynamic> fields;

  Student({
    int currentPoints = 0,
    String email = "",
    String firstName = "",
    String avatarUrl = "not found",
    int hunterId = -1,
    String uid = "NOTSET",
  }) {
    fields = {
      StudentDoc.points: currentPoints,
      StudentDoc.email: email,
      StudentDoc.name: firstName,
      StudentDoc.avatarUrl: avatarUrl,
      StudentDoc.uid: uid,
      // STUDENT.HUNTERID: hunterId, // IMPLEMENT LATER
    };
  }
}

// ===========================================================================

const String itemsCllctn = "items";

class ItemsDoc {
  static const String itemID = "itemID";
  static const String vendorUID = "vendorUID";
  static const String itemTitle = "itemTitle";
  static const String itemInfo = "itemInfo";
  static const String itemInfoLong = "itemInfoLong";
  static const String price = "price";
  static const String datePublished = "datePublished";
  static const String thumbnailUrl = "thumbnailUrl";
  static const String status = "status";
  static const String points = "points";

  static const List<String> fields = [
    itemID,
    vendorUID,
    itemTitle,
    itemInfo,
    itemInfoLong,
    price,
    datePublished,
    thumbnailUrl,
    status,
    points,
  ];
}

class MenuItem extends _FirebaseDataObject {
  MenuItem({
    String itemID = "",
    String vendorUID = "",
    String itemTitle = "",
    String itemInfo = "",
    String itemInfoLong = "",
    double price = 0.00,
    DateTime? datePublished,
    String thumbnailUrl = "",
    String status = "",
    int points = 0,
  }) : super.fromKeys(ItemsDoc.fields) {
    fields[ItemsDoc.itemID] = itemID;
    fields[ItemsDoc.vendorUID] = vendorUID;
    fields[ItemsDoc.itemTitle] = itemTitle;
    fields[ItemsDoc.itemInfo] = itemInfo;
    fields[ItemsDoc.itemInfoLong] = itemInfoLong;
    fields[ItemsDoc.price] = price;
    fields[ItemsDoc.datePublished] = datePublished ?? DateTime.now();
    fields[ItemsDoc.thumbnailUrl] = thumbnailUrl;
    fields[ItemsDoc.status] = status;
    fields[ItemsDoc.points] = points;
  }

  String get itemID {
    return fields[ItemsDoc.itemID];
  }

  String get itemTitle {
    return fields[ItemsDoc.itemTitle];
  }

  String get itemInfo {
    return fields[ItemsDoc.itemInfo];
  }

  String get itemInfoLong {
    return fields[ItemsDoc.itemInfoLong];
  }

  String get priceStr {
    return fields[ItemsDoc.price].toStringAsFixed(2);
  }

  String get price {
    return fields[ItemsDoc.price];
  }

  String get thumbnailUrl {
    return fields[ItemsDoc.thumbnailUrl];
  }

  MenuItem.fromJson(Map<String, dynamic> json, {List<String>? expected})
      : super.fromJson(json, expected: expected);
} // MenuItem

// ===========================================================================

const String cartCllctn = "userCart";

class CartItemDoc {
  static const String itemID = "itemID";
  static const String itemName = "itemName";
  static const String itemQty = "itemQty";
  static const String itemNote = "itemNote";

  static const List<String> fields = [
    itemID,
    itemName,
    itemQty,
    itemNote,
  ];
}

class CartItem {
  Map<String, dynamic> fields = {for (var f in CartItemDoc.fields) f: null};

  CartItem({
    String itemID = "",
    String itemName = "",
    String itemQty = "",
    String itemNote = "",
  }) {
    fields[CartItemDoc.itemID] = itemID;
    fields[CartItemDoc.itemName] = itemName;
    fields[CartItemDoc.itemQty] = itemQty;
    fields[CartItemDoc.itemNote] = itemNote;
  }
}
