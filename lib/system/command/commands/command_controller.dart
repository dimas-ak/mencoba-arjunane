import 'dart:io';

import '../../../app/config/commands.dart';

import '../commands.dart';

class CommandsController extends Command {

  String signature = "create:controller {fileName} {--all?}";

  String description = "Create a Controller";

  @override
  void handle() async {
    var fileName = arguments['fileName'];
    
    if(fileName == null) {
      String msg = '\n  Not enough arguments (missing: "name")\n';
      print(msg);
      return;
    }
    
    String nameView;
    String nameModel;
    
    if(options['all'] != null) {

      if(options['all'] != "--all") {
        print("\n  Cannot find command : ${options['all']}\n  Do you mean '--all'?");
        return;
      }

      String _nameView = ask("Enter View class Name : ");
      String _nameModel = ask("Enter Model class Name : ");

      nameView = _nameView.trim() == "" ? null : _nameView;
      nameModel = _nameModel.trim() == "" ? null : _nameModel;

    }

    createController(fileName, nameModel, nameView);

    super.handle();
  }

  Future createController(String fileName, String model, String view) async {
    
    var path = 'lib/app/controller';

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

    var myFile = File('$path/$fileName${CommandsConfig.insertClassNameLast ? "_controller" : ""}.dart');

    var sink = myFile.openWrite(); // for appending at the end of file, pass parameter (mode: FileMode.append) to openWrite()

    sink.write(setFileController(fileName.split("/").last, innerFolders, view, model));

    await sink.flush();
    await sink.close();

    print("Controller created successfully.");
    
    if(view != null) {
      new CommandsView().createView(viewName: view, controllerName: fileName);
    }

    if(model != null) {
      new CommandsModel().createModel(fileNameModel: model);
    }
    
  }

  String setFileController(String fileName, int innerFolders, String view, String model) {

    var fileNames = fileName.split("_");

    String finalFileName = "";
    String finalFileNameModel = "";
    String finalFileNameView = "";
    String finalFileNameModelProperty = "";

    fileNames.forEach( (val) {
      finalFileName += "${val[0].toUpperCase()}${val.substring(1)}";
    });

    if(view != null) {

      var fileNamesView = view.split("_");

      fileNamesView.forEach( (val) {
        finalFileNameView += "${val[0].toUpperCase()}${val.substring(1)}";
      });

    }

    if(model != null) {

      var fileNamesModel = model.split("_");
      fileNamesModel.forEach( (val) {
        finalFileNameModel += "${val[0].toUpperCase()}${val.substring(1)}";
      });
      finalFileNameModel += CommandsConfig.insertClassNameLast ? "Model" : "";

      finalFileNameModelProperty = '${finalFileNameModel[0].toLowerCase()}${finalFileNameModel.substring(1)}';
      
    }

    String prevFolders = "../../";
    String prevFoldersMV = "../";
    for(int i = 0; i < innerFolders; i++) {
      prevFolders += "../";
      prevFoldersMV += "../";
    }

    String coding = "";
    // import file
    coding += "import 'package:flutter/material.dart';\n";
    coding += "import '${prevFolders}system/arjunane.dart';\n";
    // import View
    if(view != null) coding += "import '${prevFoldersMV}view/$view${CommandsConfig.insertClassNameLast ? "_view" : ""}.dart';\n";
    // import model
    if(model != null) coding += "import '${prevFoldersMV}model/$model${CommandsConfig.insertClassNameLast ? "_model" : ""}.dart';\n";

    coding += '\n';

    // StatefulWidget
    coding += 'class $finalFileName${CommandsConfig.insertClassNameLast ? "Page" : ""} extends StatefulWidget {\n';
    coding += '  @override\n';
    coding += '  State<StatefulWidget> createState() => $finalFileName${CommandsConfig.insertClassNameLast ? "Controller" : ""}();\n';
    coding += '}\n\n';

    coding += 'class $finalFileName${CommandsConfig.insertClassNameLast ? "Controller" : ""} extends Controller<$finalFileName${CommandsConfig.insertClassNameLast ? "Page" : ""}> {\n';
    
    // insert Model
    if(model != null) {
      coding += '  $finalFileNameModel $finalFileNameModelProperty = new $finalFileNameModel();\n\n';
    }

    // initState
    coding += '  @override\n';
    coding += '  void initState() {\n\n';
    coding += '    // TODO: implement initState\n';
    if(model != null) {
      coding += '    if(mounted) {\n';
      coding += '      $finalFileNameModelProperty.setController = this;\n';
      coding += '      $finalFileNameModelProperty.provider().exampleMethod(this);\n';
      coding += '    }\n\n';
    }
    coding += '    super.initState();\n';
    coding += '  }\n\n';

    //dispose
    coding += '  @override\n';
    coding += '  void dispose() {\n\n';
    coding += '    // TODO: implement dispose\n';
    coding += '    super.dispose();\n';
    coding += '  }\n\n';

    //view
    coding += '  @override\n';
    coding += '  Widget build(BuildContext context) {\n\n';
    coding += '    // TODO: implement build\n';

    if(view != null) {
      coding += '    return $finalFileNameView${CommandsConfig.insertClassNameLast ? "View" : ""}(this);\n';
    } else {
      coding += '    throw UnimplementedError();\n';
    }
    
    coding += '  }\n';

    coding += '}';

    return coding;
  }
}