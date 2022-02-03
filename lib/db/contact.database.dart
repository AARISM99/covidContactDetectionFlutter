import 'package:flutter/material.dart';
import 'package:flutter_ble_messenger/model/contact.model.dart';
import 'package:flutter_ble_messenger/model/notification.model.dart';
import 'package:flutter_ble_messenger/model/wallet.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactDataBase {
  static final ContactDataBase instance = ContactDataBase._init();
  static Database _database;
  ContactDataBase._init();

  // create our data base
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB('contact.db');
    return _database;
  }

  Future<Database> _initDB(String file) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, file);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = "BOOLEAN NOT NULL";
    await db.execute('''
    create table $contactTable(
      ${ContactFiled.id} $idType,
      ${ContactFiled.day} $textType,
      ${ContactFiled.firstDeviceId} $textType,
      ${ContactFiled.secondDeviceId} $textType
    )
    ''');
    await db.execute('''
    create table $qrCodeTable(
      ${MyQrCodeField.id} $idType,
      ${MyQrCodeField.date} $textType,
      ${MyQrCodeField.content} $textType,
      ${MyQrCodeField.type} $textType,
      ${MyQrCodeField.pcr} $boolType
    )
    ''');
    await db.execute('''
    create table $notificationMTable(
      ${NotificationField.id} $idType,
      ${NotificationField.sender} $textType,
      ${NotificationField.title} $textType,
      ${NotificationField.body} $textType,
      ${NotificationField.dateTime} $boolType
    )
    ''');
  }

  Future createContact(Contact contact) async {
    final db = await instance.database;
    await db.insert(contactTable, contact.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future createQR(MyQrCode qrCode) async {
    final db = await instance.database;
    await db.insert(qrCodeTable, qrCode.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    final items = db.query(qrCodeTable);
    print("--------------------Create One and Query It--------------------");

    this.getQrCodes();
  }

  Future createNotification(NotificationM notification) async {
    final db = await instance.database;
    await db.insert(notificationMTable, notification.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    final items = db.query(notificationMTable);
    print("--------------------Create One and Query It--------------------");

    this.getNotifications();
  }

  Future<bool> findOne(String second) async {
    bool a = false;
    final db = await instance.database;
    if ((await db.query(contactTable,
                where: "secondDeviceId = ?", whereArgs: [second]))
            .length >
        0) {
      a = true;
      return a;
    } else {
      return a;
    }
  }

  Future<List<Map<String, Object>>> getQrCodes() async {
    final db = await instance.database;
    return await db.query(qrCodeTable);
  }

  Future<List<Contact>> getContacts() async {
    final db = await instance.database;
    List<Map<String, dynamic>> items = await db.query(contactTable);
    print("////////////////////////////// ");
    print(items);
    return List.generate(
        items.length,
        (index) => Contact(
              items[index]['_id'],
              DateTime.parse(items[index]['day']),
              items[index]['firstDeviceId'],
              items[index]['secondDeviceId'],
            )).toList();
  }

  Future<List<NotificationM>> getNotifications() async{
    final db = await instance.database;
    List<Map<String, dynamic>> items = await db.query(notificationMTable);
    print("////////////////////////////// ");
    print(items);

    return List.generate(
        items.length,
        (index) => NotificationM(
            items[index]['_id'],
            items[index]['sender'],
            items[index]['title'],
            items[index]['body'],
            DateTime.parse(items[index]['dateTime']),
        )).toList();

    // List<Map<String, dynamic>> items = await db.query(contactTable);
    // print("////////////////////////////// ");
    // print(items);
    // return List.generate(
    //     items.length,
    //         (index) => Notification(
    //       items[index]['_id'],
    //       items[index]['sender'],
    //       DateTime.parse(items[index]['dateTime']),
    //       items[index]['secondDeviceId'],
    //     )).toList();
  }


  // Future creatDevice(Device device) async {
  //   final db = await instance.database;
  //   final id = await db.insert(deviceTable, device.toJson());
  //   return device.copy(id: id);
  // }

  Future<MyQrCode> queryOneQrCodeByContent(String content) async {
    final db = await instance.database;
    final maps = await db.query(qrCodeTable,
        where: "${MyQrCodeField.content} = ? ", whereArgs: [content]);
    if (maps.isNotEmpty) {
      return MyQrCode.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<MyQrCode> findLastQRCode() async {
    final db = await instance.database;
    final maps = await db.query(qrCodeTable, orderBy: "date");
    if (maps.isNotEmpty) {
      return MyQrCode.fromJson(maps.last);
    } else {
      return null;
    }
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db
        .delete(qrCodeTable, where: '${MyQrCodeField.id} = ?', whereArgs: [id]);
  }

  Future _close() async {
    final db = await instance.database;
    db.close();
  }

}
