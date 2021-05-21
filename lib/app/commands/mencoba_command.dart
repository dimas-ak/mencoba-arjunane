import '../../system/command/commands_class.dart';

class MencobaCommand extends Command {

  // The name and signature of the console command.
  String? signature = "make:mencoba";

  // The console command description.
  String? description = "Create a Command";

  @override
  void handle() {
    // TODO: implement handle
    print("ASIYAP");
    super.handle();
  }

}