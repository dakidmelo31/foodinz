import 'dart:convert';

class UserModel {
  String? name;
  String? image;
  String? email;
  String? address;
  String? userId;
  String? phone;
  String? deviceToken;
  double lat;
  double lng;
  UserModel({
    required this.name,
    required this.image,
    required this.userId,
    required this.phone,
    this.deviceToken,
    required this.lat,
    required this.lng,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? address,
    String? image,
    String? userId,
    String? phone,
    String? deviceToken,
    double? lat,
    double? long,
  }) {
    return UserModel(
      name: name ?? this.name,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      phone: phone ?? this.phone,
      deviceToken: deviceToken ?? this.deviceToken,
      lat: lat ?? this.lat,
      lng: long ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'email': email,
      'address': address,
      'userId': userId,
      'phone': phone,
      'deviceToken': deviceToken,
      'lat': lat,
      'long': lng,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] != null ? map['name'] : null,
      image: map['image'] != null ? map['image'] : null,
      userId: map['userId'] != null ? map['userId'] : null,
      phone: map['phone'] != null ? map['phone'] : null,
      deviceToken: map['deviceToken'] != null ? map['deviceToken'] : null,
      lat: map['lat'],
      lng: map['long'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, image: $image, userId: $userId, phone: $phone, deviceToken: $deviceToken, lat: $lat, long: $lng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.image == image &&
        other.userId == userId &&
        other.phone == phone &&
        other.deviceToken == deviceToken &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        image.hashCode ^
        userId.hashCode ^
        phone.hashCode ^
        deviceToken.hashCode ^
        lat.hashCode ^
        lng.hashCode;
  }
}
