import 'package:encrypt/encrypt.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

final storage = new FlutterSecureStorage();

void createSecureKey() async {
  String value = await storage.read(key: 'hashKey');

  if (value == null) {
    Uuid uuid = Uuid();
    String hashKey = uuid.v4().replaceAll('-', '');
    await storage.write(key: 'hashKey', value: hashKey);
  }
}

Future<String> encryptString(String value) async {
  String hashKey = await storage.read(key: 'hashKey');
  final key = Key.fromUtf8(hashKey);
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(value, iv: iv);

  return encrypted.base64;
}

Future<String> decryptString(String encrypted) async {
  String hashKey = await storage.read(key: 'hashKey');
  final key = Key.fromUtf8(hashKey);
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final decrypted = encrypter.decrypt64(encrypted, iv: iv);

  return decrypted;
}
