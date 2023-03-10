import 'package:hunger_box/hungerbox_pref/hungerbox_pref.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hunger_box/global/global.dart';

void main() async {
  // TestWidgetsFlutterBinding.ensureInitialized();
  FirebaseDataObject x = FirebaseDataObject.fromKeys(["hello", "world"]);
  print(x.fields);

  FirebaseDataObject y =
      FirebaseDataObject.fromMap({"Hello": "World", "Answer to life": 42});
  print(y.fields);

  FirebaseDataObject z = FirebaseDataObject.fromJson(
      {"What is": "My life", "age": 18},
      expected: ["What is", "Fake Key"]);
  print(z.fields);
  print("===========");

  Vendor v = Vendor(
      address: "right here",
      earnings: 1.00,
      lat: 12.0,
      lng: 13.0,
      status: "approved",
      vendorAvatarUrl: "mydick.jpg",
      vendorEmail: "aauyong11@gmail.com",
      vendorName: "me",
      vendorUID: '123456');
  print(v.fields);
  print("===========");

  Vendor v2 = Vendor.fromJson(
      {VendorDoc.address: "Around", VendorDoc.email: "dick@me.com"},
      expected: VendorDoc.fields);
  print(v2.fields);

  print("===========");

  Vendor v3 = Vendor.fromJson(
      {VendorDoc.address: "Around", VendorDoc.email: "dick@me.com"});
  print(v3.fields);
}
