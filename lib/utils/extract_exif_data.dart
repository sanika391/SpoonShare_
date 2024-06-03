import 'dart:typed_data';
import 'dart:io';

import 'package:exif/exif.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ExtractExifData {
  static late Map<String, IfdTag> _exifData;

  static Future<int> extractInformation(String imageUrl) async {
    if (imageUrl.isNotEmpty) {
      Uint8List byte;
      if (Uri.parse(imageUrl).scheme == 'file' || !Uri.parse(imageUrl).hasScheme) {
        final file = File(imageUrl);
        byte = await file.readAsBytes();
      } else {
        final file = await DefaultCacheManager().getSingleFile(imageUrl);
        byte = await file.readAsBytes();
      }

      print("Our Bytes data : $byte");
      final data = await readExifFromBytes(Uint8List.fromList(byte));
      print("Our data is : $data");

      if (data != null && data.isNotEmpty) {
        final String? dateTimeOriginal = _getDateTimeOriginal(data);
        if (dateTimeOriginal != null && _isRecentDate(dateTimeOriginal)) {
          _exifData = data;
          print("All are perfectly done");
          return 1;
        } else {
          print("Out of date");
          return 2;
        }
      } else {
        print("Invalid");
        return 3;
      }
    }
    return 3;
  }

  static String? _getDateTimeOriginal(Map<String, IfdTag> exifData) {
    final IfdTag? dateTimeOriginalTag = exifData['EXIF DateTimeOriginal'];
    print("GETDATE FUNCTION $dateTimeOriginalTag");
    if (dateTimeOriginalTag != null) {
      final String? dateTimeOriginalString = dateTimeOriginalTag.toString();
      print("GETDATA IF $dateTimeOriginalString");
      if (dateTimeOriginalString != null && dateTimeOriginalString.isNotEmpty) {
        print("INSIDE IF IF");
        return dateTimeOriginalString;
      }
    }
    return null;
  }

  static bool _isRecentDate(String dateTime) {
    List<String> dateData = dateTime.split(' ');
    List<String> yearMonthDate = dateData[0].split(':');
    List<String> hourMinuteSecond = dateData[1].split(':');

    DateTime imageDateTime = DateTime(
        int.parse(yearMonthDate[0]),
        int.parse(yearMonthDate[1]),
        int.parse(yearMonthDate[2]),
        int.parse(hourMinuteSecond[0]),
        int.parse(hourMinuteSecond[1]),
        int.parse(hourMinuteSecond[2])
    );

    DateTime now = DateTime.now();
    Duration difference = now.difference(imageDateTime);

    return difference.inMinutes <= 30;
  }

}
