import 'package:admin/Screens/Manage_Screens/vipData.dart';
import 'package:admin/Screens/Showdata_screens/showdataviprequest_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late String paymentNumber;
  late String date;
  late String email;
  late String firstname;
  late String lastname;
  late String imagePayment;
  late String status;
  late String time;
  late String id;
  late String username;
  late String packed;
  final requestVip = FirebaseDatabase.instance.ref().child('requestvip');

  Future<Map<String, dynamic>> fetchUserData(String userUid) async {
    try {
      final DatabaseEvent event = await FirebaseDatabase.instance.ref().child('users').child(userUid).once();
      final DataSnapshot dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null) {
        final dynamic value = dataSnapshot.value as Map<Object?, Object?>;
        return {for (final key in value.keys) key: value[key]};
      } else {
        return {};
      }
    } catch (error) {
      print('Error fetching user data: $error');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: requestVip.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('กำลังโหลด...')
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
            return ListView.builder(
              itemCount: dataMap.length,
              itemBuilder: (context, index) {
                dynamic userData = dataMap.values.elementAt(index);
                String userUid = userData['user_uid'].toString();
                String status = userData['status'].toString();

                if (status == 'สำเร็จ') {
                  return Container();
                }

                String userid = userData['id'].toString();
                String email = userData['email'].toString();
                String firstname = userData['firstname'].toString();
                String lastname = userData['lastname'].toString();
                String paymentNumber = userData['PaymentNumber'].toString();
                String packed = userData['packed'].toString();

                String imagePayment = userData['image_payment'].toString();
                String date = userData['date'].toString();
                String time = userData['time'].toString();
                String vipUid = userData['vipuid'].toString();

                // Return FutureBuilder instead
                return FutureBuilder<Map<String, dynamic>>(
                  future: fetchUserData(userUid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    // Get username from snapshot data
                    String username = snapshot.data?['username'] ?? '';
                    String imageProfile = snapshot.data?['image_user'] ?? '';

                    // Build your UI here with username
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(imageProfile),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(username),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text('ผู้สมัคร VIP ใหม่'),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewVip(
                                            vipData: VipData(
                                              user_uid: userUid,
                                              PaymentNumber: paymentNumber,
                                              id: userid,
                                              username: username,
                                              email: email,
                                              firstname: firstname,
                                              lastname: lastname,
                                              packed: packed,
                                              status: status,
                                              image_payment: imagePayment,
                                              date: date,
                                              time: time,
                                              vipuid: vipUid,
                                            )),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: const Text(
                                    "รายละเอียด",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
