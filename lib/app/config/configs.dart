import 'package:flutter/material.dart';
import '../model/m_home_model.dart';
import '../controller/c_home_controller.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class Configs
{
  static final Map<String, Widget> routes = {
    'home' : CHomePage()
  };

  static final String baseRoute = 'home';

  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (BuildContext context) => MHomeModel())
  ];
}