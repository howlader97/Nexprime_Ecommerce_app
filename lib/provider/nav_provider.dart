import 'package:flutter_riverpod/legacy.dart';

/// Provider to manage the selected index of the bottom navigation bar
final navIndexProvider = StateProvider<int>((ref) => 0);

/// Provider to share search query between Home and Search screens
final searchQueryProvider = StateProvider<String>((ref) => "");
