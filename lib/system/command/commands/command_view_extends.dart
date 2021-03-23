import 'dart:io';

import '../../command/commands.dart';

import '../../../app/config/commands.dart';

class CommandsViewExtends extends Command {

  String signature = "create:view-extends {fileName} {viewName}";

  String description = "Create a View Extends";

  @override
  void handle() {
    createView();

    super.handle();
  }

  Future createView() async {

    String fileName = arguments['fileName'];
    String fileNameView = arguments['viewName'];

    if(fileName == null) {
      String msg = '\n  Not enough arguments (missing: "name")\n';
      print(msg);
      return;
    }
    else if(fileNameView == null) {
      String msg = '\n  Not enough arguments (missing: "View file name")\n';
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

    var myFile = File('$path/$fileName${CommandsConfig.insertClassNameLast ? "_view_extends" : ""}.dart');

    var sink = myFile.openWrite(); // for appending at the end of file, pass parameter (mode: FileMode.append) to openWrite()

    sink.write(setFileView(fileName.split("/").last, innerFolders, fileNameView));

    await sink.flush();
    await sink.close();

    print("View Extends created successfully.");
  }

  String setFileView(String fileName, int innerFolders, String fileNameView) {

    var fileNames = fileName.split("_");
    var fileNamesView = fileNameView.split("/").last.split("_");

    String finalFileName = "";
    String finalFileNameView = "";

    fileNames.forEach( (val) {
      finalFileName += "${val[0].toUpperCase()}${val.substring(1)}";
    });

    fileNamesView.forEach( (val) {
      finalFileNameView += "${val[0].toUpperCase()}${val.substring(1)}";
    });


    String prevFolders = "../../";
    String prevFoldersView = "../";
    for(int i = 0; i < innerFolders; i++) {
      prevFolders += "../";
      prevFoldersView += "../";
    }

    String coding = "";
    // import file
    coding += "import 'package:flutter/material.dart';\n";
    coding += "import '${prevFoldersView}view/$fileNameView${CommandsConfig.insertClassNameLast ? "_view" : ""}.dart';\n";
    coding += "import '${prevFolders}system/arjunane.dart';\n\n";

    coding += 'class $finalFileName${CommandsConfig.insertClassNameLast ? "ViewExtends" : ""} extends ViewExtends<$finalFileNameView${CommandsConfig.insertClassNameLast ? "View" : ""}> {\n\n';

    coding += '  $finalFileName${CommandsConfig.insertClassNameLast ? "ViewExtends" : ""} ($finalFileNameView${CommandsConfig.insertClassNameLast ? "View" : ""} view) : super(view);\n\n';

    coding += '  @override\n';
    coding += '  Widget build(BuildContext context) {\n\n';
    
    coding += "  var parent = view.controller;\n\n";

    coding += '    return Container(\n';
    coding += '    );\n\n';
    coding += '  }\n\n';
      
    coding += '}';

    return coding;
  }
}