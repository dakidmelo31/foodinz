// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReviewModel {
  final String avatar;
  final String description;
  final DateTime created_at;
  final String image;
  final String meal;
  String? reviewId;
  final String restaurantId;
  final int rating;
  final String username;
  final String userId;
  final String foodId;
  ReviewModel({
    required this.avatar,
    required this.description,
    required this.created_at,
    required this.image,
    required this.meal,
    required this.reviewId,
    required this.restaurantId,
    required this.rating,
    required this.username,
    required this.userId,
    required this.foodId,
  });

  ReviewModel copyWith({
    String? avatar,
    String? description,
    DateTime? created_at,
    String? image,
    String? meal,
    String? reviewId,
    String? restaurantId,
    int? rating,
    String? username,
    String? userId,
    String? foodId,
  }) {
    return ReviewModel(
      avatar: avatar ?? this.avatar,
      description: description ?? this.description,
      created_at: created_at ?? this.created_at,
      image: image ?? this.image,
      meal: meal ?? this.meal,
      reviewId: reviewId ?? this.reviewId,
      restaurantId: restaurantId ?? this.restaurantId,
      rating: rating ?? this.rating,
      username: username ?? this.username,
      userId: userId ?? this.userId,
      foodId: foodId ?? this.foodId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'avatar': avatar,
      'description': description,
      'created_at': created_at.millisecondsSinceEpoch,
      'image': image,
      'name': meal,
      'restaurantId': restaurantId,
      'stars': rating,
      'username': username,
      'userId': userId,
      'foodId': foodId,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      avatar: map['avatar'] as String,
      description: map['description'] as String,
      created_at: (map['created_at']).toDate(),
      image: map['image'] as String,
      meal: map['name'] as String,
      reviewId: "",
      restaurantId: map['restaurantId'] as String,
      rating: map['stars'] as int,
      username: map['username'] as String,
      userId: map['userId'] as String,
      foodId: map['foodId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReviewModel(avatar: $avatar, description: $description, created_at: $created_at, image: $image, meal: $meal, reviewId: $reviewId, restaurantId: $restaurantId, rating: $rating, username: $username, userId: $userId, foodId: $foodId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReviewModel &&
        other.avatar == avatar &&
        other.description == description &&
        other.created_at == created_at &&
        other.image == image &&
        other.meal == meal &&
        other.reviewId == reviewId &&
        other.restaurantId == restaurantId &&
        other.rating == rating &&
        other.username == username &&
        other.userId == userId &&
        other.foodId == foodId;
  }

  @override
  int get hashCode {
    return avatar.hashCode ^
        description.hashCode ^
        created_at.hashCode ^
        image.hashCode ^
        meal.hashCode ^
        reviewId.hashCode ^
        restaurantId.hashCode ^
        rating.hashCode ^
        username.hashCode ^
        userId.hashCode ^
        foodId.hashCode;
  }
}
