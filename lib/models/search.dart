import 'dart:convert';

class Search {
  final int id;
  final String keyword;
  Search({
    required this.id,
    required this.keyword,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'keyword': keyword});

    return result;
  }

  factory Search.fromMap(Map<String, dynamic> map) {
    return Search(
      id: map['id']?.toInt() ?? 0,
      keyword: map['keyword'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Search.fromJson(String source) => Search.fromMap(json.decode(source));
}
