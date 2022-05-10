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
  final String type;
  final String userImage;
  String lastmessage;
  DateTime lastMessageTime;
  Chat({
    required this.restaurantId,
    required this.restaurantImage,
    required this.restaurantName,
    required this.userId,
    required this.sender,
    required this.type,
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
    String? type,
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
      type: type ?? this.type,
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
      'type': type,
      'userImage': userImage,
      'lastmessage': lastmessage,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      restaurantId: map['restaurantId'],
      restaurantImage: map['restaurantImage'],
      restaurantName: map['restaurantName'],
      userId: map['userId'],
      sender: map['sender'],
      type: map['type'],
      userImage: map['userImage'],
      lastmessage: map['lastmessage'],
      lastMessageTime:
          DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Chat(restaurantId: $restaurantId, restaurantImage: $restaurantImage, restaurantName: $restaurantName, userId: $userId, sender: $sender, type: $type, userImage: $userImage, lastmessage: $lastmessage, lastMessageTime: $lastMessageTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chat &&
        other.restaurantId == restaurantId &&
        other.restaurantImage == restaurantImage &&
        other.restaurantName == restaurantName &&
        other.userId == userId &&
        other.sender == sender &&
        other.type == type &&
        other.userImage == userImage &&
        other.lastmessage == lastmessage &&
        other.lastMessageTime == lastMessageTime;
  }

  @override
  int get hashCode {
    return restaurantId.hashCode ^
        restaurantImage.hashCode ^
        restaurantName.hashCode ^
        userId.hashCode ^
        sender.hashCode ^
        type.hashCode ^
        userImage.hashCode ^
        lastmessage.hashCode ^
        lastMessageTime.hashCode;
  }
}
