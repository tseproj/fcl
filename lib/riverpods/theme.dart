import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fcl/utils/storage/config.dart';

class ThemeRiverpod extends StateNotifier<Map<String, dynamic>> {
  ThemeRiverpod(Map<String, dynamic> data) : super(data);

  void setMaterial(String material) {
    state = {...state, "material": material};
  }

  void setTheme(String theme) {
    state = {...state, "theme": theme};
  }
}

final themeRiverpod =
    StateNotifierProvider<ThemeRiverpod, Map<String, dynamic>>((ref) {
  return ThemeRiverpod({
    "theme": ConfigUtils.readConfig()
        .then((config) => config['theme'] as String? ?? 'auto'),
    "material": ConfigUtils.readConfig()
        .then((config) => config['material'] as String? ?? 'default')
  });
});
