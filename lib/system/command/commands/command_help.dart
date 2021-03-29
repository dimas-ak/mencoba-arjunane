import 'dart:collection';

import '../../../app/config/commands.dart';

import '../../command/commands.dart';

import '../../arjunane_info.dart';

class CommandsHelp extends Command {

  SplayTreeMap<String, String> data = new SplayTreeMap<String, String>();
  SplayTreeMap<String, List<_CommandsProperty>> dataKey = new SplayTreeMap<String, List<_CommandsProperty>>();

  void handle() {
    var createCommands = [
      new CommandsViewExtends(),
      new CommandsController(),
      new CommandsView(),
      new CommandsModel(),
      new CommandPlugins(),
      new CommandsCommand()
    ];

    var otherCommands = CommandsConfig.commandsAssign;
    
    assignCommand(otherCommands);
    assignCommand(createCommands);
    
    
    String msg = "${ArjunaneInfo.applicationName} ${ArjunaneInfo.version}\n";

    msg += "\nUsage :\n";
    msg += "  command [options] [arguments]\n";

    msg += "\nOptions :\n";
    msg += "  -h --help     \tDisplay this help message\n";
    msg += "  -v --version  \tDisplay this applicaiton version\n";

    msg += '\nAvailable commands:';

    data.forEach((key, value) {
      msg += "\n  $key${descriptionLine(key)}  $value";
    });
    dataKey.forEach((key, value) {
      msg += "\n  $key";
      value.forEach((element) {
        msg += "\n    ${element.signature}${descriptionLine(element.signature)}${element.description}";
      });
    });
    
    print(msg);
  }

  String descriptionLine(String signature) {
    int max = 40 - signature.length;
    var newLine = "";
    for (var i = 0; i < max; i++) {
      newLine += " ";
    }
    return newLine;
  }

  void assignCommand(List commands) {
    commands.forEach((element) {
      var split = element.signature.split(":");
      var key = split[0];
      if(split.length > 1) {
        if(!dataKey.containsKey(key)) dataKey[key] = [];
        dataKey[key].add(new _CommandsProperty(element.signature.split(" ")[0], element.description));
      }
      else data[key] = element.description;
    });
    dataKey.forEach((key, value) {
      value.sort( (a,b) => a.signature.compareTo(b.signature));
    });
  }

}

class _CommandsProperty {
  final String signature;
  final String description;
  _CommandsProperty(this.signature, this.description);
}