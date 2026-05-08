class StreamNotificationModel {
  final int id;
  final String title;
  final String thumbnail;
  final String offer;
  final DateTime? endDateTime;
  final bool isActive;
  final int viewsCount;
  final int streamerId;
  final String vendorName;
  final String storeName;
  final String? description;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  StreamNotificationModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.offer,
    this.endDateTime,
    required this.isActive,
    required this.viewsCount,
    required this.streamerId,
    required this.vendorName,
    required this.storeName,
    this.description,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StreamNotificationModel.fromJson(Map<String, dynamic> json) {
    return StreamNotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      offer: json['offer'] ?? '',
      endDateTime: json['endDateTime'] != null
          ? DateTime.parse(json['endDateTime'])
          : null,
      isActive: json['isActive'] ?? false,
      viewsCount: json['viewsCount'] ?? 0,
      streamerId: json['streamerId'] ?? 0,
      vendorName: json['vendorName'] ?? '',
      storeName: json['storeName'] ?? '',
      description: json['description'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'offer': offer,
      'endDateTime': endDateTime?.toIso8601String(),
      'isActive': isActive,
      'viewsCount': viewsCount,
      'streamerId': streamerId,
      'vendorName': vendorName,
      'storeName': storeName,
      'description': description,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}


class StreamNotificationResponse {
  final int totalActiveStreams;
  final List<StreamNotificationModel> streams;

  StreamNotificationResponse({
    required this.totalActiveStreams,
    required this.streams,
  });

  factory StreamNotificationResponse.fromJson(Map<String, dynamic> json) {
    final streamsJson = json['streams'] as List<dynamic>? ?? [];
    final streamsList = streamsJson
        .map((e) => StreamNotificationModel.fromJson(e))
        .toList();

    return StreamNotificationResponse(
      totalActiveStreams: json['totalActiveStreams'] ?? 0,
      streams: streamsList,
    );
  }
}