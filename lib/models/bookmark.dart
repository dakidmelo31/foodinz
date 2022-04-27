import 'dart:convert';

class Bookmark {
  final String foodId;
  final String name;
  Bookmark({
    required this.foodId,
    required this.name,
  });

  Bookmark copyWith({
    String? foodId,
    String? name,
  }) {
    return Bookmark(
      foodId: foodId ?? this.foodId,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'foodId': foodId});
    result.addAll({'name': name});

    return result;
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      foodId: map['foodId'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Bookmark.fromJson(String source) =>
      Bookmark.fromMap(json.decode(source));

  @override
  String toString() => 'Bookmark(foodId: $foodId, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Bookmark && other.foodId == foodId && other.name == name;
  }

  @override
  int get hashCode => foodId.hashCode ^ name.hashCode;
}
