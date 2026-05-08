class FaqModel {
  final int id;
  final String question;
  final String answer;
  final String status;
  final String createdAt;
  final String updatedAt;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static List<FaqModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => FaqModel.fromJson(e)).toList();
  }
}
