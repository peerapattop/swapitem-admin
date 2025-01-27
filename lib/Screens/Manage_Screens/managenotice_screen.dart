import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import 'package:admin/Screens/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewNotice extends StatefulWidget {
  const ViewNotice({Key? key});

  @override
  State<ViewNotice> createState() => _ViewNoticeState();
}

class _ViewNoticeState extends State<ViewNotice> {
  final notificationController = TextEditingController();
  final detailCollection =
      FirebaseFirestore.instance.collection('notifications');
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> createNotification() async {
    try {
      DateTime now = DateTime.now();
      String formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      String formattedTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

      String notificationDocumentId = DateTime.now().toIso8601String();

      var notificationData = {
        'รายละเอียด': notificationController.text,
        'วันที่': formattedDate,
        'เวลา': formattedTime,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationDocumentId)
          .set(notificationData);

      //แจ้งเตือนไปยังโทรศัพท์
      var fcmMessage = {
        "notification": {
          "title": "แจ้งเตือนจากผู้ดูแลระบบ",
          "body": notificationController.text,
        },
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status": "done",
        },
        "to":
            "/topics/all",
      };

      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer AAAAR-udywc:APA91bExhUWIzezQhb5jmkFr8j7YP3AUip3LQJnDx3KJQcl01ObK4JPqtcZFBaLRDstq8wkI8NNMYf9eX87qsicVOUUm1e3agQY8gNZqMmXZVD7xQMHMhvHJXiH0BJgsDYCZbJSBTKC5',
        },
        body: jsonEncode(fcmMessage),
      );

      if (response.statusCode == 200) {
        print('FCM request for device sent successfully!');
      } else {
        print('FCM request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppbar("ประกาศแจ้งเตือน"),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20),
          child: Column(
            children: [
              Image.asset('assets/images/Megaphone.png', width: 250),
              const SizedBox(height: 40),
              TextField(
                controller: notificationController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'กรอกข้อความที่นี่',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await createNotification();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const SizedBox(
                  width: 90,
                  height: 40,
                  child: Center(
                    child: Text(
                      'ส่ง',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
