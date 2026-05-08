class ChatHistoryModel {
  final int id;
  final String? content;
  final String? type;
  final int senderId;
  final int receiverId;
  final int? replyToId;
  final bool isRead;
  final String? createdAt;

  ChatHistoryModel({
    required this.id,
    this.content,
    this.type,
    required this.senderId,
    required this.receiverId,
    this.replyToId,
    required this.isRead,
    this.createdAt,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryModel(
      id: json['id'] ?? 0,
      content: json['content'],
      type: json['type'],
      senderId: json['senderId'] ?? 0,
      receiverId: json['receiverId'] ?? 0,
      replyToId: json['replyToId'],
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type,
      'senderId': senderId,
      'receiverId': receiverId,
      'replyToId': replyToId,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }
}
