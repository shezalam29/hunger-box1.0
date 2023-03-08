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
}

class MenuItem {
  late Map<String, dynamic> fields;

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
    fields = {
      MenusDoc.menuID: menuID,
      MenusDoc.vendorUID: vendorUID,
      MenusDoc.menuTitle: menuTitle,
      MenusDoc.menuInfo: menuInfo,
      MenusDoc.price: price,
      MenusDoc.datePublished: datePublished ?? DateTime.now(),
      MenusDoc.thumbnailUrl: thumbnailUrl,
      MenusDoc.status: status,
    };
  }
}
