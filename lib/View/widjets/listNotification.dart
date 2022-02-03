import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/config/palette.dart';
import 'package:flutter_ble_messenger/controller/notification.controller.dart';
import 'package:flutter_ble_messenger/model/notification.model.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class notifications extends StatefulWidget {
  const notifications() : super();


  @override
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  var notificationList = [];

  @override
  void initState() {
    // TODO: implement initState
    getNotifications();
    // sleep(Duration(seconds:2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List Notifications "),),
      body: (notifications == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
          itemCount:
          (notifications == null ? 0 : notificationList.length),
          itemBuilder: (context, index) {
            return Card(
              child:Container(
                // margin: const EdgeInsets.only(top: 0.0, bottom: 5.0),
                height: 100,
                color: Colors.white,
                child: Row(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Expanded(
                          child:Image.asset("assets/images/notification2.jpeg"),
                          flex:0 ,
                        ),
                      ),
                    ),
                    Expanded(
                      child:Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 0,
                              child: ListTile(
                                title: Text("${notificationList[index]['title']}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                    )
                                ),
                                subtitle: Text("${notificationList[index]['body']}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              elevation: 2,
              margin: EdgeInsets.all(5),
              shadowColor: Palette.primaryColor,
            );
          }))

    );
  }

  Future<void> getNotifications() async{
    NotificationController notificationController = Get.put(NotificationController());
    var res = await notificationController.getNotificationsApi();
    var items = (json.decode(res) as List);

    setState(() {
      notificationList = items;
    });

  }

}

