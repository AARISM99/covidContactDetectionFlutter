import 'package:flutter_ble_messenger/model/contact.model.dart';

import 'package:nearby_connections/nearby_connections.dart';
import 'package:get/get.dart';

class NearbyDevice {
  static Future<List<Device>> findDevices() async {
    Nearby nearby = Get.put(Nearby());
    var username = 'red'.obs;
    var devices = <Device>[].obs;
    Strategy strategy = Strategy.P2P_CLUSTER;
    print('_____________________________*********\n');
    try {
      print('_____________________________*********2\n');
      await nearby.startDiscovery(
        username.value,
        strategy,
        onEndpointFound: (id, name, serviceId) {
          /// Remove first the device from the list in case it was already there
          /// This duplication could occur since we combine advertise and discover
          devices.removeWhere((device) => device.id == id);

          /// Once an endpoint is found, add it
          /// to the end of the devices observable
          // devices.add(Device(
          //     id: id, name: name, serviceId: serviceId, isConnected: false));
        },
        onEndpointLost: (id) async {},
      );
    } catch (e) {
      print('there is an error searching for nearby devices:: $e');
    }

    return devices;
  }

  /// Discover nearby devices
  // void searchNearbyDevices() async {
  //   try {
  //     await nearby.startDiscovery(
  //       username.value,
  //       strategy,
  //       onEndpointFound: (id, name, serviceId) {
  //         /// Remove first the device from the list in case it was already there
  //         /// This duplication could occur since we combine advertise and discover
  //         devices.removeWhere((device) => device.id == id);

  //         /// Once an endpoint is found, add it
  //         /// to the end of the devices observable
  //         devices.add(Device(
  //             id: id, name: name, serviceId: serviceId, isConnected: false));
  //       },
  //       onEndpointLost: (id) {
  //         messagesController.onDisconnect(id);
  //         devices.removeWhere((device) => device.id == id);
  //         nearby.disconnectFromEndpoint(id);
  //       },
  //     );
  //   } catch (e) {
  //     print('there is an error searching for nearby devices:: $e');
  //   }
  // }

}
