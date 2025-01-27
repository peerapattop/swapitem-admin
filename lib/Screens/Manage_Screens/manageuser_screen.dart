import 'package:admin/Screens/Manage_Screens/UserData.dart';
import 'package:admin/Screens/appbar.dart';
import 'package:admin/Screens/Showdata_screens/showdatauser_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});
  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  String? _searchString;
  TextEditingController searchController = TextEditingController();

  final _userRef = FirebaseDatabase.instance.ref().child('users');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppbar('จัดการข้อมูลผู้ใช้'),
        body: StreamBuilder(
          stream: _userRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator(), Text('กำลังโหลด..')],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("ไม่มีข้อมูล"),
              );
            }

            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            Map<dynamic, dynamic>? dataMap = dataSnapshot.value as Map?;

            if (dataMap == null || dataMap.isEmpty) {
              return const Center(
                child: Text("ไม่มีข้อมูล"),
              );
            }

            return Column(
              children: <Widget>[
                searchDataUser(),
                Expanded(
                  child: ListView.builder(
                    itemCount: dataMap.length,
                    itemBuilder: (context, index) {
                      dynamic userData = dataMap.values.elementAt(index);
                      String uid = userData['uid'].toString();
                      String id = userData['id'].toString();
                      String username = userData['username'].toString();
                      String email = userData['email'].toString();
                      String firstname = userData['firstname'].toString();
                      String lastname = userData['lastname'].toString();
                      String birthday = userData['birthday'].toString();
                      String userImage = userData['image_user'].toString();
                      String gender = userData['gender'].toString();

                      if (_searchString != null && _searchString!.isNotEmpty) {
                        String lowerCaseSearchString =
                            _searchString!.toLowerCase();
                        if (!(username
                                .toLowerCase()
                                .contains(lowerCaseSearchString) ||
                            email
                                .toLowerCase()
                                .contains(lowerCaseSearchString) ||
                            id.toLowerCase().contains(lowerCaseSearchString))) {
                          return Container();
                        }
                      }

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(5),
                        child: ListTile(
                          title: Text(username),
                          subtitle: Text(email),
                          leading: CircleAvatar(
                            child: FittedBox(
                              child: Text(id),
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Navigate to the show data user screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowDataUser(
                                    userData: UserData(
                                      uid: uid,
                                      id: id,
                                      username: username,
                                      email: email,
                                      firstname: firstname,
                                      lastname: lastname,
                                      gender: gender,
                                      user_image: userImage,
                                      birthday: birthday,
                                    ),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 46, 246, 32),
                              fixedSize: const Size(35, 20),
                            ),
                            child: Image.asset(
                              "assets/icons/search.png",
                              width: 18,
                              height: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void performSearch() {
    setState(() {
      _searchString = searchController.text.toLowerCase();
    });
  }

  Widget searchDataUser() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: searchController,
        onChanged: (val) {
          _searchString = val.toLowerCase();
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0.8),
          ),
          hintText: "ค้นหา",
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () {
                  // Only perform search if the search string is not empty
                  if (_searchString != null && _searchString!.isNotEmpty) {
                    performSearch();
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  setState(() {
                    searchController.clear();
                    _searchString = '';
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
