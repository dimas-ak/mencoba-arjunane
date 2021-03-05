import '../../system/arjunane.dart';

class MHomeModel extends Model {

  MHomeModel provider() => updateProvider<MHomeModel>();

  void exampleMethod(Controller controller) {

    // var con = controller as HomeController;
    // con.title = "Mencoba saja";
    notifyListeners();
  }

}