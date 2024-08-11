import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  /// 获取用户文档文件夹
  static Future<String> getDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 读取文件
  static Future<String> readFile(String filePath) async {
    final file = File(filePath);
    return await file.readAsString();
  }

  /// 写入文件
  static Future<void> writeFile(String filePath, String content) async {
    final file = File(filePath);
    await file.writeAsString(content);
  }

  /// 创建文件
  static Future<File> createFile(String filePath) async {
    final file = File(filePath);
    return await file.create(recursive: true);
  }

  /// 创建文件夹
  static Future<Directory> createDirectory(String dirPath) async {
    final directory = Directory(dirPath);
    return await directory.create(recursive: true);
  }

  /// 获取文件夹中的文件列表
  static Future<List<FileSystemEntity>> getFileList(String dirPath) async {
    final directory = Directory(dirPath);
    return await directory
        .list(followLinks: false)
        .where((entity) => entity is File)
        .toList();
  }

  /// 获取文件夹中的文件夹列表
  static Future<List<FileSystemEntity>> getDirectoryList(String dirPath) async {
    final directory = Directory(dirPath);
    return await directory
        .list(followLinks: false)
        .where((entity) => entity is Directory)
        .toList();
  }
}
