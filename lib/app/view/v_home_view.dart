import 'package:flutter/material.dart';
import '../controller/c_home_controller.dart';
import '../../system/arjunane.dart';

class VHomeView extends View<CHomeController> {

  VHomeView (CHomeController prop) : super(prop);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Title")
      ),
      body: Container(
        // child: your child
      ),
   );

  }

}