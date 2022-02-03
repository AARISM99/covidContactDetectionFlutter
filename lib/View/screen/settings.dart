import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/controller/devices_controller.dart';
import 'package:get/get.dart';

class Setting extends StatefulWidget {
  const Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return GetX<DevicesController>(
      // init: DevicesController(context),
      init: DevicesController(),
      builder: (controller) {
        return controller.devices.isNotEmpty
            ? ListView.builder(
                itemCount: controller.devices.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Text(controller.devices[index].name.toString()),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).buttonColor),
                ),
              );
      },
    );
  }
}
