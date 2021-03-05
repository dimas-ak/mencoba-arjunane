import 'dart:io' show Platform;

class FontSize {
  
  static double get micro => Platform.isAndroid ? 10 : 11; 

  static double get small => Platform.isAndroid ? 14 : 13; 

  static double get medium => Platform.isAndroid ? 17 : 16; 

  static double get large => Platform.isAndroid ? 22 : 20; 

  static double get title => Platform.isAndroid ? 24 : 28; 

}