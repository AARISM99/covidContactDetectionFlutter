
import 'package:flutter_ble_messenger/api/api.dart';
import 'package:flutter_ble_messenger/db/contact.database.dart';
import 'package:flutter_ble_messenger/model/notification.model.dart';
import 'package:get/get.dart';

import 'device.info.controller.dart';

class NotificationController extends GetxController {

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<NotificationM>> getAllNotifications() async{
    var db = ContactDataBase.instance;
    List<NotificationM> notifications = await db.getNotifications();

    print("------------------- all Notifications ----------------");
    print(notifications.length);
    if (notifications.length > 0) {
      for (var i = 0; i < notifications.length; i++) {
        print(notifications[i].toJson());
      }
    }
    return notifications;
  }



  Future<dynamic> getNotificationsApi() async {
    DeviceInfoController _deviceInfo = DeviceInfoController();
    Map<String, dynamic> androidId = <String, dynamic>{};
    androidId = await _deviceInfo.initPlatformState();
    var res = await CallApi().getData("getNotifications?udid="+androidId['androidId']);
    print("-------------------------ID"+"getNotifications?udid="+androidId['androidId']);
    return res.body.toString();
  }

}