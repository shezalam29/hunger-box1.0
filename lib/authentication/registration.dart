import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hunger_box/mainScreens/vendor_home_screen.dart';
import 'package:hunger_box/mainScreens/user_home_screen.dart';
import 'package:hunger_box/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hunger_box/widgets/error_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hunger_box/widgets/loading_dialog.dart';
import '../global/global.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Vendor TextEditingControllers
  TextEditingController vendNameController = TextEditingController();
  TextEditingController vendPasswordController = TextEditingController();
  TextEditingController vendConfirmPasswordController = TextEditingController();
  TextEditingController vendEmailController = TextEditingController();
  TextEditingController vendConfirmEmailController = TextEditingController();
  TextEditingController vendLocationController = TextEditingController();
  //Student TextEditingControllers
  TextEditingController studNameController = TextEditingController();
  TextEditingController studPasswordController = TextEditingController();
  TextEditingController studConfirmPasswordController = TextEditingController();
  TextEditingController studEmailController = TextEditingController();
  TextEditingController studConfirmEmailController = TextEditingController();
  // TextEditingController studidController = TextEditingController(); // not yet implemented

  bool _isVendor = false;

  XFile? vendImageXFile;
  XFile? studImageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String vendorImageUrl = "";
  String completeAddress = "";

  /// Get an image from a picker and return it
  Future<XFile?> _getImage() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark pMark = placeMarks![0];
    completeAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';
    vendLocationController.text = completeAddress;
  }
  // getCurrentLocation

  /// Register and Authenticate a new user into the Firebase database
  Future<void> registerNewUser() async {
    if (!_isRegistrationFormValid()) {
      return;
    }

    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: "Registering",
          );
        });

    try {
      if (_isVendor) {
        await FBH.registerNewVendor(
            vendNameController.text,
            vendEmailController.text,
            vendPasswordController.text,
            vendLocationController.text,
            vendImageXFile!.path.trim(),
            position!.latitude,
            position!.longitude);
      } else {
        await FBH.registerNewStudent(
            studEmailController.text.trim(),
            studPasswordController.text,
            studNameController.text,
            studImageXFile!.path.trim()
            //,hunterId: int.parse(idController.text)
            );
      }
    } on FirebaseException catch (e) {
      Navigator.pop(context, true);
      _fbErrorHandler(e);
      return;
    }
    await sharedPreferences.setPreferenceData(
        uid: FBH.currentUser!.uid,
        name: FBH.currentUser!.email.toString(),
        email: _isVendor ? studNameController.text : vendNameController.text,
        avatar: FBH.avatarUrl);

    // Dismiss registering pop up
    Navigator.pop(context);
  }
  // registerNewUser

  @override
  Widget build(BuildContext context) {
    if (!_isVendor) {
      return _buildStudent(context);
    } else {
      return _buildVendor(context);
    }
  }

  // ==============================PRIVATE METHODS==============================

  /// Test whether registration forms have the appropriate forms filled in based
  /// on which user is registering as a vendor or a user. First does test
  bool _isRegistrationFormValid() {
    XFile? img;
    late Function passwordsEqual;
    late Function formChecker;

    // Set what variables to check so that we can call dialog boxes only once
    if (_isVendor) {
      img = vendImageXFile;
      passwordsEqual = () {
        return vendPasswordController.text !=
            vendConfirmPasswordController.text;
      };
      formChecker = _vendorFormValidation;
    } else {
      img = studImageXFile;
      passwordsEqual = () {
        return studPasswordController.text !=
            studConfirmPasswordController.text;
      };
      formChecker = _studentFormValidation;
    }

    if (img == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please choose an image.",
            );
          });
      return false;
    }

    if (passwordsEqual()) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Passwords do not match.",
            );
          });
      return false;
    }

    if (!formChecker()) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "One or more fields is incomplete.",
            );
          });
      return false;
    }

    return true;
  }

  /// Check whether the student form has all related forms filled in
  bool _studentFormValidation() {
    return (studConfirmPasswordController.text.isNotEmpty &&
            studEmailController.text.isNotEmpty &&
            studNameController.text.isNotEmpty
        /*&& idController.text.isNotEmpty*/
        );
  }

  /// Check whether the vendor form has all related forms filled in
  bool _vendorFormValidation() {
    return (_isVendor &&
        vendConfirmPasswordController.text.isNotEmpty &&
        vendEmailController.text.isNotEmpty &&
        vendNameController.text.isNotEmpty &&
        vendLocationController.text.isNotEmpty);
  }

  /// Build the user registration page
  Widget _buildStudent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                studImageXFile = await _getImage();
                setState(() {
                  studImageXFile;
                });
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * .2,
                backgroundColor: Colors.white,
                backgroundImage: studImageXFile == null
                    ? null
                    : FileImage(File(studImageXFile!.path)),
                child: studImageXFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: MediaQuery.of(context).size.width * .2,
                        color: Colors.blueGrey,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: studNameController,
                    hintText: "Name",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: studEmailController,
                    hintText: "College Email",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: studPasswordController,
                    hintText: "Password",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: studConfirmPasswordController,
                    hintText: "Confirm Password",
                    isObscure: false,
                  ),
                  // CustomTextField(
                  //   data: Icons.numbers,
                  //   controller: idController,
                  //   hintText: "Hunter ID",
                  //   isObscure: false,
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(25, 117, 244, 100),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
              onPressed: () {
                registerNewUser();
                Navigator.push(context, MaterialPageRoute(builder: (c) {
                  return const UserHomeScreen();
                }));
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    _isVendor = true;
                  });
                },
                child: const Text(
                  "Or Register as Vendor Here",
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                )),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  /// Build the vendor registration page
  Widget _buildVendor(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                vendImageXFile = await _getImage();
                setState(() {
                  vendImageXFile;
                });
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * .2,
                backgroundColor: Colors.white,
                backgroundImage: vendImageXFile == null
                    ? null
                    : FileImage(File(vendImageXFile!.path)),
                child: vendImageXFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: MediaQuery.of(context).size.width * .2,
                        color: Colors.blueGrey,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: vendNameController,
                    hintText: "Name",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: vendEmailController,
                    hintText: "Email",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: vendPasswordController,
                    hintText: "Password",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: vendConfirmPasswordController,
                    hintText: "Confirm Password",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.my_location,
                    controller: vendLocationController,
                    hintText: "Address",
                    isObscure: false,
                    enabled: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      label: const Text(
                        "Get My Location",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        getCurrentLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 120, 130, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(25, 117, 244, 100),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
              onPressed: () {
                registerNewUser();
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (c) {
                  return const VendorHomeScreen();
                }));
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    _isVendor = false;
                  });
                },
                child: const Text(
                  "Register as Student",
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                )),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  /// Output a [Dialog] box containing a FirebaseException to the screen
  void _fbErrorHandler(FirebaseException e) {
    String errorMsg = e.toString();
    errorMsg = errorMsg.split("] ")[1];
    showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: errorMsg,
          );
        });
  }
}
