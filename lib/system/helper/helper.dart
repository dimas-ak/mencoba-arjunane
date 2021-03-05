import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

Map<String, Timer> interval = new Map<String, Timer>();

Future<void> setTimeout(Function func, int milliseconds) async => 
  await Future.delayed(Duration(milliseconds: milliseconds), func);


void setInterval(Function(Timer) callback, int milliseconds, {String key = "timer-key"}) =>
  interval[key] = Timer.periodic(Duration(milliseconds: milliseconds), callback);


void stopInterval({String key = "timer-key"}) {
  interval[key].cancel();
  interval.removeWhere( (_key, timer) => _key == key);
}