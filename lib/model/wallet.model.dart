final String qrCodeTable = "QrCodeTable";

class MyQrCodeField {
  static final List<String> values = [id, content, type, pcr, date];
  static final String id = "_id";
  static final String content = "content";
  static final String type = "type";
  static final String pcr = "pcr";
  static final String date = "date";
}
class MyQrCode {
  int id;
  String content;
  String type;
  bool pcr;
  DateTime date;
  MyQrCode(this.content, this.date, this.type, [this.pcr, this.id]);
  Map<String, Object> toJson() => {
        MyQrCodeField.id: id,
        MyQrCodeField.content: content,
        MyQrCodeField.date: date.toIso8601String(),
        MyQrCodeField.type: type,
        MyQrCodeField.pcr: pcr ? 1 : 0,
      };
  static MyQrCode fromJson(Map<String, Object> json) => MyQrCode(
      json[MyQrCodeField.content] as String,
      DateTime.parse(json[MyQrCodeField.date] as String),
      json[MyQrCodeField.type] as String,
      json[MyQrCodeField.pcr] == 1 ? true : false,
      json[MyQrCodeField.id] as int);
}
