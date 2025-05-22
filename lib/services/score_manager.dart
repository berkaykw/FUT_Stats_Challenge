import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  static const String _key = "max_score";

  Future<void> saveMaxScore(int skor) async {
    final prefs = await SharedPreferences.getInstance();
    int currentMax = prefs.getInt(_key) ?? 0;
    if (skor > currentMax) {
      await prefs.setInt(_key, skor);
    }
  }

  // Max skoru al
  Future<int> getMaxScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }
}