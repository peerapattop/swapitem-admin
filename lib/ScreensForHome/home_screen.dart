import 'package:flutter/material.dart';
import '../ScreensForHome/notice_screen.dart';
import '../ScreensForHome/setting_screen.dart';
import 'package:admin/Screens/Manage_Screens/managepost_screen.dart';
import 'package:admin/Screens/Manage_Screens/manageuser_screen.dart';
import 'package:admin/Screens/Manage_Screens/managenotice_screen.dart';
import 'package:admin/Screens/Manage_Screens/manageviprequest_screen.dart';


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
          toolbarHeight: 40,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/appbar.png'),
                fit: BoxFit.fill,
              ),
            ),
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
            boxMenu('จัดการข้อมูลผู้ใช้', () => ManageUser(), context,Color.fromARGB(255, 34, 92, 239)),
            //จัดการโพสต์
            boxMenu('จัดการโพสต์', () => const ManagePost(), context,Color.fromRGBO(59, 65, 243, 0.5)),
            //คำขอสมัคร VIP
            boxMenu('คำขอสมัคร VIP', () => const VipRequest(), context,Color.fromARGB(255, 31, 94, 240)),
            //ประกาศแจ้งเตือน
            boxMenu('ประกาศแจ้งเตือน', () => const ViewNotice(), context,Color.fromARGB(255, 243, 87, 131)),
          ],
        ),
      ),
    );
  }
}

Widget boxMenu(String label, Function() function, BuildContext context,Color ColorButton) {
  return Padding(
    padding:
        const EdgeInsets.only(top: 10.0, left: 50.0, right: 50.0, bottom: 25),
    child: Center(
      child: MaterialButton(
        color: ColorButton,
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}
