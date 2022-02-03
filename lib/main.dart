import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble_messenger/View/screen/navigation.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_ble_messenger/controller/devices_controller.dart';
import 'package:flutter_ble_messenger/controller/qrcode.controller.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'api/api.dart';
import 'controller/device.info.controller.dart';



// const myTask = "syncWithTheBackEnd";
// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) {
//     switch (taskName) {
//       case myTask:
//         print("this method was called from native!");
//         print("---------------------------------------------");
//         print("i am runing in the background");
//         print("---------------------------------------------");
//         break;
//       case Workmanager.iOSBackgroundTask:
//         print("iOS background fetch delegate ran");
//         break;
//     }
//
//     return Future.value(true);
//   });
// }


Future<void> main() async {
  // Workmanager().initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  // );
  // Workmanager().registerOneOffTask("1", "simpleTask",initialDelay: Duration(seconds: 20)); //Android only (see below)


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;


  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    getInit();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.native,
      theme: ThemeData(
        backgroundColor: Colors.white,
        primaryColor: Color(0xFF6c65f8),
        buttonColor: Color(0xFF69f0ae),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black54),
      ),
      debugShowCheckedModeBanner: false,
      home: Navigation(0),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Connectivity example app'),
  //     ),
  //     body: Center(child: Text('Connection Status: $_connectionStatus')),
  //   );
  // }


  Future<void> getInit() async{

    String deviceName = "", deviceVersion = "", deviceID = "";
    String token = '';

    DevicesController _devicesController = Get.put(DevicesController());
    QrCodeController _qrController = Get.put(QrCodeController());


    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try{
      if(Platform.isAndroid){
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.model;
          //  deviceVersion = build.version.toString();
          deviceID = build.androidId;
        });
      }
      else if(Platform.isIOS){
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = data.name;
          //  deviceVersion = data.systemVersion;
          deviceID = data.identifierForVendor;
        });

      }

      print("++++++++++++++++++++++++++++++ Device infos +++++++++++++++++++++++++++++++");

      print("deviceName = " + deviceName);
      //  print("deviceVersion = " + deviceVersion);
      print("deviceID = " + deviceID);

      print("++++++++++++++++++++++++++++++ Fin Device infos +++++++++++++++++++++++++++++++");

      var lastQcr = await _qrController.getLastPcr();

      FirebaseMessaging.instance.getToken().then((value) => {
        token = value,
        print("-------------- Token --------------"),
        print("token = " + token),
        sendDeviceInfo({
          'udid': deviceID,
          'token': token,
          "covid": lastQcr.pcr
        })

      });

      print("last pcr ----------------");

      print(lastQcr.pcr);
      print(lastQcr.date);



      if(lastQcr.pcr == true){

        print("--------------- PCR TRUE ----------------");

        final contacts = await _devicesController.getAllContacts();

        var res = CallApi().sendContacts(contacts,"sendNotification");
        print("-------------- Response ---------------");
        print(res);
      }

    } on PlatformException{
      print("Failed to get platform version");
    }
  }

  Future <void> sendDeviceInfo(data) async {
    print('----------------- data ----------------');
    print(data);
    var res = await CallApi().postData(data, 'devices');
    var body = json.decode(res.body);
    print("--------------- body --------------------");
    print(body);
    if(body['success']){
      //SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('token', body['token']);
      //localStorage.setString('user', json.encode(body['user']));
      print("Data Device was sent successfully");
    }
    else{
      print("Request failed");
    }
  }

}
