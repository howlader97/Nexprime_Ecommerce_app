class ChatUploadModel {
  final String? url;
  final String? type;

  ChatUploadModel({
    this.url,
    this.type,
  });

  factory ChatUploadModel.fromJson(Map<String, dynamic> json) {
    return ChatUploadModel(
      url: json['url'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'type': type,
    };
  }
}
