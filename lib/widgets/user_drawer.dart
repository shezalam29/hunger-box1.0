import 'package:flutter/material.dart';
import 'package:hunger_box/authentication/auth_screen.dart';
import 'package:hunger_box/global/global.dart';

class MyDrawerUser extends StatefulWidget {
  const MyDrawerUser({super.key});

  @override
  State<MyDrawerUser> createState() => _MyDrawerUserState();
}

class _MyDrawerUserState extends State<MyDrawerUser> {
  @override
  Widget build(BuildContext context) {
    var key = 'name';
    var key2 = key;
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          //Accessing firebase image URL
                          sharedPreferences.getAvatar() ?? "no avatar",
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  sharedPreferences.getName() ?? "NO NAME FOUND",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [
                const Divider(height: 10, color: Colors.grey, thickness: 1),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {},
                ),
                const Divider(height: 10, color: Colors.grey, thickness: 1),
                ListTile(
                  leading: const Icon(
                    Icons.monetization_on,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "My Orders",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {},
                ),
                const Divider(height: 10, color: Colors.grey, thickness: 1),
                ListTile(
                  leading: const Icon(
                    Icons.reorder,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "History",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {},
                ),
                const Divider(height: 10, color: Colors.grey, thickness: 1),
                ListTile(
                  leading: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Search",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {},
                ),
                const Divider(height: 10, color: Colors.grey, thickness: 1),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    firebaseAuth.signOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const AuthScreen()));
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*class MyDrawerUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            sharedPreferences!.getString("photoUrl")!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  sharedPreferences!.getString("vendorName")!,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} */
