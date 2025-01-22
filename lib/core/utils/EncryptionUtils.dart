import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';


class EncryptionUtils {
  static String password = "bizfnskeyforencryption##==@@%%&&";
  static String salt = "Yml6Zm5z##";

  static var key = Key.fromUtf8(password);
  static var iv = IV.fromLength(16);


  static String encrypt(String data) {
    var encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    var cipherText = encrypter.encrypt(data, iv: iv);
    return cipherText.base64;
  }

  static String decrypt(String cipherText) {
    var decrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    var decryptedText = decrypter.decrypt( Encrypted.fromBase64(cipherText), iv: iv);
    return decryptedText;
  }



}