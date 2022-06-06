// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/message_database.dart';

final String chatTable = "chats";

class ChatFields {
  static final String restaurantId = "restaurantId";
  static final String restaurantImage = "restaurantImage";
  static final String userId = "userId";
  static final String lastMessage = "lastMessage";
  static final String lastMessageTime = "lastMessageTime";
  static final String sender = "sender";
  static final String userImage = "userImage";
  static final String restaurantName = "restaurantName";
  static final List<String> values = [
    restaurantId,
    restaurantImage,
    restaurantName,
    userId,
    userImage,
    sender,
    lastMessage,
    lastMessageTime
  ];
}

class Chat {
  final String restaurantId;
  final String restaurantImage;
  final String restaurantName;
  final String userId;
  final String senderName;
  final String sender;
  final String userImage;
  bool opened = false;
  String lastmessage;
  DateTime lastMessageTime;
  String messageId = "";
  Chat({
    required this.restaurantId,
    required this.restaurantImage,
    required this.restaurantName,
    required this.userId,
    required this.senderName,
    required this.sender,
    required this.userImage,
    required this.opened,
    required this.lastmessage,
    required this.lastMessageTime,
    this.messageId = "",
  });

  userSent() {
    if (this.sender == restaurantId) {
      return true;
    }
    return false;
  }

  Chat copyWith({
    String? restaurantId,
    String? restaurantImage,
    String? restaurantName,
    String? userId,
    String? senderName,
    String? sender,
    String? userImage,
    bool? opened,
    String? lastmessage,
    DateTime? lastMessageTime,
    String? messageId,
  }) {
    return Chat(
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantImage: restaurantImage ?? this.restaurantImage,
      restaurantName: restaurantName ?? this.restaurantName,
      userId: userId ?? this.userId,
      senderName: senderName ?? this.senderName,
      sender: sender ?? this.sender,
      userImage: userImage ?? this.userImage,
      opened: opened ?? this.opened,
      lastmessage: lastmessage ?? this.lastmessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      messageId: messageId ?? this.messageId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'restaurantId': restaurantId,
      'restaurantImage': restaurantImage,
      'restaurantName': restaurantName,
      'userId': userId,
      'senderName': senderName,
      'sender': sender,
      'userImage': userImage,
      'opened': opened,
      'lastmessage': lastmessage,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
      'messageId': messageId,
    };
  }

  factory Chat.fromMap(map) {
    String val = map['lastMessageTime'];
    DateTime date = DateTime.tryParse(val) as DateTime;
    return Chat(
      restaurantId: map['restaurantId'] ?? "",
      opened: map['opened'] ?? false,
      senderName: map['senderName'] ?? "",
      restaurantImage: map['restaurantImage'] ?? "",
      restaurantName: map['restaurantName'] ?? "",
      userId: map['userId'] ?? "",
      sender: map['sender'] ?? "",
      userImage: map['userImage'] ?? "",
      messageId: "",
      lastmessage: map['lastmessage'] ?? "",
      lastMessageTime: date,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(restaurantId: $restaurantId, restaurantImage: $restaurantImage, restaurantName: $restaurantName, userId: $userId, senderName: $senderName, sender: $sender, userImage: $userImage, opened: $opened, lastmessage: $lastmessage, lastMessageTime: $lastMessageTime, messageId: $messageId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chat &&
        other.restaurantId == restaurantId &&
        other.restaurantImage == restaurantImage &&
        other.restaurantName == restaurantName &&
        other.userId == userId &&
        other.senderName == senderName &&
        other.sender == sender &&
        other.userImage == userImage &&
        other.opened == opened &&
        other.lastmessage == lastmessage &&
        other.lastMessageTime == lastMessageTime &&
        other.messageId == messageId;
  }

  @override
  int get hashCode {
    return restaurantId.hashCode ^
        restaurantImage.hashCode ^
        restaurantName.hashCode ^
        userId.hashCode ^
        senderName.hashCode ^
        sender.hashCode ^
        userImage.hashCode ^
        opened.hashCode ^
        lastmessage.hashCode ^
        lastMessageTime.hashCode ^
        messageId.hashCode;
  }
}
