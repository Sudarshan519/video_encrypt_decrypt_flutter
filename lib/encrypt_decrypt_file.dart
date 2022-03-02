import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class EncryptController extends GetxController {
  perfomEncryptionTasks() async {
    await encryptFile();
    await decryptFile();
  }

  encryptFile() async {
    File inFile = File("video.mp4");
    File outFile = File("videoenc.aes");

    bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      await outFile.create();
    }

    final videoFileContents = await inFile.readAsStringSync(encoding: latin1);

    final key = Key.fromUtf8('my 32 length key................');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(videoFileContents, iv: iv);
    await outFile.writeAsBytes(encrypted.bytes);
  }

  decryptFile() async {
    File inFile = File("videoenc.aes");
    File outFile = File("videodec.mp4");

    bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      await outFile.create();
    }

    final videoFileContents = await inFile.readAsBytesSync();

    final key = Key.fromUtf8('my 32 length key................');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encryptedFile = Encrypted(videoFileContents);
    final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

    final decryptedBytes = latin1.encode(decrypted);
    await outFile.writeAsBytes(decryptedBytes);
  }
}
