import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hunger_box/fb_handler/fb_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hunger_box/mainScreens/home_screen.dart';
import 'package:hunger_box/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hunger_box/widgets/error_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hunger_box/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool _isVendor = false;

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String vendorImageUrl = "";
  String completeAddress = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
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
    locationController.text = completeAddress;
  }

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

    if (_isVendor) {
      await FBH.registerNewVendor(
        nameController.text,
        emailController.text,
        passwordController.text,
        locationController.text,
        imageXFile!.path.trim(),
        position!.latitude,
        position!.longitude,
      );
    } else {
      await FBH.registerNewStudent(
        emailController.text.trim(),
        passwordController.text,
        firstName: nameController.text,
        lastName: lastNameController.text,
        hunterId: int.parse(idController.text),
      );
    }

    Navigator.pop(context);
    //send the user to home page
    ////////////THISSSSSS PART IS IMPORTANT///////////////
    Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreen());
    Navigator.pushReplacement(context, newRoute);

    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", FBH.currentUser!.uid);
    await sharedPreferences!
        .setString("email", FBH.currentUser!.email.toString());
    await sharedPreferences!
        .setString("vendorName", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", vendorImageUrl);
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please choose an image.",
            );
          });
    } else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty &&
            locationController.text.isNotEmpty) {
          // upload image to firestore

          showDialog(
              context: context,
              builder: (c) {
                return LoadingDialog(
                  message: "Registering",
                );
              });
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fstorage.Reference reference = fstorage.FirebaseStorage.instance
              .ref()
              .child("vendors")
              .child(fileName);
          fstorage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
          fstorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            vendorImageUrl = url;
            // save registration information to firestore
            authenticateSellerAndSignUp();
          });
        } else {
          showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(
                  message: "One or more fields is incomplete.",
                );
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Passwords do not match.",
              );
            });
      }
    }
  }

  void authenticateSellerAndSignUp() async {
    User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });

    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        //send the user to home page
        ////////////THISSSSSS PART IS IMPORTANT///////////////
        Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection("vendors").doc(currentUser.uid).set({
      "vendorUID": currentUser.uid,
      "vendorEmail": currentUser.email,
      "vendorName": nameController.text.trim(),
      "vendorAvatarUrl": vendorImageUrl,
      "address": completeAddress,
      "status": "approved",
      "earnings": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", vendorImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    //   return SingleChildScrollView(
    //     child: Container(
    //       child: Column(
    //         mainAxisSize: MainAxisSize.max,
    //         children: [
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           InkWell(
    //             onTap: () {
    //               _getImage();
    //             },
    //             child: CircleAvatar(
    //               radius: MediaQuery.of(context).size.width * .2,
    //               backgroundColor: Colors.white,
    //               backgroundImage: imageXFile == null
    //                   ? null
    //                   : FileImage(File(imageXFile!.path)),
    //               child: imageXFile == null
    //                   ? Icon(
    //                       Icons.add_photo_alternate,
    //                       size: MediaQuery.of(context).size.width * .2,
    //                       color: Colors.blueGrey,
    //                     )
    //                   : null,
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 3,
    //           ),
    //           Form(
    //             key: _formKey,
    //             child: Column(
    //               children: [
    //                 CustomTextField(
    //                   data: Icons.person,
    //                   controller: nameController,
    //                   hintText: "Name",
    //                   isObscure: false,
    //                 ),
    //                 CustomTextField(
    //                   data: Icons.lock,
    //                   controller: passwordController,
    //                   hintText: "Password",
    //                   isObscure: false,
    //                 ),
    //                 CustomTextField(
    //                   data: Icons.lock,
    //                   controller: confirmPasswordController,
    //                   hintText: "Confirm Password",
    //                   isObscure: false,
    //                 ),
    //                 CustomTextField(
    //                   data: Icons.email,
    //                   controller: emailController,
    //                   hintText: "Email",
    //                   isObscure: false,
    //                 ),
    //                 CustomTextField(
    //                   data: Icons.my_location,
    //                   controller: locationController,
    //                   hintText: "Address",
    //                   isObscure: false,
    //                   enabled: true,
    //                 ),
    //                 const SizedBox(
    //                   height: 15,
    //                 ),
    //                 Container(
    //                   width: 400,
    //                   height: 40,
    //                   alignment: Alignment.center,
    //                   child: ElevatedButton.icon(
    //                     label: const Text(
    //                       "Get My Location",
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                     icon: const Icon(
    //                       Icons.location_on,
    //                       color: Colors.white,
    //                     ),
    //                     onPressed: () {
    //                       getCurrentLocation();
    //                     },
    //                     style: ElevatedButton.styleFrom(
    //                       primary: Color.fromARGB(255, 120, 130, 100),
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(30),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 30,
    //           ),
    //           ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //                 primary: const Color.fromRGBO(25, 117, 244, 100),
    //                 padding:
    //                     const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
    //             onPressed: () {
    //               formValidation();
    //             },
    //             child: const Text(
    //               "Sign Up",
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
    if (!_isVendor) {
      return _buildUser(context);
    } else {
      return _buildVendor(context);
    }
  }

  /// Test whether registration forms have the appropriate forms filled in based
  /// on which user is registering as a vendor or a user
  bool _isRegistrationFormValid() {
    if (imageXFile == null && _isVendor) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please choose an image.",
            );
          });
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Passwords do not match.",
            );
          });
      return false;
    } else if (!_studentFormValidation() && !_vendorFormValidation()) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "One or more fields is incomplete.",
            );
          });
    }

    return true;
  }

  /// Check whether the student form has all related forms filled in
  bool _studentFormValidation() {
    return (!_isVendor &&
        confirmPasswordController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        idController.text.isNotEmpty);
  }

  /// Check whether the vendor form has all related forms filled in
  bool _vendorFormValidation() {
    return (_isVendor &&
        confirmPasswordController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        locationController.text.isNotEmpty);
  }

  Widget _buildUser(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: "First Name",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.person,
                    controller: lastNameController,
                    hintText: "Last Name",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.numbers,
                    controller: idController,
                    hintText: "Hunter ID",
                    isObscure: false,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
              onPressed: () {
                registerNewUser();
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
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    _isVendor = true;
                  });
                },
                child: const Text(
                  "Register as Vendor",
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                )),
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
              onTap: () {
                _getImage();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * .2,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile == null
                    ? null
                    : FileImage(File(imageXFile!.path)),
                child: imageXFile == null
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
                    controller: nameController,
                    hintText: "Name",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObscure: false,
                  ),
                  CustomTextField(
                    data: Icons.my_location,
                    controller: locationController,
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
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    _isVendor = false;
                  });
                },
                child: Text(
                  "Register as Student",
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                )),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
