import 'dart:convert';

class Message {
  final String name;
  final String senderId;
  final String senderName;
  final String message;
  final String dateMessage;
  final String profilePicture;
  final DateTime messageDate;
  int read = 0;
  Message({
    required this.name,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.dateMessage,
    required this.profilePicture,
    required this.messageDate,
    required this.read,
  });

  Message copyWith({
    String? name,
    String? senderId,
    String? senderName,
    String? message,
    String? dateMessage,
    String? profilePicture,
    DateTime? messageDate,
    int? read,
  }) {
    return Message(
      name: name ?? this.name,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      message: message ?? this.message,
      dateMessage: dateMessage ?? this.dateMessage,
      profilePicture: profilePicture ?? this.profilePicture,
      messageDate: messageDate ?? this.messageDate,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'senderId': senderId});
    result.addAll({'senderName': senderName});
    result.addAll({'message': message});
    result.addAll({'dateMessage': dateMessage});
    result.addAll({'profilePicture': profilePicture});
    result.addAll({'messageDate': messageDate.millisecondsSinceEpoch});
    result.addAll({'read': read});

    return result;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      name: map['name'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      message: map['message'] ?? '',
      dateMessage: map['dateMessage'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      messageDate: DateTime.fromMillisecondsSinceEpoch(map['messageDate']),
      read: map['read']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(name: $name, senderId: $senderId, senderName: $senderName, message: $message, dateMessage: $dateMessage, profilePicture: $profilePicture, messageDate: $messageDate, read: $read)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.name == name &&
        other.senderId == senderId &&
        other.senderName == senderName &&
        other.message == message &&
        other.dateMessage == dateMessage &&
        other.profilePicture == profilePicture &&
        other.messageDate == messageDate &&
        other.read == read;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        senderId.hashCode ^
        senderName.hashCode ^
        message.hashCode ^
        dateMessage.hashCode ^
        profilePicture.hashCode ^
        messageDate.hashCode ^
        read.hashCode;
  }
}
