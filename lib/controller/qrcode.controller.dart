import 'package:flutter_ble_messenger/db/contact.database.dart';
import 'package:flutter_ble_messenger/model/wallet.model.dart';
import 'package:get/get.dart';

class QrCodeController extends GetxController {
  // final BuildContext context;
  // QrCodeController(this.context);
  List<MyQrCode> wallets;
  @override
  void onInit() async {
    // this.wallets = List.empty();
    super.onInit();
  }

  Future<List<MyQrCode>> queryAll() async {
    final db = ContactDataBase.instance;
    final items = await db.getQrCodes();
    return items.map((json) => MyQrCode.fromJson(json)).toList();
  }

  Future createQrCode(MyQrCode qrCode) async {
    final db = ContactDataBase.instance;
    db.createQR(qrCode);
  }

  Future<MyQrCode> findOne(String content) async {
    final db = ContactDataBase.instance;
    final item = await db.queryOneQrCodeByContent(content);
    return item;
  }

  Future<int> delete(int id) async {
    final db = ContactDataBase.instance;
    return await db.delete(id);
  }

  Future<MyQrCode> getLastPcr() async {
    final db = ContactDataBase.instance;
    final item = await db.findLastQRCode();
    return item;
  }

  // Future<Map<MyQrCode>> queryone(int id) async {
  //   final db = ContactDataBase.instance;

  //   return await db.queryOneQrCode(id);
  // }
}
