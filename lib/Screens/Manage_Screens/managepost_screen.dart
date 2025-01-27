import 'package:flutter/material.dart';
import 'package:admin/Screens/appbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:admin/Screens/Manage_Screens/postData.dart';
import 'package:admin/Screens/Showdata_screens/showdatapost_screen.dart';

class ManagePost extends StatefulWidget {
  const ManagePost({super.key});

  @override
  State<ManagePost> createState() => _ManagePostState();
}

class _ManagePostState extends State<ManagePost> {
  String? _searchString;
  TextEditingController searchController = TextEditingController();
  final _postRef = FirebaseDatabase.instance.ref().child('postitem');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppbar("จัดการโพสต์"),
        body: StreamBuilder(
          stream: _postRef.onValue,
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
                searchDataPost(),
                //แสดงข้อมูลผู้ใช้
                Expanded(
                  child: ListView.builder(
                    itemCount: dataMap.length,
                    itemBuilder: (context, index) {
                      dynamic userData = dataMap.values.elementAt(index);
                      String postNumber = userData['postNumber'].toString();
                      String username = userData['username']..toString();
                      String email = userData['email'].toString();
                      String brand = userData['brand'].toString();
                      String brand1 = userData['brand1'].toString();
                      String date = userData['date'].toString();
                      // String detail = userData['detail'].toString();
                      String details1 = userData['details1'].toString();
                      String itemName = userData['item_name'].toString();
                      String itemName1 = userData['item_name1'].toString();
                      String model = userData['model'].toString();
                      String model1 = userData['model1'].toString();
                      String time = userData['time'].toString();
                      String type = userData['type'].toString();
                      String longitude = userData['longitude'].toString();
                      String latitude = userData['latitude'].toString();
                      String postUid = userData['post_uid'].toString();

                      if (_searchString != null && _searchString!.isNotEmpty) {
                        String lowerCaseSearchString =
                            _searchString!.toLowerCase();
                        if (!(username
                                .toLowerCase()
                                .contains(lowerCaseSearchString) ||
                            email
                                .toLowerCase()
                                .contains(lowerCaseSearchString) ||
                            postNumber
                                .toLowerCase()
                                .contains(lowerCaseSearchString))) {
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
                              child: Text(postNumber.toString()),
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowDataPost(
                                    postData: PostData(
                                      post_uid: postUid,
                                      latitude: latitude,
                                      longitude: longitude,
                                      brand: brand,
                                      brand1: brand1,
                                      username: username,
                                      email: email,
                                      date: date,
                                      detail: details1,
                                      details1: details1,
                                      imageUrls: List<String>.from(userData['imageUrls']),
                                      item_name: itemName,
                                      item_name1: itemName1,
                                      model: model,
                                      model1: model1,
                                      postNumber: postNumber,
                                      time: time,
                                      type: type,
                                    ),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 46, 246, 32),
                              fixedSize: Size(35, 20),
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

  Widget searchDataPost() {
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

  void performSearch() {
    setState(() {
      _searchString = searchController.text.toLowerCase();
    });
  }
}
