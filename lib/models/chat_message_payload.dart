import 'dart:convert';

class ChatMessagePayload {
  final String content;
  final String type; // TEXT or IMAGE
  final int receiverId;
  final int? replyToId;

  ChatMessagePayload({
    required this.content,
    required this.type,
    required this.receiverId,
    this.replyToId,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'type': type,
      'receiverId': receiverId,
      'replyToId': replyToId,
    };
  }

  String toJson() => json.encode(toMap());
}
