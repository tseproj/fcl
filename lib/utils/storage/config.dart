import 'dart:convert';
import 'dart:io';
import 'dart:developer' as dev;
import 'package:path_provider/path_provider.dart';

class ConfigUtils {
  static const String _configFileName = 'fcl.appconf';

  /// 获取配置文件路径
  static Future<String> _getConfigFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/Fcl';
    return '$path/$_configFileName';
  }

  /// 确保目录存在
  static Future<void> _ensureDirectoryExists(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  /// 读取配置
  static Future<Map<String, dynamic>> readConfig() async {
    try {
      final filePath = await _getConfigFilePath();
      await _ensureDirectoryExists(Directory(filePath).parent.path);
      final file = File(filePath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        return json.decode(contents);
      }
    } catch (e) {
      dev.log('读取配置文件时出错: $e');
    }
    return {};
  }

  /// 写入配置
  static Future<void> writeConfig(Map<String, dynamic> config) async {
    try {
      final filePath = await _getConfigFilePath();
      await _ensureDirectoryExists(Directory(filePath).parent.path);
      final file = File(filePath);
      final contents = json.encode(config);
      await file.writeAsString(contents);
    } catch (e) {
      dev.log('写入配置文件时出错: $e');
    }
  }

  /// 更新配置
  static Future<void> updateConfig(Map<String, dynamic> newConfig) async {
    final currentConfig = await readConfig();
    currentConfig.addAll(newConfig);
    await writeConfig(currentConfig);
  }

  /// 从另一个文件读取键值对并更新配置
  static Future<void> updateConfigFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final Map<String, dynamic> newConfig = json.decode(contents);
        await updateConfig(newConfig);
      } else {
        dev.log('指定的文件不存在: $filePath');
      }
    } catch (e) {
      dev.log('从文件更新配置时出错: $e');
    }
  }
}
