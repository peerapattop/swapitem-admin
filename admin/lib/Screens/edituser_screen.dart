import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() {
  runApp(EditUser());
}

class EditUser extends StatefulWidget {
  const EditUser({Key? key}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("จัดการข้อมูลผู้ใช้"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Center(
              child: Image.asset(
                "assets/icons/user.png",
                width: 100,
                height: 100,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "หมายเลขผู้ใช้ : 0001",
            style: TextStyle(fontSize: 25),
          ),
          Text(
            "ชื่อ : พีรพัฒน์",
            style: TextStyle(fontSize: 25),
          ),
          Text(
            "นามสกุล : ตั้งปัญญาไว",
            style: TextStyle(fontSize: 25),
          ),
          Text(
            "เพศ : ชาย",
            style: TextStyle(fontSize: 25),
          ),
          Text(
            "วันเกิด : 16 ธันวาคม 2000",
            style: TextStyle(fontSize: 25),
          ),
          Text(
            "อีเมล : peerapatza401@gmail.com",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // โค้ดที่ต้องการให้ทำเมื่อกดปุ่ม "แก้ไข"
                  },
                  icon: Icon(Icons.edit),
                  label: Text("แก้ไข"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ),
              SizedBox(width: 10), // ระยะห่างระหว่างปุ่ม "แก้ไข" และ "ลบ"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // โค้ดที่ต้องการให้ทำเมื่อกดปุ่ม "ลบ"
                  },
                  icon: Icon(Icons.delete),
                  label: Text("ลบ"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
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
