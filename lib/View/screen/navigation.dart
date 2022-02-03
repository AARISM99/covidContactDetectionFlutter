import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/View/screen/home.dart';
import 'package:flutter_ble_messenger/View/widjets/AutorisationWidget.dart';
import 'package:flutter_ble_messenger/View/widjets/DocumentWidget.dart';
import 'package:flutter_ble_messenger/View/widjets/PassCovid.dart';
import 'package:flutter_ble_messenger/View/widjets/PcrWidjet.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_ble_messenger/View/screen/settings.dart';
import 'package:flutter_ble_messenger/View/screen/statistics.dart';
import 'package:flutter_ble_messenger/View/screen/wallet.dart';
import 'package:nearby_connections/nearby_connections.dart';

class Navigation extends StatefulWidget {
  int index;
  Navigation(this.index);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // final DeviceInfo contactController = Get.put(DeviceInfo());

  int _selectedIndex = null;
  String _data = "";
  final _selectedItemColor = Colors.white;
  final _unselectedItemColor = Colors.blue;
  // final _selectedBgColor = Colors.blue;
  // final _unselectedBgColor = Colors.white;
  List<Widget> _widgetOptions = <Widget>[
    Home(),
    Statistics(),
    Wallet(),
    Setting()
  ];
  @override
  void initState() {
    setState(() {
      _selectedIndex = widget.index;
    });
    getPermissions();
    super.initState();
  }

  void getPermissions() {
    Nearby().askLocationAndExternalStoragePermission();
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future _psv() => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => PassCovid(),
      );

  Future _pcr() => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => PcrScreen(),
      );
  Future _autorisation() => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AutorisationWidget(),
      );
  Future _file() => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => DocumentScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        icon: Icons.qr_code_scanner,
        backgroundColor: Colors.black,
        children: [
          SpeedDialChild(
            child: Icon(Icons.task_alt),
            onTap: () => _psv(),
            label: 'pass covid',
          ),
          SpeedDialChild(
            child: Icon(Icons.medical_services),
            label: 'pass pcr',
            onTap: () => _pcr(),
          ),
          SpeedDialChild(
            child: Icon(Icons.verified),
            label: 'autorisation',
            onTap: () => _autorisation(),
          ),
          SpeedDialChild(
            child: Icon(Icons.file_copy),
            label: 'scan from a document',
            onTap: () => _file(),
          )
        ],
      ),
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black),
        unselectedItemColor: Colors.blue,
        elevation: 0.0,
        items: [
          Icons.home,
          Icons.show_chart,
          Icons.featured_play_list,
          Icons.settings
        ]
            .asMap()
            .map((key, value) => MapEntry(
                  key,
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedIndex == key
                            ? Colors.blue[600]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Icon(value),
                    ),
                    label: 'Home',
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }
}
