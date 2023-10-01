import 'package:admin/Screens/appbar.dart';
import 'package:admin/Screens/managepost_screen.dart';
import 'package:admin/Screens/manageuser_screen.dart';
import 'package:admin/Screens/viewnotice_screen.dart';
import 'package:admin/Screens/viprequest_screen.dart';
import 'package:flutter/material.dart';

import '../ScreensForHome/setting_screen.dart';
import '../ScreensForHome/notice_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _currentIndex == 0
                ? 'หน้าแรก'
                : _currentIndex == 1
                    ? 'แจ้งเตือน'
                    : 'ตั้งค่า',
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreenContent(),
            const NotificationsScreen(),
            const SettingsScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active), label: 'แจ้งเตือน'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'ตั้งค่า'),
          ],
        ),
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //จัดการข้อมูลผู้ใช้
            BoxMenu('จัดการข้อมูลผู้ใช้', () => const ManageUser(), context),
            //จัดการโพสต์
            BoxMenu('จัดการโพสต์', () => const ManagePost(), context),
            //คำขอสมัคร VIP
            BoxMenu('คำขอสมัคร VIP', () => const VipRequest(), context),
            //ประกาศแจ้งเตือน
            BoxMenu('ประกาศแจ้งเตือน', () => const ViewNotice(), context),
          ],
        ),
      ),
    );
  }
}

Widget BoxMenu(String label, Function() function, BuildContext context) {
  return Padding(
    padding:
        const EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0, bottom: 25),
    child: Container(
      child: Center(
        child: MaterialButton(
          color: Color.fromARGB(249, 24, 248, 106),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          minWidth: 900,
          height: 110,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => function()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
