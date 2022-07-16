import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Overview {
  String name;
  String messageId;
  String message;
  String photo;
  DateTime time;
  bool unreadCount;
  bool you;
  String userId;
  Overview({
    required this.name,
    required this.you,
    required this.messageId,
    required this.message,
    required this.photo,
    required this.time,
    required this.unreadCount,
    required this.userId,
  });

  @override
  String toString() {
    return 'Overview(name: $name, messageId: $messageId, message: $message, photo: $photo, time: $time, unreadCount: $unreadCount, userId: $userId)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'messageId': messageId,
      'message': message,
      'photo': photo,
      'time': time.millisecondsSinceEpoch,
      'unreadCount': unreadCount,
      'userId': userId,
    };
  }

  factory Overview.fromMap(Map<String, dynamic> map) {
    return Overview(
      name: map['name'] as String,
      you: map['you'] as bool,
      messageId: map['messageId'] as String,
      message: map['message'] as String,
      photo: map['photo'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      unreadCount: map['unreadCount'] as bool,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Overview.fromJson(String source) =>
      Overview.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Overview &&
        other.name == name &&
        other.messageId == messageId &&
        other.message == message &&
        other.photo == photo &&
        other.time == time &&
        other.unreadCount == unreadCount &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        messageId.hashCode ^
        message.hashCode ^
        photo.hashCode ^
        time.hashCode ^
        unreadCount.hashCode ^
        userId.hashCode;
  }
}
