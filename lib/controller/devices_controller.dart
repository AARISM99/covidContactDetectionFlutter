import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/db/contact.database.dart';
import 'package:flutter_ble_messenger/model/contact.model.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';

import 'device.info.controller.dart';

class DevicesController extends GetxController {
  // final BuildContext context;
  // DevicesController(this.context);

  /// **P2P_CLUSTER** is a peer-to-peer strategy that supports an M-to-N,
  /// or cluster-shaped, connection topology.
  Strategy strategy = Strategy.P2P_CLUSTER;

  /// Here we do the Dependency Injection of various classes
  Nearby nearby = Get.put(Nearby());
  DeviceInfoController _deviceInfo = Get.put(DeviceInfoController());

  Map<String, dynamic> androidId = <String, dynamic>{};

  /// Nickname of the logged in user
  var username = ''.obs;

  /// List of devices detected
  var devices = List<Device>().obs;

  /// The one who is requesting the info of a device
  var requestorId = '0'.obs;
  ConnectionInfo requestorDeviceInfo;

  @override
  Future<void> onInit() async {
    androidId = await _deviceInfo.initPlatformState();
    username = RxString(androidId['androidId']);

    print("--------------------------------");
    print("my android id is ");
    print(androidId['androidId']);
    print("--------------------------------");
    advertiseDevice();
    searchNearbyDevices();
    super.onInit();
  }

  @override
  void onClose() {
    nearby.stopAllEndpoints();
    nearby.stopDiscovery();
    nearby.stopAdvertising();
    super.onClose();
  }

  /// Discover nearby devices
  void searchNearbyDevices() async {
    try {
      await nearby.startDiscovery(
        username.value,
        strategy,
        onEndpointFound: (id, name, serviceId) async {
          /// Remove first the device from the list in case it was already there
          /// This duplication could occur since we combine advertise and discover
          print('I saw id:$id with name:$name');
          devices.removeWhere((device) => device.id == id);

          /// Once an endpoint is found, add it
          /// to the end of the devices observable
          devices.add(Device(id: id, name: name, serviceId: serviceId));
          // conect to data base
          var db = ContactDataBase.instance;
          List<Contact> items = await db.getContacts();

          for (var i = 0; i < devices.length; i++) {
            print(devices[i].toJson());
            if (!(await db.findOne(devices[i].name))) {
              try {
                Contact contact = Contact(items.length + 1, DateTime.now(),
                    androidId['androidId'], devices[i].name);
                db.createContact(contact);
              } finally {}
            } else {
              print(
                  "-----------------------------------///////////////////////-----------------");
              print("contact exist");
            }
          }
          items = await db.getContacts();
          print("------------------- all conctact ----------------");
          print(items.length);
          if (items.length > 0) {
            for (var i = 0; i < items.length; i++) {
              print(items[i].toJson());
            }
          }
        },
        onEndpointLost: (id) {
          devices.removeWhere((device) => device.id == id);
          nearby.disconnectFromEndpoint(id);
        },
      );
    } catch (e) {
      print('there is an error searching for nearby devices:: $e');
    }
  }

  /// Advertise own device to other devices nearby
  void advertiseDevice() async {
    try {
      await nearby.startAdvertising(
        username.value,
        strategy,
        onConnectionInitiated: (id, info) {
          /// Remove first the device from the list in case it was already there
          /// This duplication could occur since we combine advertise and discover
          devices.removeWhere((device) => device.id == id);

          /// We are about to use this info once we add the device to the device list
          requestorDeviceInfo = info;

          /// show the bottom modal widget
          // showBottomModal(context, requestorId.value.toString(), id, info);
        },
        onConnectionResult: (id, status) {
          if (status == Status.CONNECTED) {
            /// Add to device list
            devices.add(Device(
                id: id,
                name: requestorDeviceInfo.endpointName,
                serviceId: requestorDeviceInfo.endpointName));
          } else if (status == Status.REJECTED) {
            /// Add to device list
            devices.add(Device(
                id: id,
                name: requestorDeviceInfo.endpointName,
                serviceId: requestorDeviceInfo.endpointName));
          }
        },
        onDisconnected: (endpointId) {
          /// Remove the device from the device list
          devices.removeWhere((device) => device.id == endpointId);
        },
      );
    } catch (e) {
      print('there is an error advertising the device:: $e');
    }
  }

  // add contact in local Data base
  void save() async {}

  // get all contacts
  Future<List<Contact>> getAllContacts() async{
    var db = ContactDataBase.instance;
    List<Contact> contacts = await db.getContacts();

    print("------------------- all conctact ----------------");
    print(contacts.length);
    if (contacts.length > 0) {
      for (var i = 0; i < contacts.length; i++) {
        print(contacts[i].toJson());
      }
    }
    return contacts;
  }
}
