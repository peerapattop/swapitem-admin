import 'dart:async';

import 'package:admin/Screens/Manage_Screens/vipData.dart';
import 'package:admin/Screens/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewVip extends StatefulWidget {
  final VipData vipData;

  const ViewVip({super.key, required this.vipData});

  @override
  State<ViewVip> createState() => _ViewVipState();
}

class _ViewVipState extends State<ViewVip> {
  late String paymentNumber;
  late String date;
  late String email;
  late String firstname;
  late String lastname;
  late String image_payment;
  late String status;
  late String time;
  late String id;
  late String uid;
  late String username;
  var packed;
  late String vipuid;
  late String user_uid;
  String formattedDate = '';
  DateTime? confirmationDate;
  Timer? countdownTimer;
  late StreamController<String> countdownController;
  late StreamSubscription<String> countdownSubscription;

  @override
  void initState() {
    super.initState();
    // Initialize countdownController
    countdownController = StreamController<String>();

    // Initialize countdownSubscription with a dummy subscription
    countdownSubscription = StreamController<String>().stream.listen((_) {});

    // ดึงข้อมูลผู้ใช้จาก Firebase Realtime Database
    paymentNumber = widget.vipData.PaymentNumber;
    id = widget.vipData.id;
    user_uid = widget.vipData.user_uid;
    vipuid = widget.vipData.vipuid;
    username = widget.vipData.username;
    email = widget.vipData.email;
    firstname = widget.vipData.firstname;
    lastname = widget.vipData.lastname;
    packed = widget.vipData.packed;
    status = widget.vipData.status;
    image_payment = widget.vipData.image_payment;
    date = widget.vipData.date;
    time = widget.vipData.time;
    confirmationDate = DateTime.now();
  }

  int extractPackedDays(String packedValue) {
    // ดึงค่าจำนวนวันที่จะนับถอยหลัง
    // นำไปใช้ในการกำหนด Duration ในการนับถอยหลัง
    if (packedValue == 'แพ็คเก็จ 1 เดือน : 50 บาท') {
      return 30;
    } else if (packedValue == 'แพ็คเก็จ 2 เดือน : 100 บาท') {
      return 60;
    } else if (packedValue == 'แพ็คเก็จ 3 เดือน : 150 บาท') {
      return 90;
    } else {
      return 30;
    }
  }

  String exampleUsageTime(int packedDays) {
    Timestamp firestoreTimestamp = Timestamp.now();
    DateTime dateTime = firestoreTimestamp.toDate();

    // สร้างโซนเวลาของเอเชีย (Asia/Bangkok)
    DateTime asiaTime = dateTime.toUtc().add(Duration(hours: 7));

    // Add packedDays to the asiaTime
    asiaTime = asiaTime.add(Duration(days: packedDays));

    // สร้างรูปแบบการแสดงวันที่และเวลาภาษาไทย
    var formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm:ss', 'th_TH');

    String formattedTime = formatter.format(asiaTime);

    return formattedTime;
  }

  void startCountdown(BuildContext context, String userUid, int packedDays) async {
    try {
      String endTime = exampleUsageTime(packedDays);
      await FirebaseDatabase.instance.ref().child('users/$userUid').update({
        'endTime': endTime,
        'postCount': 999,
        'makeofferCount': 999,
      });

      print('Firebase Update Successful');

      // เช็คเงื่อนไขเวลาปัจจุบัน
      DateTime currentTime = DateTime.now();
      DateTime endTimeFormatted = DateFormat('EEEE, dd MMMM yyyy HH:mm:ss', 'th_TH').parse(endTime);
      if (currentTime.isAfter(endTimeFormatted)) {
        // เมื่อถึงเวลาปัจจุบันแล้ว
        await FirebaseDatabase.instance.ref().child('users/$userUid').update({
          'status_user': 'ผู้ใช้ทั่วไป',
        });
        print('User status updated to ผู้ใช้ทั่วไป');
      }
    } catch (error) {
      print('Error updating Firebase: $error');
    }
  }


  void updateStatusAndNavigate(
      BuildContext context, String userUid, String vipUid) async {
    try {
      await FirebaseDatabase.instance.ref().child('users/$userUid').update({
        'status_user': 'ผู้ใช้พรีเมี่ยม',
      });

      await FirebaseDatabase.instance
          .ref()
          .child('requestvip')
          .child(vipUid)
          .update({
        'status': 'สำเร็จ',
      });

      // ทำอื่น ๆ ที่คุณต้องการหลังจากอัปเดตข้อมูล

      // นำทางไปยังหน้าที่ต้องการ
      Navigator.pop(context);
    } catch (e) {
      print('Error updating user status: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    countdownSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppbar('รายละเอียด'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Center(
                              child: Image.network(
                            image_payment,
                            width: 400,
                            height: 400,
                          )),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 217, 217, 216),
                            borderRadius: BorderRadius.circular(
                                12.0), // ทำให้ Container โค้งมน
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.tag,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    "หมายเลขการชำระเงิน PAY- $paymentNumber",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.numbers,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    'หมายเลขผู้ใช้งาน : $id',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    'ชื่อผู้ใช้ : $username',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.date_range,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    " วันที่ : $date",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.more_time,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    " เวลา : $time",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.menu,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    ' ' + packed,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.handyman,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    ' สถานะ : $status',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () async {
                                await FirebaseDatabase.instance
                                    .ref()
                                    .child('requestvip/$uid')
                                    .update({
                                  'status': 'ปฎิเสธ',
                                });
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.clear, color: Colors.white),
                              label: const Text(
                                'ปฎิเสธ',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 15),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                startCountdown(context, user_uid,
                                    extractPackedDays(packed));
                                updateStatusAndNavigate(
                                    context, user_uid, vipuid);
                              },
                              icon:
                                  const Icon(Icons.check, color: Colors.white),
                              label: const Text(
                                'ยืนยัน',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCircularNumberButton(int number) {
    return InkWell(
      onTap: () {
        // โค้ดที่ต้องการให้ทำงานเมื่อปุ่มถูกกด
      },
      child: Container(
        width: 40, // ปรับขนาดตามต้องการ
        height: 40, // ปรับขนาดตามต้องการ
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black, // สีขอบ
            width: 2.0, // ความกว้างขอบ
          ),
        ),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
