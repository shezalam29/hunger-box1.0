part of lib.globals;

/// Set of constants that the firebase uses

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
}

class Vendor {
  late Map<String, dynamic> fields;

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
  }) {
    fields = {
      VendorDoc.address: address,
      VendorDoc.earnings: earnings,
      VendorDoc.lat: lat,
      VendorDoc.lng: lng,
      VendorDoc.status: status,
      VendorDoc.avatarUrl: vendorAvatarUrl,
      VendorDoc.email: vendorEmail,
      VendorDoc.name: vendorName,
      VendorDoc.uid: vendorUID,
    };
  }

  String get address {
    return fields[VendorDoc.address];
  }

  String get uid {
    return fields[VendorDoc.uid];
  }
} // Vendor

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

const String menusCllctn = "menus";

class MenusDoc {
  static const String menuID = "menuID";
  static const String vendorUID = "vendorUID";
  static const String menuTitle = "menuTitle";
  static const String menuInfo = "menuInfo";
  static const String price = "price";
  static const String datePublished = "datePublished";
  static const String thumbnailUrl = "thumbnailUrl";
  static const String status = "status";
  static const List<String> fields = [
    menuID,
    vendorUID,
    menuTitle,
    menuInfo,
    price,
    datePublished,
    thumbnailUrl,
    status,
  ];
}

class MenuItem {
  Map<String, dynamic> fields = {for (var f in MenusDoc.fields) f: null};

  MenuItem({
    String menuID = "",
    String vendorUID = "",
    String menuTitle = "",
    String menuInfo = "",
    double price = 0.00,
    DateTime? datePublished,
    String thumbnailUrl = "",
    String status = "",
  }) {
    fields[MenusDoc.menuID] = menuID;
    fields[MenusDoc.vendorUID] = vendorUID;
    fields[MenusDoc.menuTitle] = menuTitle;
    fields[MenusDoc.menuInfo] = menuInfo;
    fields[MenusDoc.price] = price;
    fields[MenusDoc.datePublished] = datePublished ?? DateTime.now();
    fields[MenusDoc.thumbnailUrl] = thumbnailUrl;
    fields[MenusDoc.status] = status;
  }

  String get menuID {
    return fields[MenusDoc.menuID];
  }

  String get menuTitle {
    return fields[MenusDoc.menuTitle];
  }

  String get menuInfo {
    return fields[MenusDoc.menuInfo];
  }

  String get priceStr {
    return fields[MenusDoc.price].toStringAsFixed(2);
  }

  String get price {
    return fields[MenusDoc.price];
  }

  String get thumbnailUrl {
    return fields[MenusDoc.thumbnailUrl];
  }

  /// Create a [MenuItem] from a Map. Checks that none of the required
  /// keys are missing
  MenuItem.fromJson(Map<String, dynamic> json) {
    for (var key in MenusDoc.fields) {
      fields[key] = json.containsKey(key) ? json[key] : "";
    }
  }
} // MenuItem

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

class OrderDoc {}

class Order {}
