import 'package:provider/provider.dart';

import 'page.dart';
import 'package:flutter/material.dart';

class Model extends ChangeNotifier{

  Controller _controller;

  int get timestamps => DateTime.now().millisecondsSinceEpoch;

  String get dateNow => _setDate(DateTime.now());

  String get dateTimeNow => _setDateTime(DateTime.now());

  String _setDate(DateTime date) => "${date.year}-${date.month}-${date.day}"; 
  String _setDateTime(DateTime date) => "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}"; 

  set setController(Controller con) => _controller = con;

  void setFunction(Function callback) =>
    WidgetsBinding.instance.addPostFrameCallback( (_) => callback() );

  T updateProvider<T>({bool listen = false}) {
    BuildContext context = _controller.context;
    return Provider.of<T>(context, listen: listen);
  }
  
}