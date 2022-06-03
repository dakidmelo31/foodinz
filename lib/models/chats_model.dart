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
  final String sender;
  final String userImage;
  String lastmessage;
  DateTime lastMessageTime;
  String messageId = "";
  Chat({
    required this.restaurantId,
    this.messageId = "",
    required this.restaurantImage,
    required this.restaurantName,
    required this.userId,
    required this.sender,
    required this.userImage,
    required this.lastmessage,
    required this.lastMessageTime,
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
    String? sender,
    String? userImage,
    String? lastmessage,
    DateTime? lastMessageTime,
  }) {
    return Chat(
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantImage: restaurantImage ?? this.restaurantImage,
      restaurantName: restaurantName ?? this.restaurantName,
      userId: userId ?? this.userId,
      sender: sender ?? this.sender,
      userImage: userImage ?? this.userImage,
      lastmessage: lastmessage ?? this.lastmessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'restaurantImage': restaurantImage,
      'restaurantName': restaurantName,
      'userId': userId,
      'sender': sender,
      'userImage': userImage,
      'lastmessage': lastmessage,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
    };
  }

  factory Chat.fromMap(map) {
    String val = map['lastMessageTime'];
    DateTime date = DateTime.tryParse(val) as DateTime;
    return Chat(
      restaurantId: map['restaurantId'] ?? "",
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

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Chat(restaurantId: $restaurantId, restaurantImage: $restaurantImage, restaurantName: $restaurantName, userId: $userId, sender: $sender, userImage: $userImage, lastmessage: $lastmessage, lastMessageTime: $lastMessageTime)';
  }
}
