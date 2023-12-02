import 'package:admin/Screens/Manage_Screens/userData.dart';
import 'package:admin/Screens/appbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Manage_Screens/manageuser_screen.dart';

class ShowDataUser extends StatefulWidget {
  final UserData userData;

  const ShowDataUser({required this.userData});

  @override
  State<ShowDataUser> createState() => _ShowDataUserState();
}

class _ShowDataUserState extends State<ShowDataUser> {
  final _birthdayController = TextEditingController();
  String selectedGender = '';
  DataSnapshot? userData;
  late String? id;
  late String? username;
  late String? email;
  late String? firstname;
  late String? lastname;
  late String? gender;
  late String? birthday;
  late String? uid;
  late String user_image;
  late DatabaseReference _userRef;
  late User? _user;
  DateTime selectedDate = DateTime.now();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _birthdayController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.ref().child('users');
    _user = FirebaseAuth.instance.currentUser;
    fetchDataFromConstructor();
  }

  void fetchDataFromConstructor() {
    // ดึงข้อมูลที่ได้จาก constructor และกำหนดให้กับตัวแปรใน State
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      uid = _user!.uid;
    }

    id = widget.userData.id;
    username = widget.userData.username;
    email = widget.userData.email;
    firstname = widget.userData.firstname;
    lastname = widget.userData.lastname;
    gender = widget.userData.gender;
    user_image = widget.userData.user_image;
    String? birthday = widget.userData.birthday;
    _birthdayController.text = birthday;
    selectedGender = gender ?? "";
    _firstnameController = TextEditingController(text: firstname);
    _lastnameController = TextEditingController(text: lastname);
  }

  void updateUserData() async {
    try {
      print('Updating data for UID: ${_user!.uid}');

      await _userRef.child(uid!).update({
        'firstname': _firstnameController.text.trim(),
        'lastname': _lastnameController.text.trim(),
        'gender': selectedGender,
        'birthday': _birthdayController.text.trim(),
        // Add other fields as needed
      });

      // Handle success and navigate if needed
      Navigator.pop(
        context,
        MaterialPageRoute(builder: (context) => ManageUser()),
      );
    } catch (error) {
      // Handle errors
      print('Error updating user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: myAppbar('ข้อมูลผู้ใช้'),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: imgProfile(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(text: id),
                          decoration: const InputDecoration(
                            label: Text(
                              "หมายเลขผู้ใช้งาน",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.tag),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _firstnameController,
                          decoration: const InputDecoration(
                            label: Text(
                              "ชื่อ",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _lastnameController,
                          decoration: InputDecoration(
                            label: Text(
                              "นามสกุล",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 15),
                        choseGender(),
                        SizedBox(height: 15),
                        TextField(
                          readOnly: true,
                          controller: _birthdayController,
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'วันเกิด',
                            labelStyle: const TextStyle(fontSize: 20),
                            hintStyle:
                                const TextStyle(fontStyle: FontStyle.italic),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Icon(Icons.date_range),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(text: username),
                          decoration: InputDecoration(
                            label: Text(
                              "ชื่อผู้ใช้",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(text: email),
                          decoration: InputDecoration(
                            label: Text(
                              'อีเมล',
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () async {
                                String uid = FirebaseAuth.instance.currentUser!
                                    .uid; // รับ uid จากผู้ใช้ปัจจุบัน

                                DatabaseReference userRef = FirebaseDatabase
                                    .instance
                                    .ref()
                                    .child('users')
                                    .child(uid);

                                await userRef
                                    .remove(); // ใช้ remove() เพื่อลบข้อมูล

                                Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ManageUser()),
                                );
                              },
                              icon: Icon(Icons.delete, color: Colors.white),
                              label: Text(
                                'ลบข้อมูล',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 15),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                updateUserData();
                              },
                              icon: const Icon(Icons.save_as,
                                  color: Colors.white),
                              label: Text(
                                'บันทึก',
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
            ),
          )),
    );
  }

  Widget choseGender() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 16),
      child: Row(
        children: <Widget>[
          Row(
            children: [
              Image.asset(
                'assets/icons/gender.png',
                width: 29,
              ),
              const SizedBox(
                width: 7,
              ),
              const Text(
                'เพศ',
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
          const SizedBox(
            width: 7,
          ),
          Radio(
            activeColor: Colors.green,
            value: "ชาย",
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                selectedGender = value.toString();
              });
            },
          ),
          const Text("ชาย", style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Radio(
            activeColor: Colors.green,
            value: "หญิง",
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                selectedGender = value.toString();
              });
            },
          ),
          const Text("หญิง", style: TextStyle(fontSize: 18)),
          Radio(
            activeColor: Colors.green,
            value: "อื่น ๆ",
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                selectedGender = value.toString();
              });
            },
          ),
          const Text("อื่นๆ", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final dynamic pickedFile = await ImagePicker().pickImage(
      source: source,
    );

    if (pickedFile != null) {
      setState(() {});

      // Close the file selection window
      Navigator.pop(context);
    }
  }

  Widget imgProfile() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: NetworkImage(user_image),
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: ((Builder) => bottomSheet()));
            },
            child: const Icon(
              Icons.camera_alt,
              color: const Color.fromARGB(255, 52, 0, 150),
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "เลือกรูปภาพของคุณ",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text('กล้อง'),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: const Icon(Icons.camera),
                label: const Text('แกลลอรี่'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
