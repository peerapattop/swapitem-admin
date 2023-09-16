import 'package:admin/Screens/viprequest_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewVip extends StatefulWidget {
  final DocumentSnapshot viprequestsDocument;

  ViewVip(this.viprequestsDocument);

  @override
  State<ViewVip> createState() => _ViewVipState();
}

class _ViewVipState extends State<ViewVip> {
  late String username;
  late String email;
  late String fname;
  late String lname;
  late String gender;
  late String order;
  late String date;

  @override
  void initState() {
    super.initState();
    username = widget.viprequestsDocument['username'];
    email = widget.viprequestsDocument['email'];
    fname = widget.viprequestsDocument['fname'];
    lname = widget.viprequestsDocument['lname'];
    gender = widget.viprequestsDocument['gender'];
    date = widget.viprequestsDocument['date'];
    order = widget.viprequestsDocument['order'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายละเอียด"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // สั่งให้เนื้อหาชิดซ้าย
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Container(
              child: Text("หลักฐานการโอนเงิน",style: TextStyle(fontSize: 20),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Text("แพ็กเกจ : $order",style: TextStyle(fontSize: 20),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Text("ชื่อผู้ใช้ : $username",style: TextStyle(fontSize: 20),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Text("ชื่อ : $fname",style: TextStyle(fontSize: 20),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Text("นามสกุล : $lname",style: TextStyle(fontSize: 20),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Text("เพศ : $gender",style: TextStyle(fontSize: 20),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Text("อีเมล : $email",style: TextStyle(fontSize: 20),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("ยืนยันการปฎิเสธ"),
                          content: Text("คุณต้องการปฎิเสธข้อมูลนี้ใช่หรือไม่?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("ยกเลิก"),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('vip_requests')
                                      .doc(widget.viprequestsDocument.id)
                                      .delete();
                                  Navigator.pop(
                                      context); // ปิดหน้าต่างแจ้งเตือน
                                  // ลบสำเร็จแล้ว สามารถแสดงข้อความหรือทำอื่นๆ ต่อได้
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("ลบข้อมูลสำเร็จ"),
                                        content: Text(
                                            "ข้อมูลได้ถูกลบออกจากฐานข้อมูลแล้ว"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("ตกลง"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } catch (e) {
                                  print("เกิดข้อผิดพลาดในการลบข้อมูล: $e");
                                }
                              },
                              child: Text("ยืนยัน"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.close),
                  label: Text('ปฎิเสธ'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VipRequest()),
                    );
                  },
                  icon: Icon(Icons.check), // เพิ่มไอคอน
                  label: Text('ยืนยัน'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // สีพื้นหลังของปุ่ม
                    onPrimary: Colors.white, // สีตัวอักษรในปุ่ม
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
