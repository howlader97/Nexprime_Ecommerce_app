import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageProvider = AsyncNotifierProvider<_LanguageNotifier, String>(() {
  return _LanguageNotifier();
});

final initialLanguageProvider = NotifierProvider<_InitialLanguage, String>(() {
  return _InitialLanguage();
});

class _LanguageNotifier extends AsyncNotifier<String>{
 @override
  Future<String> build() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("app_language") ?? "en_US";
  }

  Future<void> setLanguage(String lang) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("app_language", lang);
    state = AsyncData(lang);
  }
}

class _InitialLanguage extends Notifier<String> {
  @override
  String build() {
    _loadLanguage();
    return "en_US";
  }

  Future<void> _loadLanguage() async {
    final pref = await SharedPreferences.getInstance();
    final saved = pref.getString("app_language") ?? "en_US";
    state = saved;
  }

}
