import 'dart:io';

abstract class Command {

  String? signature;

  String? description;

  Map<String, dynamic> arguments = {};

  Map<String, dynamic> options = {};

  // void handle(List<String> args) {
    
  // }

  void handle() {
    
  }

  String? ask(String text) {
    stdout.write(text);
    return stdin.readLineSync();
  }

  String? secret(String text) {
    print(text);
    stdin.echoMode = false;
    return stdin.readLineSync();  
  }

  bool confirm(String text) {
    stdout.write("$text\nY/N");
    return stdin.readLineSync()!.trim() == "Y";
  }
}

class CommandProperty {
  final bool isArray;
  final bool isArgumentOptional;
  final bool isOptionOptional;

  // argument
  // option
  final String typeProperty;

  final bool isAnyValue;

  final String? key;
  final String? defaultValue;
  
  CommandProperty({this.isArray = false, this.isArgumentOptional = false, this.isOptionOptional = false, this.key, this.defaultValue, this.typeProperty = "argument", this.isAnyValue = false});
}