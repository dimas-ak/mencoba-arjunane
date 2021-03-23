import 'dart:io';

import '../../library/read_file.dart';

import '../../command/commands.dart';

import '../../../app/config/commands.dart';

class CommandsModel extends Command {

  String signature = "create:model {fileName}";

  String description = "Create a Model";

  @override
  void handle() {
    
    createModel();

    super.handle();
  }
  Future createModel({String fileNameModel}) async {

    var fileName = fileNameModel == null ? arguments['fileName'] : fileNameModel;
    
    if(fileName == null) {
      String msg = '\n  Not enough arguments (missing: "name")\n';
      print(msg);
      return;
    }

    var overWriteFile = new ReadFile("lib/app/config/commands.dart");
    await overWriteFile.init();
    
    var path = 'lib/app/model';

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

    var myFile = File('$path/$fileName${CommandsConfig.insertClassNameLast ? "_model" : ""}.dart');

    var sink = myFile.openWrite(); // for appending at the end of file, pass parameter (mode: FileMode.append) to openWrite()

    sink.write(setFileModel(fileName.split("/").last, innerFolders));

    await sink.flush();
    await sink.close();

    print("Model created successfully.");
  }

  String setFileModel(String fileName, int innerFolders) {

    var fileNames = fileName.split("_");

    String finalFileName = "";

    fileNames.forEach( (val) {
      finalFileName += "${val[0].toUpperCase()}${val.substring(1)}";
    });

    String prevFolders = "../../";
    for(int i = 0; i < innerFolders; i++) {
      prevFolders += "../";
    }

    String coding = "";
    // import file
    coding += "import '${prevFolders}system/arjunane.dart';\n\n";

    coding += "class $finalFileName${CommandsConfig.insertClassNameLast ? "Model" : ""} extends Model {\n\n";

    coding += '  $finalFileName${CommandsConfig.insertClassNameLast ? "Model" : ""} provider() => updateProvider<$finalFileName${CommandsConfig.insertClassNameLast ? "Model" : ""}>();\n\n';

    coding += '  void exampleMethod(Controller controller) {\n\n';
    coding += '    setFunction(() {\n';
    coding += '     // var con = controller as HomeController;\n';
    coding += '     // con.title = "Mencoba saja";\n';
    coding += '     notifyListeners();\n';
    coding += '    });\n';
    coding += '  }\n\n';
    coding += '}';

    return coding;
  }
}