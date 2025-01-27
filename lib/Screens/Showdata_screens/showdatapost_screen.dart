import 'package:admin/Screens/Manage_Screens/postData.dart';
import 'package:admin/Screens/appbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widget2/imageShow.dart';

class ShowDataPost extends StatefulWidget {
  final PostData postData;

  const ShowDataPost({Key? key, required this.postData}) : super(key: key);

  @override
  State<ShowDataPost> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ShowDataPost> {
  late String username;
  late String postNumber;
  late String brand;
  late String brand1;
  late String date;
  late String detail;
  late String details1;
  List<String> image_post = [];
  late String item_name;
  late String item_name1;
  late String model;
  late String model1;
  late String type;
  late String time;
  late String post_uid;
  double? latitude;
  double? longitude;
  late String formattedDatetime = '';
  int mySlideindex = 0;
  int selectedButton = 0;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    post_uid = widget.postData.post_uid;
    postNumber = widget.postData.postNumber;
    brand = widget.postData.brand;
    brand1 = widget.postData.brand1;
    username = widget.postData.username;
    date = widget.postData.date;
    detail = widget.postData.detail;
    details1 = widget.postData.details1;
    image_post = widget.postData.imageUrls;

    item_name = widget.postData.item_name;
    item_name1 = widget.postData.item_name1;
    model = widget.postData.model;
    model1 = widget.postData.model1;
    type = widget.postData.type;
    time = widget.postData.time;
    latitude = double.parse(widget.postData.latitude);
    longitude = double.parse(widget.postData.longitude);
  }

  Widget showDataPosts(String label, String data, Icon icon) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          hintStyle: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
          fillColor: Colors.grey[200],
          filled: true,
          prefixIcon: icon,
        ),
        controller: TextEditingController(text: data),
        maxLines: null,
      ),
    );
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
            'ยืนยันการลบโพสต์',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'คุณต้องการที่จะลบโพสต์หรือไม่?',
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
                      await FirebaseDatabase.instance
                          .ref()
                          .child('postitem/$post_uid')
                          .remove();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppbar("แสดงข้อมูลโพสต์"),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ImageGalleryWidget(imageUrls: image_post),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.tag,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "หมายเลขการโพสต์ : $postNumber ",
                          style: myTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "ชื่อผู้โพสต์ : $username ",
                          style: myTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "วันที่ $date",
                          style: myTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.punch_clock,
                          color: Colors.blue,
                        ),
                        Text(
                          " เวลา $time น.",
                          style: myTextStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 2, right: 15, top: 10, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 170, 170, 169),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.all(11),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ชื่อสิ่งของ : $item_name",
                              style: myTextStyle(),
                            ),
                            Text(
                              "หมวดหมู่ : $type",
                              style: myTextStyle(),
                            ),
                            Text(
                              "ยี่ห้อ : $brand",
                              style: myTextStyle(),
                            ),
                            Text(
                              "รุ่น : $model",
                              style: myTextStyle(),
                            ),
                            Text(
                              'รายละเอียด : $detail',
                              style: myTextStyle(),
                            ),
                            const Divider(),
                            Center(
                                child: Image.asset('assets/images/swap.png')),
                            const Divider(),
                            Text(
                              "ชื่อสิ่งของ : $item_name1",
                              style: myTextStyle(),
                            ),
                            Text(
                              "ยี่ห้อ : $brand1",
                              style: myTextStyle(),
                            ),
                            Text(
                              "รุ่น : $model1",
                              style: myTextStyle(),
                            ),
                            Text(
                              'รายละเอียด : $details1',
                              style: myTextStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                     Text(
                      "สถานที่แลกเปลี่ยนสิ่งของ : ",
                      style: myTextStyle(),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all()),
                      height: 300,
                      width: 380,
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(latitude!, longitude!),
                          zoom: 12.0,
                        ),
                        markers: <Marker>{
                          Marker(
                            markerId: const MarkerId('initialPosition'),
                            position: LatLng(latitude!, longitude!),
                            infoWindow: const InfoWindow(
                              title: 'Marker Title',
                              snippet: 'Marker Snippet',
                            ),
                          ),
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          _showDeleteConfirmationDialog();
                        },
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text(
                          'ลบโพสต์',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle myTextStyle() {
  return const TextStyle(
    fontSize: 20,
    color: Colors.black,
  );
}
