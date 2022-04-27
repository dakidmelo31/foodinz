import 'dart:convert';

class Favorite {
  final String foodId;
  final String name;
  final bool isFavorite;
  Favorite({
    required this.foodId,
    required this.name,
    required this.isFavorite,
  });

  Favorite copyWith({
    String? foodId,
    String? name,
    bool? isFavorite,
  }) {
    return Favorite(
      foodId: foodId ?? this.foodId,
      name: name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'foodId': foodId});
    result.addAll({'name': name});
    result.addAll({'isFavorite': isFavorite});

    return result;
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      foodId: map['foodId'] ?? '',
      name: map['name'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Favorite.fromJson(String source) =>
      Favorite.fromMap(json.decode(source));

  @override
  String toString() =>
      'Favorite(foodId: $foodId, name: $name, isFavorite: $isFavorite)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Favorite &&
        other.foodId == foodId &&
        other.name == name &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode => foodId.hashCode ^ name.hashCode ^ isFavorite.hashCode;
}
