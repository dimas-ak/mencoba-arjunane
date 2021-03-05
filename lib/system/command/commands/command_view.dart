import 'dart:io';

import '../../command/commands.dart';

import '../../../app/config/commands.dart';

class CommandsView extends Command {

  String signature = "create:view {fileName} {controllerName}";

  String description = "Create a View";

  @override
  void handle() {
    createView();

    super.handle();
  }

  Future createView({String viewName, String controllerName}) async {

    String fileName = viewName == null ? arguments['fileName'] : viewName;
    String fileNameController = controllerName == null ? arguments['controllerName'] : controllerName;

    if(fileName == null) {
      String msg = '\n  Not enough arguments (missing: "name")\n';
      print(msg);
      return;
    }
    else if(fileNameController == null) {
      String msg = '\n  Not enough arguments (missing: "Controller file name")\n';
      print(msg);
      return;
    }

    var path = 'lib/app/view';

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

    var myFile = File('$path/$fileName${CommandsConfig.insertClassNameLast ? "_view" : ""}.dart');

    var sink = myFile.openWrite(); // for appending at the end of file, pass parameter (mode: FileMode.append) to openWrite()

    sink.write(setFileView(fileName.split("/").last, innerFolders, fileNameController));

    await sink.flush();
    await sink.close();

    print("View created successfully.");
  }

  String setFileView(String fileName, int innerFolders, String fileNameController) {

    var fileNames = fileName.split("_");
    var fileNamesController = fileNameController.split("/").last.split("_");

    String finalFileName = "";
    String finalFileNameController = "";

    fileNames.forEach( (val) {
      finalFileName += "${val[0].toUpperCase()}${val.substring(1)}";
    });

    fileNamesController.forEach( (val) {
      finalFileNameController += "${val[0].toUpperCase()}${val.substring(1)}";
    });

    String prevFolders = "../../";
    String prevFoldersController = "../";
    for(int i = 0; i < innerFolders; i++) {
      prevFolders += "../";
      prevFoldersController += "../";
    }

    String coding = "";
    // import file
    coding += "import 'package:flutter/material.dart';\n";
    coding += "import '${prevFoldersController}controller/$fileNameController${CommandsConfig.insertClassNameLast ? "_controller" : ""}.dart';\n";
    coding += "import '${prevFolders}system/arjunane.dart';\n\n";

    coding += 'class $finalFileName${CommandsConfig.insertClassNameLast ? "View" : ""} extends View<$finalFileNameController${CommandsConfig.insertClassNameLast ? "Controller" : ""}> {\n\n';

    coding += '  $finalFileName${CommandsConfig.insertClassNameLast ? "View" : ""} ($finalFileNameController${CommandsConfig.insertClassNameLast ? "Controller" : ""} prop) : super(prop);\n\n';

    coding += '  @override\n';
    coding += '  Widget build(BuildContext context) {\n\n';
    coding += '    return Scaffold(\n';
    coding += '      appBar: AppBar(\n';
    coding += '        title: Text("Your Title")\n';
    coding += '      ),\n';
    coding += '      body: Container(\n';
    coding += '        // child: your child\n'; 
    coding += '      ),\n';
    coding += '   );\n\n';
    coding += '  }\n\n';
      
    coding += '}';

    return coding;
  }
}