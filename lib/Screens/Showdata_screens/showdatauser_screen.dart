import 'dart:io' as io; // Import dart:io with a prefix
import 'package:admin/Screens/Manage_Screens/UserData.dart';
import 'package:admin/Screens/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class ShowDataUser extends StatefulWidget {
  final UserData userData;

  const ShowDataUser({super.key, required this.userData});

  @override
  State<ShowDataUser> createState() => _ShowDataUserState();
}

class _ShowDataUserState extends State<ShowDataUser> {
  final _birthdayController = TextEditingController();
  String? selectedImageUrl;
  final ImagePicker _picker = ImagePicker();
  String? selectedGender;
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
        _birthdayController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromConstructor();
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text(
            'ยืนยันการลบข้อมูล',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'คุณต้องการที่จะออกลบข้อมูลหรือไม่?',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseDatabase.instance.ref().child('users/$uid').remove();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchDataFromConstructor() async {
    uid = widget.userData.uid;
    id = widget.userData.id;
    username = widget.userData.username;
    email = widget.userData.email;
    firstname = widget.userData.firstname;
    lastname = widget.userData.lastname;
    gender = widget.userData.gender;
    user_image = widget.userData.user_image;
    String? birthday = widget.userData.birthday;
    _birthdayController.text = birthday;
    _firstnameController = TextEditingController(text: firstname);
    _lastnameController = TextEditingController(text: lastname);

    // เพิ่มโค้ดสำหรับดึงข้อมูลเพศจากฐานข้อมูล
    if (gender != null) {
      setState(() {
        selectedGender = gender;
      });
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
                          decoration: const InputDecoration(
                            label: Text(
                              "นามสกุล",
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 15),
                        choseGender(),
                        const SizedBox(height: 15),
                        TextField(
                          readOnly: true,
                          controller: _birthdayController,
                          onTap: () => _selectDate(context),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'วันเกิด',
                            labelStyle: TextStyle(fontSize: 20),
                            hintStyle: TextStyle(fontStyle: FontStyle.italic),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Icon(Icons.date_range),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(text: username),
                          decoration: const InputDecoration(
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
                          decoration: const InputDecoration(
                            label: Text(
                              'อีเมล',
                              style: TextStyle(fontSize: 20),
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () async {
                                _showDeleteConfirmationDialog();
                              },
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              label: const Text(
                                'ลบผู้ใช้',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 15),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () async {
                                if (selectedImageUrl != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedDate);

                                  await FirebaseDatabase.instance.ref().child('users/$uid').update({
                                    'firstname': _firstnameController.text.trim(),
                                    'lastname': _lastnameController.text.trim(),
                                    'gender': selectedGender,
                                    'birthday': formattedDate,
                                    'image_user': selectedImageUrl,
                                  });

                                  Navigator.pop(context);
                                }
                              },
                              icon: const Icon(Icons.save_as,
                                  color: Colors.white),
                              label: const Text(
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
            groupValue: selectedGender,
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
            groupValue: selectedGender,
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
            groupValue: selectedGender,
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

  Future<String?> uploadImageToFirebaseStorage(String? imagePath) async {
    try {
      if (imagePath != null) {
        final String uid = FirebaseAuth.instance.currentUser!.uid;
        final storageRef = FirebaseStorage.instance.ref().child('images_user');
        final File imageFile = File(imagePath);

        // Check if the file exists before uploading
        if (!imageFile.existsSync()) {
          print('Error: File does not exist');
          return null;
        }

        final uploadTask = storageRef.child('$uid.jpg').putFile(imageFile);
        final TaskSnapshot taskSnapshot = await uploadTask;
        final imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Return the image URL
        return imageUrl;
      }
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      return null;
    }
    return null;
  }

  Widget imgProfile() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: selectedImageUrl != null
              ? NetworkImage(selectedImageUrl!)
              : NetworkImage(user_image),
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (builder) => bottomSheet(),
              );
            },
            child: const Icon(
              Icons.camera_alt,
              color: Color.fromARGB(255, 52, 0, 150),
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
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: const Icon(Icons.photo_camera), // Changed to photo_camera
                label: const Text('กล้อง'),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon:
                    const Icon(Icons.photo_library), // Changed to photo_library
                label: const Text('แกลลอรี่'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImageUrl = pickedFile.path;
      });
      Navigator.pop(context);

      // Upload the picked image to Firebase Storage
      String? imageUrl = await uploadImageToFirebaseStorage(pickedFile.path);

      if (imageUrl != null) {
        setState(() {
          selectedImageUrl = imageUrl;
        });
      } else {
        print('Error uploading image to Firebase Storage');
      }
    }
  }
}
