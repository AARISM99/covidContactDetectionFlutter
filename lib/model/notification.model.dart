final String notificationMTable = 'notificationMTable';

class NotificationField {
  static final String id = "_id";
  static final String sender = "sender";
  static final String title = "title";
  static final String body = "body";
  static final String dateTime = "dateTime";
}

class NotificationM {
  final int id;
  final String sender;
  final String title;
  final String body;
  final DateTime dateTime;

  NotificationM(
      this.id,
      this.sender,
      this.title,
      this.body,
      this.dateTime);

  Map<String, Object> toJson() => {
    NotificationField.id: id,
    NotificationField.sender: sender,
    NotificationField.title: title,
    NotificationField.body: body,
    NotificationField.dateTime: dateTime.toIso8601String(),
  };
  NotificationM copy({
        int id,
        String sender,
        String title,
        String body,
        DateTime dateTime,
  }) => NotificationM(id, sender, title, body, dateTime);
}

