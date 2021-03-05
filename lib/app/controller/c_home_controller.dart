import 'package:flutter/material.dart';
import '../../system/arjunane.dart';
import '../view/v_home_view.dart';
import '../model/m_home_model.dart';

class CHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CHomeController();
}

class CHomeController extends Controller<CHomePage> {
  MHomeModel mHomeModel = new MHomeModel();

  @override
  void initState() {

    // TODO: implement initState
    if(mounted) {
      mHomeModel.setController = this;
      mHomeModel.provider().exampleMethod(this);
    }

    super.initState();
  }

  @override
  void dispose() {

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return VHomeView(this);
  }
}