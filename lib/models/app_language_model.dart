class AppLanguageModel {
  final String flag;
  final String name;
  final String value;
  final bool isSelected;
  AppLanguageModel({
    required this.flag,
    required this.name,
    required this.value,
    this.isSelected = false,
  });

  AppLanguageModel copyWith({
    final String? flag,
    final String? name,
    final String? value,
    final bool? isSelected,
  }) {
    return AppLanguageModel(
      flag: flag ?? this.flag,
      name: name ?? this.name,
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
