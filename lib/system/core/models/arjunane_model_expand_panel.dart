import 'dart:core';

import 'package:flutter/material.dart';

class ArjunaneModelExpandPanel extends ChangeNotifier {
  String? _id;
  bool? _isExpanded;

  Map<String?, bool?> get getExpand => {_id : _isExpanded};

  void expand(String? id, bool expanded) {
    _id = id;
    _isExpanded = expanded;
    notifyListeners();
  }
}