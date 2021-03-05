import 'dart:io';

import '../commands_class.dart';

class CommandPlugins extends Command {

  // The name and signature of the console command.
  String signature = "insert:plugins";

  // The console command description.
  String description = "Insert Plugins";

  @override
  void handle() async {
    // TODO: implement handle
    var file = new File("pubspec.yaml");
    var fileText = await file.readAsString();

    var regex = r"(dependencies:)[\s\S]+?(flutter:)[\s\S]+?(sdk:)[ ]{0,1}(flutter)";

    var matches = new RegExp(regex).allMatches(fileText);

    matches.forEach( (val) async {
      var match = val.group(0);
      String newValue = "";

      newValue = "$match\n";
      newValue += "  http: any\n";
      newValue += "  provider: any";
      
      fileText = fileText.replaceAll(new RegExp(regex), newValue);

      var sink = file.openWrite();
      sink.write(fileText);
      await sink.flush();
      await sink.close();
    });
    
    super.handle();
  }

}