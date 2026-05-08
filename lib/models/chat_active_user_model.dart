class ChatActiveUserModel {
  final int id;
  final int userId;
  final String? fullname;
  final String? email;
  final bool isOnline;
  final String? lastActiveAt;
  final String? lastMessage;
  final String? lastMessageTime;
  final int unreadCount;
  final String? profileImageUrl;

  ChatActiveUserModel({
    required this.id,
    required this.userId,
    this.fullname,
    this.email,
    required this.isOnline,
    this.lastActiveAt,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
    this.profileImageUrl,
  });

  factory ChatActiveUserModel.fromJson(Map<String, dynamic> json) {
    return ChatActiveUserModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      fullname: json['fullname'],
      email: json['email'],
      isOnline: json['isOnline'] ?? false,
      lastActiveAt: json['lastActiveAt'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'],
      unreadCount: json['unreadCount'] ?? 0,
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fullname': fullname,
      'email': email,
      'isOnline': isOnline,
      'lastActiveAt': lastActiveAt,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'unreadCount': unreadCount,
      'profileImageUrl': profileImageUrl,
    };
  }
}
