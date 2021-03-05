import '../../app/config/commands.dart';

import 'commands.dart';

List privateCommands = [
  new CommandsController(),
  new CommandsModel(),
  new CommandsView(),
  new CommandPlugins(),
  new CommandsViewExtends(),
  new CommandsCommand()
];

void init(List<String> args) {
  if(args.length == 0 || args == null) {

    new CommandsHelp().handle();

  } else {

    String command = args[0];
    bool isFindCommand =  false;

    if(command == "-v" || command == "--version") {
      var co = new CommandsOthers();
      co.arguments['info'] = 'info';
      co.handle();
      return;
    }
    if(command == "-h" || command == "--help") {
      var co = new CommandsHelp();
      co.handle();
      return;
    }

    // kedua : mengeksekusi perintah dari privateCommands
    privateCommands.forEach( (cls) {
      
      var clsName = cls.toString().split("'")[1];
      String signature = cls.signature;
      
      if(signature == null || signature == "") {
        print("Class of $clsName is don't have a 'signature' property");
        return;
      }

      if(signature.split(" ")[0].trim() == command) {

        isFindCommand = true;
        _setHandle(cls, args);
        // cls.handle(argumentsCommands);
        return;
      }

    });
    
    // ketiga : mengeksekusi perintah dari command yang dibuat oleh developer lain
    // jika isFindCommand bernilai false
    // maka signature dari commands yang berada di privateCommand 
    // tidak ditemukan
    if(!isFindCommand) {
      CommandsConfig.commandsAssign.forEach( (cls) {
        
        var clsName = cls.toString().split("'")[1];
        String signature = cls.signature;
        
        if(signature == null) {
          print("Class of $clsName is don't have a 'signature' property");
          return;
        }

        if(signature.trim().split(" ")[0] == command) {
          isFindCommand = true;
          _setHandle(cls, args);
          return;
        }
      });
    }

    if(!isFindCommand) print('\n\tCommand "${args.join(' ')}" is not defined.\n');

  }

}
void _setHandle(dynamic cls, List<String> args) {

  int i = 0;
  String signature = cls.signature;

  List<CommandProperty> commandsProperty = [];

  RegExp regex = new RegExp(r"{+(.*?)}");
  
  Iterable<Match> matches = regex.allMatches(signature);
  
  List<String> argumentsCommands = [];

  args.forEach( (arguments) {
    // menambahkan arguments yang di inputkan melalui command prompt
    // i == 0 ialah sebuah perintah untuk mengeksekusi perintah dari class Command
    // contoh : make:controller 
    if(i != 0) argumentsCommands.add(arguments);
    
    i++;
  });

  i = 0;

  // matches merupakan split dari signature setiap class Command
  if(matches.length > 0) {
    int length = matches.length - 1;

    matches.forEach( (val) {
      // mendapatkan value dari val
      var group = val.group(0);
      
      // misalkan ada 2 parameters
      // parameter pertama ialah argument 
      // dan parameter kedua ialah option
      // kemudian parameter pertama merupakan input arrays (contoh: {user=*})
      // maka akan di throw error karena input arrays harus berada di akhir parameters
      if(group.split("*}").length > 1 && i < length) {
        throw Exception("Input arrays must be in last of arguments");
      }
      // menghilangkan tanda {}
      var clean = group.replaceAll(new RegExp(r"{|}"), "");

      // jika clean (hasil dari menghilangkan tanda {}) ada tanda -- (double minus)
      // maka itu merupakan object option
      // maka tanda -- dan tanda optional (?) akan dihapus/replace
      // contoh : --opsi=key maka value property "key" akan menjadi "opsi"
      String key = (clean.split("--").length > 1 ? clean.replaceAll("--", "") : clean).replaceAll(new RegExp(r'\?|\=|\*'), "");
      
      /**
       * jika suatu argument atau option memiliki value 
       * yaitu ditandai dengan tanda = (sama dengan)
       * maka akan dicari apakah value tersebut ada value nya
       * atau kosong ataupun optional
       * contoh : {--all=asiyap}
       * atau contoh : {user=?}
       * tanda ? merupakan sebuah tanda untuk optional
       */
      String _defaultValue = clean.split("=").length > 1 ? clean.split("=")[1].trim() : null;

      /**
       * jika nilai/value dari _defaultValue bernilai ""
       * maka akan dibuat menjadi null
       */
      String defaultValue = _defaultValue == "" ? null : _defaultValue;

      /**
       * jika parameters memiliki tanda -- (double minus)
       * maka bisa dipastikan, parameters tersebut ialah "option"
       */
      String typeProperty = clean.split("--").length > 1 ? "option" : 'argument';

      commandsProperty.add(new CommandProperty(
        typeProperty: typeProperty,
        // jika argument memiliki tanda ?
        isArgumentOptional: clean.split("--").length == 1 && clean.split("?").length > 1,
        // jika option memiliki tanda ?
        isOptionOptional: clean.split("--").length > 1 && clean.split("?").length > 1,
        // jika argument atau option memiliki tanda *
        // dimana tanda * ialah untuk input arrays
        isArray: clean.split("*").length > 1,
        key: key,
        defaultValue: defaultValue,
        // jika parameters memiliki tanda =
        // dimana property tersebut harus memiliki nilai
        // yang bisa diisi lewat command prompt
        isAnyValue: clean.split("=").length > 1
      ));

      if(typeProperty == "argument") cls.arguments[key] = defaultValue;
      else cls.options[key] = defaultValue;

      i++;
    });
  }

  i = 0;

  // validasi apakah List commandsProperty memiliki length lebih dari 0
  if(commandsProperty.length > 0) {
    commandsProperty.forEach( (c) {
      // jika input arrays 
      // contoh : {user=*}
      if(c.isArray) {
        var index = 0;
        
        if(c.typeProperty == "argument") {

          // jika argument mempunyai nilai yang optional
          if(c.isArgumentOptional) {
            
            List listValue = [];
            if(argumentsCommands.length == 0) listValue.add(c.defaultValue);
            else {
              argumentsCommands.forEach( (val) {
                if(index >= i) listValue.add(val);
                index++;
              });
            }
            cls.arguments[c.key] = listValue;
          } else {
            List listValue = [];
            argumentsCommands.forEach( (val) {
              if(index >= i) listValue.add(val);
              index++;
            });
            
            if(CommandsConfig.showErrorInternal && (listValue.length == 0 && c.isAnyValue)) throw Exception("The argument for '${c.key}' is required");
            
            cls.arguments[c.key] = listValue;
          }
        }
        else {
          if(c.isOptionOptional) {
            
            List listValue = [];
            if(argumentsCommands.length == 0) listValue.add(c.defaultValue);
            else {
              argumentsCommands.forEach( (val) {
                if(index >= i) listValue.add(val.split("=")[1]);
                index++;
              });
            }
            cls.options[c.key] = listValue;
          } else {
            List listValue = [];
            argumentsCommands.forEach( (val) {
              if(index >= i) listValue.add(val.split("=")[1]);
              index++;
            });
            
            if(CommandsConfig.showErrorInternal && (listValue.length == 0 && c.isAnyValue)) throw Exception("The option for '${c.key}' is required");

            cls.options[c.key] = listValue;
          }
        }
        
      } else 
      
        if(c.typeProperty == "argument") {
          if(c.isArgumentOptional) {
            
            dynamic value;
            if(argumentsCommands.asMap().containsKey(i) == false) value = c.defaultValue;
            else value = argumentsCommands[i];
            cls.arguments[c.key] = value;

          } else {
            bool isNotContainKey = argumentsCommands.asMap().containsKey(i) == false;
            if( CommandsConfig.showErrorInternal && (isNotContainKey || (isNotContainKey && c.isAnyValue)) ) throw Exception("The argument for '${c.key}' is required");

            cls.arguments[c.key] = argumentsCommands.asMap().containsKey(i) ? argumentsCommands[i] : null;
          }
        }
        else {

          if(!c.isAnyValue && argumentsCommands.asMap().containsKey(i)  && argumentsCommands[i] != c.defaultValue && !c.isOptionOptional) throw Exception("The option ${c.defaultValue} is required.");

          if(c.isOptionOptional) {
            
            dynamic value;
            if(argumentsCommands.asMap().containsKey(i) == false) value = c.defaultValue;
            else value = argumentsCommands[i];
            cls.options[c.key] = c.isAnyValue ? value.split("=")[1] : value;

          } else {
            
            bool isNotContainKey = argumentsCommands.asMap().containsKey(i) == false;
            if( CommandsConfig.showErrorInternal && (isNotContainKey || (isNotContainKey && c.isAnyValue)) ) throw Exception("The option for '${c.key}' is required");

            cls.options[c.key] = c.isAnyValue ? argumentsCommands[i].split("=")[1] : argumentsCommands[i];
          }
        }

      i++;
    });

  }

  cls.handle();
  
}