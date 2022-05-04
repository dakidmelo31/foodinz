import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String restaurantId;
  final String restaurantImage;
  final String restaurantName;
  final String userId;
  final String? sender;
  final String userImage;
  String lastmessage;
  Timestamp? lastMessageTime;
  Chat({
    required this.restaurantId,
    required this.restaurantImage,
    required this.restaurantName,
    required this.userId,
    this.sender,
    required this.userImage,
    required this.lastmessage,
    this.lastMessageTime,
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
    String? userId,
    String? sender,
    String? userImage,
    String? lastmessage,
    Timestamp? lastMessageTime,
  }) {
    return Chat(
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantId ?? this.restaurantName,
      restaurantImage: restaurantImage ?? this.restaurantImage,
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
      'userId': userId,
      'sender': sender,
      'userImage': userImage,
      'lastmessage': lastmessage,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      restaurantId: map['restaurantId'],
      restaurantName: map['restaurantName'],
      restaurantImage: map['restaurantImage'],
      userId: map['userId'],
      sender: map['sender'],
      userImage: map['userImage'],
      lastmessage: map['lastmessage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Chat(restaurantId: $restaurantId, restaurantImage: $restaurantImage, userId: $userId, sender: $sender, userImage: $userImage, lastmessage: $lastmessage, lastMessageTime: $lastMessageTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chat &&
        other.restaurantId == restaurantId &&
        other.restaurantImage == restaurantImage &&
        other.userId == userId &&
        other.sender == sender &&
        other.userImage == userImage &&
        other.lastmessage == lastmessage &&
        other.lastMessageTime == lastMessageTime;
  }

  @override
  int get hashCode {
    return restaurantId.hashCode ^
        restaurantImage.hashCode ^
        userId.hashCode ^
        sender.hashCode ^
        userImage.hashCode ^
        lastmessage.hashCode ^
        lastMessageTime.hashCode;
  }
}
