import 'dart:io';

import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File> compressImage(File file) async {
  Uint8List uint8 = await file.readAsBytes();
  FileStat detail = await file.stat();
  if (detail.size <= 1000000) {
    uint8 = await FlutterImageCompress.compressWithList(uint8, quality: 70);
  } else if (detail.size > 1000000 && detail.size <= 3000000) {
    uint8 = await FlutterImageCompress.compressWithList(uint8, quality: 50);
  } else if (detail.size > 3000000) {
    uint8 = await FlutterImageCompress.compressWithList(uint8, quality: 30);
  }
  file = await file.writeAsBytes(uint8);
  return file;
}
