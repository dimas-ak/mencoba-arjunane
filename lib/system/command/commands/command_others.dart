import '../../command/commands.dart';

import '../../arjunane_info.dart';
class CommandsOthers extends Command {
  @override
  void handle() {
    
    if(arguments['info'] == "info") showVersion();
    super.handle();
  }

  void showVersion() {
    String msg = "${ArjunaneInfo.applicationName} ${ArjunaneInfo.version}\n";
    print(msg);
  }
}