import 'dart:convert';

class CloudNotification {
  final String title;
  final String description;
  final String userId;
  final String restaurantId;
  final String? payload;
  final String? recipient;
  String? image;

  CloudNotification({
    required this.title,
    required this.description,
    required this.userId,
    required this.restaurantId,
    this.image,
    this.payload,
    this.recipient,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'userId': userId,
      'restaurantId': restaurantId,
      'payload': payload,
      'recipient': recipient,
    };
  }

  factory CloudNotification.fromMap(Map<String, dynamic> map) {
    return CloudNotification(
      title: map['title'],
      description: map['description'],
      userId: map['userId'],
      restaurantId: map['restaurantId'],
      payload: map['payload'] != null ? map['payload'] : null,
      recipient: map['recipient'] != null ? map['recipient'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CloudNotification.fromJson(String source) =>
      CloudNotification.fromMap(json.decode(source));

  CloudNotification copyWith({
    String? title,
    String? description,
    String? userId,
    String? restaurantId,
    String? payload,
    String? recipient,
  }) {
    return CloudNotification(
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      payload: payload ?? this.payload,
      recipient: recipient ?? this.recipient,
    );
  }

  @override
  String toString() {
    return 'CloudNotification(title: $title, description: $description, userId: $userId, restaurantId: $restaurantId, payload: $payload, recipient: $recipient)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CloudNotification &&
        other.title == title &&
        other.description == description &&
        other.userId == userId &&
        other.restaurantId == restaurantId &&
        other.payload == payload &&
        other.recipient == recipient;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        userId.hashCode ^
        restaurantId.hashCode ^
        payload.hashCode ^
        recipient.hashCode;
  }
}
