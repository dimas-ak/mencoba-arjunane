import 'dart:io';

import '../commands_class.dart';

class CommandPlugins extends Command {

  // The name and signature of the console command.
  String signature = "init";

  // The console command description.
  String description = "Init Arjunane";

  @override
  void handle() async {
    var file = new File("pubspec.yaml");
    var fileText = await file.readAsString();

    var regex = r"(dependencies:)[\s\S]+?(flutter:)[\s\S]+?(sdk:)[ ]{0,1}(flutter)";

    var matches = new RegExp(regex).allMatches(fileText);

    if(!isPackageExist(fileText, 'http') || !isPackageExist(fileText, 'provider') || !isPackageExist(fileText, 'shared_preferences') || !isPackageExist(fileText, 'path_provider')) {
      matches.forEach( (val) async {
        var match = val.group(0);
        String newValue = "";

        newValue = "$match\n";
        if(!isPackageExist(fileText, 'http')) newValue += "  http: ^0.13.1\n";
        if(!isPackageExist(fileText, 'provider')) newValue += "  provider: ^5.0.0\n";
        if(!isPackageExist(fileText, 'path_provider')) newValue += "  path_provider: ^2.0.1\n";
        if(!isPackageExist(fileText, 'shared_preferences')) newValue += "  shared_preferences: ^2.0.5";
        
        fileText = fileText.replaceAll(new RegExp(regex), newValue);

      });
    }

    // membuat folder assets
    // Directory assetsDir = new Directory('assets');
    // var isAssetsExist = await assetsDir.exists();
    // if(!isAssetsExist) assetsDir.createSync(recursive: true);

    // // regex assets  pubspec.yaml
    // var isAssetsPubExist   = new RegExp(r'(?!#).\sassets:', multiLine: true).allMatches(fileText);
    // if(isAssetsPubExist.length > 0) {
    //   var newText = '  assets:\n';
    //   newText += '    - assets/';
    //   fileText = fileText.replaceAll(new RegExp(r'(?!#).\sassets:', multiLine: true), newText);
    // }
    // else {
    //   var newText = "flutter:\n";
    //   newText += '  assets:\n';
    //   newText += '    - assets/';
    //   fileText = fileText.replaceAll(new RegExp(r'^flutter:', multiLine: true), newText);
    // }

    var sink = file.openWrite();
    sink.write(fileText);
    await sink.flush();
    await sink.close();
    super.handle();
  }

  bool isPackageExist(String fileText, String package) {
    return new RegExp(r'\s' + package + r':', multiLine: true).allMatches(fileText).length > 0;
  }

}