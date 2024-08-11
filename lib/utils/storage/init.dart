import 'dart:developer' as dev;
import 'config.dart';
import 'key.dart';

class ConfigInitializer {
  static bool _isInitialized = false;

  static Future<void> initializeConfig() async {
    if (_isInitialized) {
      dev.log('配置已经初始化过，跳过初始化过程');
      return;
    }

    try {
      // 读取现有配置
      final currentConfig = await ConfigUtils.readConfig();

      // 检查并设置默认值
      final updatedConfig = {
        ConfigKeys.theme: currentConfig[ConfigKeys.theme] ?? 'auto',
        ConfigKeys.material: currentConfig[ConfigKeys.material] ?? 'mica',
        ConfigKeys.language: currentConfig[ConfigKeys.language] ?? 'zh-CN',
      };

      // 更新配置
      await ConfigUtils.updateConfig(updatedConfig);

      _isInitialized = true;
      dev.log('配置初始化完成');
    } catch (e) {
      dev.log('初始化配置时出错: $e');
    }
  }

  static bool get isInitialized => _isInitialized;
}
