import '../../command/commands.dart';

import '../../arjunane_info.dart';

class CommandsHelp extends Command {

  void handle() {
    String msg = "${ArjunaneInfo.applicationName} ${ArjunaneInfo.version}\n";

    msg += "\nUsage :\n";
    msg += "  command [options] [arguments]\n";

    msg += "\nOptions :\n";
    msg += "  -h --help     \tDisplay this help message\n";
    msg += "  -v --version  \tDisplay this applicaiton version\n";

    msg += '\nAvailable commands:';
    msg += '\n  make';
    msg += '\n    make:controller     \tCreate a new controller class';
    msg += '\n    make:model          \tCreate a new model class';
    msg += '\n    make:view           \tCreate a new view class';
    msg += '\n    make:view-extends   \tCreate a new view class';

    print(msg);
  }

}