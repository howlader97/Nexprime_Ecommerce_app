class StaticPageModel {
  final int id;
  final String key;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;

  StaticPageModel({
    required this.id,
    required this.key,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StaticPageModel.fromJson(Map<String, dynamic> json) {
    return StaticPageModel(
      id: json['id'] ?? 0,
      key: json['key'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static List<StaticPageModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => StaticPageModel.fromJson(e)).toList();
  }
}
