import 'package:flutter/material.dart';

PreferredSizeWidget myAppbar(String name) {
  return AppBar(
    title: Text('$name',style: TextStyle(color: Colors.white),),
    toolbarHeight: 40,
    centerTitle: true,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/appbar.png'),
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}