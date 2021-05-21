import 'package:flutter/cupertino.dart';

class ArjunaneModelViewWidget extends ChangeNotifier {
  String? _id;

  String? get getId => _id;

  set setId(String id) {
    _id = id;
    notifyListeners();
  }
}