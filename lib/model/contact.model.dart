final String contactTable = 'contactTable';
final String deviceTable = 'deviceTable';

class ContactFiled {
  static final String id = "_id";
  static final String day = "day";
  static final String firstDeviceId = "firstDeviceId";
  static final String secondDeviceId = "secondDeviceId";
}
class Contact {
  final int id;
  final DateTime day;
  final String firstDeviceId;
  final String secondDeviceID;

  Contact(
    this.id,
    this.day,
    this.firstDeviceId,
    this.secondDeviceID,
  );
  Map<String, Object> toJson() => {
        ContactFiled.id: id,
        ContactFiled.day: day.toIso8601String(),
        ContactFiled.firstDeviceId: firstDeviceId,
        ContactFiled.secondDeviceId: secondDeviceID,
      };
  Contact copy(
          {int id,
          DateTime day,
          String firstDeviceId,
          String secondDeviceId}) =>
      Contact(id, day, firstDeviceId, secondDeviceID);
}

class DeviceField {
  static final String id = "_id";
  static final String name = "name";
  static final String serviceId = "serviceId";
}
class Device {
  final String id;
  final String name;
  final String serviceId;

  Device({this.id, this.name, this.serviceId});
  Map<String, Object> toJson() => {
        DeviceField.id: id,
        DeviceField.name: name.toString(),
        DeviceField.serviceId: serviceId,
      };
}

