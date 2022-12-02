import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoreEncrypt {
  late final Key key;
  late final IV iv;

  final String _privateKey = 'privateKey';
  final String _privateINV = 'privateINV';

  CoreEncrypt() {
    key = Key.fromUtf8(dotenv.env[_privateKey] ?? '');
    iv = IV.fromUtf8(utf8.decode((dotenv.env[_privateINV] ?? '').codeUnits));
  }

  String cryptFile(String data) {
    final encrypter = Encrypter(AES(key, padding: null));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  String decryptFile(String data) {
    final encrypter = Encrypter(AES(key, padding: null));
    final decrypted = encrypter.decrypt(Encrypted.from64(data), iv: iv);
    return decrypted;
  }
}
