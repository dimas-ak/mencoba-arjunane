import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import 'flat_colors.dart';

class Helper {
  static Color fromHex(String hex) {
    hex = hex.toUpperCase().replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF" + hex;
    }
    return Color(int.parse(hex, radix: 16));
  }

  static String dateNow() {
    DateTime today = new DateTime.now();
    String dateSlug =
        "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')} ${today.hour.toString().padLeft(2, '0')}:${today.minute.toString().padLeft(2, '0')}:${today.second.toString().padLeft(2, '0')}";
    return dateSlug;
  }

  static String rupiah(value, {String separator='.', String trailing=''}) {
	  return "Rp. " + (value == null || value.toString().isEmpty ? "0" : value.toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}$separator') + trailing);
  }

  static String indoDate(String _date, {bool isDayName = false, String separator = " "}) {
    Map<int, String> months = {
      1: "Januari",
      2: "Februari",
      3: "Maret",
      4: "April",
      5: "Mei",
      6: "Juni",
      7: "Juli",
      8: "Agustus",
      9: "September",
      10: "Oktober",
      11: "November",
      12: "Desember",
    };

    Map<int, String> days = {
      1: "Senin",
      2: "Selasa",
      3: "Rabu",
      4: "Kamis",
      5: "Jumat",
      6: "Sabtu",
      7: "Minggu",
    };

    var split = _date.split("-");

    var day = isDayName ? "${days[DateTime.parse(_date).weekday]}, " : "";

    return "$day${split[2]}$separator${months[int.parse(split[1])]}$separator${split[0]}"; 
  } 

  static String randomString({int length = 10}) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  static int getLinesString(String text) {
    return '\n'.allMatches(text).length;
  }

  static Future<void> alert(String title, String text, BuildContext context,
      {bool isDismissible = false}) async {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(_).pop();
                },
              )
            ],
          );
        });
  }
}

Widget showLoadingWidget({String message = "Sedang diproses ...", Color color = FlatColors.googleBlue}) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(color)
        ),
        SizedBox(height: 20),
        Text("Sedang di proses...", textAlign: TextAlign.center,)
      ]),
    );
}

Future<File> getFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');
  var paths = "${(await getTemporaryDirectory()).path}";
  final file = File('$paths/${path.split('/').last}');
  
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

Map<String, Timer> interval = new Map<String, Timer>();

/// The setTimeout() method calls a function or evaluates an expression after a specified number of milliseconds.
/// ```dart
/// setTimeout( () {
///   // your action
/// }, 5000); // 5 seconds
/// ```
Future<void> setTimeout(Function func, int milliseconds) async => 
  await Future.delayed(Duration(milliseconds: milliseconds), func);

/// The setInterval() method calls a function or evaluates an expression at specified intervals (in milliseconds).
/// ```dart
/// setInterval( () {
///   // your action
/// }, 5000); // every 5 seconds
/// ```
void setInterval(Function(Timer) callback, int milliseconds, {String key = "timer-key"}) =>
  interval[key] = Timer.periodic(Duration(milliseconds: milliseconds), callback);

/// The stopInterval() method clears a timer set with the setInterval() method.
/// ```dart
/// stopInterval();
/// ```
void stopInterval({String key = "timer-key"}) {
  interval[key].cancel();
  interval.removeWhere( (_key, timer) => _key == key);
}