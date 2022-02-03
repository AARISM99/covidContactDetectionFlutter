import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble_messenger/View/widjets/listNotification.dart';
import 'package:flutter_ble_messenger/config/palette.dart';
import 'package:flutter_ble_messenger/controller/notification.controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget{

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}

class _CustomAppBarState extends State<CustomAppBar> {
  String deviceID = "";
  num count = 0 ;

  @override
  void initState() {
    // getUDID();
    getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.primaryColor,
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        iconSize: 30.0,
        onPressed: () {},
      ),
      actions: <Widget>[
        IconButton(
          icon: new Stack(
              children: <Widget>[
                new Icon(Icons.notifications_none),
                new Positioned(  // draw a red marble
                    top: 0.0,
                    right: 0.0,
                    child: count != 0 ? Container(
                      padding: EdgeInsets.symmetric(horizontal:4, vertical: 4),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                      child: Text(' ${count} ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                    ):Container()

                )
              ]
          ),
          iconSize: 30.0,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder:(context)=> notifications()));
          },
        ),
      ],
    );
  }

  Future<void> getNotifications() async{
    NotificationController notificationController = Get.put(NotificationController());
    var res = await notificationController.getNotificationsApi();
    // print(res);
    var items = (json.decode(res) as List);


    setState(() {
      count = items.length;
      print("--------------------------------N${items}");

    });

  }

}