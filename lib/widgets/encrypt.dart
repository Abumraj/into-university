import 'package:encrypt/encrypt.dart' as EncryptPack;
import 'package:crypto/crypto.dart' as CryptoPack;
import 'dart:convert' as ConvertPack;

String extractPayload(String payload) {
  String strPwd = "SuperSecretKey";
  String strIv = 'SuperSecretBLOCK';
  var iv = CryptoPack.sha256
      .convert(ConvertPack.utf8.encode(strIv))
      .toString()
      .substring(0, 16); // Consider the first 16 bytes of all 64 bytes
  var key = CryptoPack.sha256
      .convert(ConvertPack.utf8.encode(strPwd))
      .toString()
      .substring(0, 32); // Consider the first 32 bytes of all 64 bytes
  EncryptPack.IV ivObj = EncryptPack.IV.fromUtf8(iv);
  EncryptPack.Key keyObj = EncryptPack.Key.fromUtf8(key);
  final encrypter = EncryptPack.Encrypter(
      EncryptPack.AES(keyObj, mode: EncryptPack.AESMode.cbc)); // Apply CBC mode
  String firstBase64Decoding = new String.fromCharCodes(
      ConvertPack.base64.decode(payload)); // First Base64 decoding
  final decrypted = encrypter.decrypt(
      EncryptPack.Encrypted.fromBase64(firstBase64Decoding),
      iv: ivObj); // Second Base64 decoding (during decryption)
  return decrypted;
}
