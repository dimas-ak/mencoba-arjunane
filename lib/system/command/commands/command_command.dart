import 'dart:io';

import '../../library/read_file.dart';

import '../../../app/config/commands.dart';

import '../../command/commands.dart';

class CommandsCommand extends Command {

  String signature = "create:command {fileName}";

  String description = "Create a Command";

  @override
  void handle() {
    createCommand();
    // TODO: implement handle
    super.handle();
  }

  void createCommand() async {
    var fileName = arguments['fileName'];
    if(fileName == null) {
      String msg = '\n  Not enough arguments (missing: "name")\n';
      print(msg);
      return;
    }
    
    var overWriteFile = new ReadFile("lib/app/config/commands.dart");
    await overWriteFile.init();

    var path = 'lib/app/commands';
    
    var folders = fileName.split("/");
    int innerFolders = 0;
    if(folders.length > 1) {

      String _path = path;
      for(int i = 0; i < folders.length - 1; i++) {

        innerFolders += 1;
        String folder = folders[i];
        _path += '/$folder';

        Directory dir = new Directory(_path);
        bool isExist = await dir.exists();

        // jika folder tidak ada
        if(!isExist) {
          dir.createSync();
        }
      }
    }

    var myFile = File('$path/$fileName${CommandsConfig.insertClassNameLast ? "_command" : ""}.dart');

    var sink = myFile.openWrite(); // for appending at the end of file, pass parameter (mode: FileMode.append) to openWrite()
    
    var fileNames = fileName.split("/").last.split("_");

    String finalFileName = "";

    fileNames.forEach( (val) {
      finalFileName += "${val[0].toUpperCase()}${val.substring(1)}";
    });

    sink.write(setFileCommand(finalFileName, innerFolders));

    await sink.flush();
    await sink.close();

    overWriteFile.setVariable('commandsAssign', "new $finalFileName${CommandsConfig.insertClassNameLast ? "Command" : ""}()");
    overWriteFile.setImport("../commands/$fileName${CommandsConfig.insertClassNameLast ? "_command" : ""}.dart");
    overWriteFile.setFile();
  }

  String setFileCommand(String fileName, int innerFolders) {
    String coding = "";

    String prevFolders = "../../";
    for(int i = 0; i < innerFolders; i++) {
      prevFolders += "../";
    }

    coding += "import '${prevFolders}system/command/commands_class.dart';\n\n";

    coding += 'class $fileName${CommandsConfig.insertClassNameLast ? "Command" : ""} extends Command {\n\n';

    coding += "  // The name and signature of the console command.\n";
    coding += '  String signature = "make:mencoba";\n\n';

    coding += "  // The console command description.\n";
    coding += '  String description = "Create a Command";\n\n';

    coding += "  @override\n";
    coding += '  void handle() {\n';
    coding += '    // TODO: implement handle\n';
    coding += '    super.handle();\n';
    coding += '  }\n\n';

    coding += "}";

    return coding;
  }
}

// class CommandsCommand extends Command {
  
//   String signature = "make:command";

//   String description = "Create a Command";

//   @override
//   void handle() {
//     // TODO: implement handle
//     super.handle(args);
//   }
// }