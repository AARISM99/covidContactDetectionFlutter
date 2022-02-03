import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_ble_messenger/View/screen/navigation.dart';
import 'package:flutter_ble_messenger/controller/qrcode.controller.dart';
import 'package:flutter_ble_messenger/model/wallet.model.dart';
import 'package:get/get.dart';

class AutorisationWidget extends StatefulWidget {
  @override
  _AutorisationWidgetState createState() => _AutorisationWidgetState();
}

enum test_covid { positive, negative }

class _AutorisationWidgetState extends State<AutorisationWidget> {
  String _data = '';

  QrCodeController codeController = Get.put(QrCodeController());
  Future _scan() async {
    return await FlutterBarcodeScanner.scanBarcode(
        "#000000", "cancel", true, ScanMode.QR);
  }

  Future savePC() async {
    if (_data != '' && _data != '-1') {
      if ((await codeController.findOne(_data)) == null) {
        MyQrCode qrCode = MyQrCode(_data, DateTime.now(), 'Autorisation', true);
        await codeController.createQrCode(qrCode);
      } else {
        print("already exisit ------------------------------------");
        // showActionSnackBar(context, "already exist");
        // showActionSnackBar(context, "Your Document are saved succsfully");
      }
    }
  }

  @override
  void initState() {
    _scan().then((result) {
      if (mounted) {
        setState(() {
          if (result != '-1') {
            _data = result;
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  String formatDate(DateTime now) {
    return "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: _data != ''
                    ? BarcodeWidget(
                        // margin: EdgeInsets.only(top: 35.0),
                        color: Colors.black,
                        data: _data,

                        barcode: Barcode.qrCode(),
                      )
                    : Center(
                        child: Text('you haven\'t scan any documnet medical'),
                      ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Autorisation',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    Text(formatDate(DateTime.now()),
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FlatButton(
                      onPressed: () async {
                        await savePC();
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Navigation(2)));
                      },
                      child: Text(
                        'save',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'cancel',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
