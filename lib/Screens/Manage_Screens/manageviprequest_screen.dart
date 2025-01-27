import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:admin/Screens/Manage_Screens/vipData.dart';
import 'package:admin/Screens/Showdata_screens/showdataviprequest_screen.dart';
import 'package:admin/Screens/appbar.dart';

class VipRequest extends StatefulWidget {
  const VipRequest({Key? key}) : super(key: key);

  @override
  _VipRequestState createState() => _VipRequestState();
}

class _VipRequestState extends State<VipRequest> {
  TextEditingController searchController = TextEditingController();
  String? _searchString;
  final _vipRef = FirebaseDatabase.instance.ref().child('requestvip');

  Future<Map<String, dynamic>> fetchUserData(String userUid) async {
    try {
      // Get the DataSnapshot from the DatabaseEvent
      final DatabaseEvent event = await FirebaseDatabase.instance.ref().child('users').child(userUid).once();
      final DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null) {
        // Cast to `Map<Object?, Object?>` first to ensure compatibility
        final dynamic value = dataSnapshot.value as Map<Object?, Object?>;

        // Create a new map with correct type safety
        return {for (final key in value.keys) key: value[key]};
      } else {
        return {}; // Handle user not found or other errors
      }
    } catch (error) {
      // Handle potential errors during data fetching or conversion
      print('Error fetching user data: $error');
      return {}; // Send empty data on error (or consider more specific handling)
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppbar('คำขอสมัคร VIP'),
        body: Column(
          children: <Widget>[
            searchDataVip(),
            Expanded(
              child: StreamBuilder(
                stream: _vipRef.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text('กำลังโหลด..')
                        ],
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

                  List<dynamic> filteredData = dataMap.values.where((vipData) {
                    if (_searchString != null && _searchString!.isNotEmpty) {
                      String lowerCaseSearchString =
                          _searchString!.toLowerCase();
                      return vipData['username']
                              .toLowerCase()
                              .contains(lowerCaseSearchString) ||
                          vipData['email']
                              .toLowerCase()
                              .contains(lowerCaseSearchString) ||
                          vipData['PaymentNumber']
                              .toLowerCase()
                              .contains(lowerCaseSearchString);
                    } else {
                      return true;
                    }
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      dynamic vipData = filteredData[index];
                      String userUid = vipData['user_uid'];
                      String status = vipData['status'];

                      if(status == 'สำเร็จ'){
                        return Container();
                      }

                      return FutureBuilder<Map<String, dynamic>>(
                        future: fetchUserData(userUid),
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 10),
                                Text('กำลังดาวน์โหลด...')
                              ],
                            );
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          Map<String, dynamic> userData = snapshot.data ?? {};

                          String firstname = userData['firstname'] ?? '';
                          String lastname = userData['lastname'] ?? '';
                          String email = userData['email'] ?? '';
                          String username = userData['username'] ?? '';



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
                                  child: Text(vipData['PaymentNumber']),
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewVip(
                                        vipData: VipData(
                                          vipuid: vipData['vipuid'],
                                          user_uid: userUid,
                                          packed: vipData['packed'],
                                          PaymentNumber:
                                              vipData['PaymentNumber'],
                                          date: vipData['date'],
                                          email: email,
                                          firstname: firstname,
                                          lastname: lastname,
                                          image_payment:
                                              vipData['image_payment'],
                                          status: vipData['status'],
                                          time: vipData['time'],
                                          id: vipData['id'],
                                          username: username,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 46, 246, 32),
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
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchDataVip() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: searchController,
        onChanged: (val) {
          setState(() {
            _searchString = val;
          });
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
                icon: const Icon(Icons.search),
                onPressed: () {
                  performSearch();
                },
              ),
              IconButton(
                icon: const Icon(Icons.clear),
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
