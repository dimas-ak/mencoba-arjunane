import 'dart:io';

class ReadFile {
  final String _fileLocation;

  String? _fileText;
  late File _file;
  ReadFile(this._fileLocation);
  
  Future init() async {
    _file = File(_fileLocation);
    _fileText = await _file.readAsString();
  }

  ReadFile setVariable(String variableName, String variableValue, {bool isOverWrite = false}) {
    var reg = r".*(" + variableName + r")[\s\S]+?;";
    var regex = new RegExp(reg);

    var variables = regex.allMatches(_fileText!);
    if(variables.length == 0) throw Exception("Cannot find variable with name '$variableName'");
    variables.forEach( (val) {
      var group = val.group(0)!;
      // mendapatkan property
      // contoh : 
      //   static List mencoba
      var getAttribute = new RegExp(r".*(" + variableName + r")").allMatches(group).first.group(0)!;
      // mendapatkan spasi di "  static List mencoba"
      // contoh di atas, ada 2 whitespace sebelum "static"
      var getAttributeSpace = new RegExp(r"^\s+").allMatches(getAttribute);
      
      var getAttributeLength = getAttributeSpace.length != 0 ? getAttributeSpace.first.group(0)!.length : 0;

      if(_isArray(group) || _isMap(group)) {
        bool isArray = _isArray(group);
        // contoh :
        // mencobaProperty = [
        //
        //]
        var getProperty = new RegExp(r"(" + variableName + r")[\s\S]+?;").allMatches(group).first.group(0)!;
        
        var lastRegex = isArray ? r")\W+\[|\];" : r")\W+{|};";
        var clean = getProperty.replaceAll(new RegExp(r"(" + variableName + lastRegex), "");
        
        var split = clean.trimRight().split("//split");
        split.removeWhere((item) => item.length == 0);
        
        var newVariable = _addPaddingLeft(getAttributeLength + 2) + "$variableValue";
        
        split.add("\n$newVariable\n${_addPaddingLeft(getAttributeLength)}");
        
        var join = split.join(",//split");
        
        if(split.length == 1 || isOverWrite) {
          String newValue = "";
          
          if(isArray) {
            newValue += "\[\n";
            newValue += _addPaddingLeft(getAttributeLength + 2) + variableValue + ",\n";
            newValue += _addPaddingLeft(getAttributeLength) + "\]// split";
          }
          else {
            newValue += "{\n";
            newValue += _addPaddingLeft(getAttributeLength + 2) + variableValue + ",\n";
            newValue += _addPaddingLeft(getAttributeLength) + "}// split";
          }

          var removeWhiteSpace = getProperty.replaceAll(new RegExp(r"^\s+|\s+$|\s+(?=\s)"), "");
          if(isOverWrite) {
            var removeValue = getProperty.replaceAll(new RegExp(r"\[[^]*\];|{[^]*\};"), "$newValue;");
            var escapeGetProperty = getProperty.replaceAll("[", "\\[").replaceAll("]", "\\]");
            _fileText = _fileText!.replaceAll(new RegExp(escapeGetProperty), removeValue);
          }else {
            var _regex = isArray ? r"\[[\s\S]\]|\[*\]" : r"{[\s\S]}|{*}";
            var value = removeWhiteSpace.replaceAll(new RegExp(_regex), newValue);
            var escapeGetProperty = getProperty.replaceAll("[", "\\[").replaceAll("]", "\\]");
            _fileText = _fileText!.replaceAll(new RegExp(escapeGetProperty), value);
          }
          
        }
        else {
          var escapeClean = clean.replaceAll("(", "\\(").replaceAll(")", "\\)");
          // var value = getProperty.replaceAll(new RegExp(escapeClean), join);
          _fileText = _fileText!.replaceAll(new RegExp(escapeClean), join);
        }
      }
      else if(_isBool(group)) {
        var newValue = group.replaceAll(new RegExp(r"true|false"), variableValue);
        _fileText = _fileText!.replaceAll(new RegExp(group), "${_addPaddingLeft(getAttributeLength)}$newValue");
      }
      else if(_isString(group)) {
        var newValue = group.replaceAll(new RegExp('"[\s\S]+?";|\'[\s\S]+?\';'), "'$variableValue'");
        _fileText = _fileText!.replaceAll(new RegExp(group), "${_addPaddingLeft(getAttributeLength)}$newValue");
      }
      else if(_isNumeric(group)) {
        var getNumber = group.replaceAll(new RegExp(r"(.*)=[\W]|(.*)=|;"), "");
        var newValue = group.replaceAll(new RegExp(getNumber), variableValue).trim();
        _fileText = _fileText!.replaceAll(new RegExp(group), "${_addPaddingLeft(getAttributeLength)}$newValue");
      }
    });
    return this;
  }

  ReadFile setImport(String importFilePath) {
    var regex = r"(import)[\s\S]+?;";
    var matches = new RegExp(regex).allMatches(_fileText!);
    var newValue = "import '$importFilePath';";
    if(matches.length > 0) {
      String lastImport = matches.last.group(0)!;
      var imports = '$lastImport\n$newValue';
      _fileText = _fileText!.replaceAll(new RegExp(lastImport), imports);
      return this;
    }
    var newFile = newValue + "\n" + _fileText!;
    _fileText = newFile;
    return this;
  }

  void setFile() async {
    var sink = _file.openWrite();
    sink.write(_fileText);
    await sink.flush();
    await sink.close();
  }

  bool _isString(String text) {
    var regex = "(String)|(String)[\s\S]+?\";|(String)[\s\S]+?';|\"[\s\S]+?\";|'[\s\S]+?'";
    return new RegExp(regex).allMatches(text).length != 0;
  }

  bool _isArray(String text) {
    return new RegExp(r"\[|\]").allMatches(text).length != 0;
  } 

  bool _isBool(String text) {
    return new RegExp(r"true|false").allMatches(text).length != 0;
  }

  bool _isMap(String text) {
    return new RegExp(r"{|}").allMatches(text).length != 0;
  }

  bool _isNumeric(String text) {
    return new RegExp('"[\s\S]+?";|\'[\s\S]+?\';').allMatches(text).length == 0;
  }

  String _addPaddingLeft(int howMany) {
    String space = "";
    for(var i = 0; i < howMany; i++) {
      space += " ";
    }
    return space;
  }
}