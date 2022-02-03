import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/View/widjets/wallets.widget.details.dart';
import 'package:flutter_ble_messenger/View/widjets/widgets.dart';
import 'package:flutter_ble_messenger/api/api.dart';
import 'package:flutter_ble_messenger/controller/devices_controller.dart';
import 'package:flutter_ble_messenger/controller/qrcode.controller.dart';
import 'package:flutter_ble_messenger/model/wallet.model.dart';
import 'package:get/get.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  QrCodeController qrCodeController = Get.put(QrCodeController());
  List<MyQrCode> wallets;
  Future<List<MyQrCode>> fetchdata() async {
    return await qrCodeController.queryAll();
  }

  @override
  void initState() {
    wallets = [];
    qrCodeController.queryAll().then((result) {
      if (mounted) {
        setState(() {
          wallets = result;
          wallets.sort((a,b){ //sorting in descending order
            return DateTime.parse(b.date.toString()).compareTo(DateTime.parse(a.date.toString()));
          });
        });
      } else {
        wallets = result;
      }
    });
    print("******************* wallets Screen -----------------");

    print(wallets);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        body: (wallets?.isNotEmpty ?? true)
            ? ListView.builder(
                itemCount: wallets.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BarcodeWidget(
                        margin: EdgeInsets.only(top: 35.0),
                        color: Colors.black,
                        data: wallets[index].content,
                        backgroundColor: Colors.white,
                        height: 100,
                        width: 100,
                        barcode: Barcode.qrCode(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(wallets[index].type),
                          Text(formatDate(wallets[index].date)),
                          wallets[index].type=="Pass pcr" ? Text(wallets[index].pcr ? "positif" : "négatif",style: TextStyle(
                            color: wallets[index].pcr ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold
                          )) : Text(""),
                          TextButton(
                              onPressed: () async {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) =>
                                      WalletDeatilWidget(wallets[index]),
                                );
                              },
                              child: Text("view"),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              )
                          )
                        ],
                      )
                    ],
                  );
                })
            : Center(
                child: FutureBuilder(
                    future: Future.delayed(Duration(seconds: 2)),
                    builder: (context, snapshot) =>
                        snapshot.connectionState != ConnectionState.done
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).buttonColor),
                              )
                            : Text('no ducument')),
              ));
  }

  String formatDate(DateTime now) {
    return "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

}

class Scan extends StatefulWidget {
  const Scan({Key key}) : super(key: key);

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
