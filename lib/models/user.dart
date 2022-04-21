import 'dart:convert';

class UserModel {
  final String name;
  final String image;
  final String userId;
  final String phone;
  double lat;
  double long;
  UserModel({
    required this.name,
    required this.image,
    required this.userId,
    required this.phone,
    required this.lat,
    required this.long,
  });

  UserModel copyWith({
    String? name,
    String? image,
    String? userId,
    String? phone,
    double? lat,
    double? long,
  }) {
    return UserModel(
      name: name ?? this.name,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      phone: phone ?? this.phone,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'image': image});
    result.addAll({'userId': userId});
    result.addAll({'phone': phone});
    result.addAll({'lat': lat});
    result.addAll({'long': long});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      userId: map['userId'] ?? '',
      phone: map['phone'] ?? '',
      lat: map['lat']?.toDouble() ?? 0.0,
      long: map['long']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, image: $image, userId: $userId, phone: $phone, lat: $lat, long: $long)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.image == image &&
        other.userId == userId &&
        other.phone == phone &&
        other.lat == lat &&
        other.long == long;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        image.hashCode ^
        userId.hashCode ^
        phone.hashCode ^
        lat.hashCode ^
        long.hashCode;
  }
}
