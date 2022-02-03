import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/View/screen/navigation.dart';
import 'package:flutter_ble_messenger/controller/qrcode.controller.dart';
import 'package:flutter_ble_messenger/model/wallet.model.dart';
import 'package:get/get.dart';

class WalletDeatilWidget extends StatefulWidget {
  MyQrCode data;
  WalletDeatilWidget(this.data, {Key key}) : super(key: key);

  @override
  State<WalletDeatilWidget> createState() => _WalletDeatilWidgetState(data);
}

class _WalletDeatilWidgetState extends State<WalletDeatilWidget> {
  QrCodeController codeController = Get.put(QrCodeController());
  MyQrCode data;
  _WalletDeatilWidgetState(this.data);

  Future delete(BuildContext context, int id) async {
    await codeController.delete(id);
  }

  void showActionSnackBar(BuildContext context, String text) {
    final snackbar = SnackBar(
      content: Text(text),
    );

    ScaffoldMessenger.of(context)..showSnackBar(snackbar);
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
                child: data != ''
                    ? BarcodeWidget(
                        // margin: EdgeInsets.only(top: 35.0),
                        color: Colors.black,
                        data: data.content,

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
                      data.type,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    Text(formatDate(data.date),
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              widget.data.type == 'Pass pcr'
                  ? (widget.data.pcr == true
                      ? Container(
                          child: const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 50.0,
                        ))
                      : const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 50.0,
                          ),
                        ))
                  : const SizedBox(
                      width: 0,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FlatButton(
                      onPressed: () async {
                        await delete(context, data.id);
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Navigation(2)));
                      },
                      child: Text(
                        'delete',
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
                        'Exit',
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
  static const double avatarRadius = 40;
}
