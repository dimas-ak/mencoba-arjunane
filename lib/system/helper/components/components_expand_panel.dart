import 'package:flutter/material.dart';
import '../../arjunane.dart';
import '../../core/models/arjunane_model_expand_panel.dart';
import '../../core/theme_core.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ExpandPanel extends StatefulWidget {

  final Widget header;
  final Widget body;
  final Key? key;
  final bool Function()? expanded;
  final void Function(bool?)? onChanged;

  ExpandPanel({
    this.key,
    required this.header,
    required this.body,
    this.onChanged,
    this.expanded
  }) : super(key: key);

  final ExpandPanelProperty property = new ExpandPanelProperty(
      id: Helper.randomString(),
      isExpanded: false
    );

  @override
  State<StatefulWidget> createState() => _ExpandPanel();

}

class _ExpandPanel extends State<ExpandPanel> with TickerProviderStateMixin {

  late AnimationController controller;
  late AnimationController controllerScale;
  Animation<double>? animationScale;

  @override
  void initState() {

    if(widget.expanded != null) widget.expanded!();

    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));

    controllerScale = AnimationController(vsync: this, duration: Duration(seconds: 1));
    controllerScale.value = widget.property.isExpanded! ? 1 : 0;
    animationScale = CurvedAnimation(
      parent: controllerScale,
      curve: Curves.elasticIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Consumer<ArjunaneModelExpandPanel>(
      builder: (ctx, data, _) {
        return Container(
          decoration: BoxDecoration(
            color: ThemeCore.themeData!.cardColor,
            border: Border.all(color: ThemeCore.themeData!.canvasColor)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child:Padding(
                      padding: EdgeInsets.all(10), 
                      child:  widget.header)
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    child: AnimatedBuilder(
                      animation: controller, 
                      builder: (BuildContext context, Widget? child) { 
                        return Transform.rotate(
                          angle: widget.property.isExpanded! ? 180 * math.pi / 180 : 0, 
                          child: Icon(Icons.keyboard_arrow_down_outlined, size: 30, color: ThemeCore.themeData!.accentTextTheme.bodyText1!.color)
                        );
                      },
                    ),
                    //child: Icon(widget.property.isExpanded ? Icons.arrow_drop_up_outlined : Icons.arrow_drop_down_outlined, size: 30, color: ThemeCore.themeData.accentTextTheme.bodyText1.color,),
                    onTap: () {
                      Provider.of<ArjunaneModelExpandPanel>(context, listen: false).expand(widget.property.id, !widget.property.isExpanded!);
                      widget.property.isExpanded = !widget.property.isExpanded!;
                      if(widget.onChanged != null) widget.onChanged!(widget.property.isExpanded);
                    },
                  ),
                ],
              ),
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(border: Border.all(width: 0, color: Colors.transparent)),
                height: widget.property.isExpanded! ? null : 0,
                child: Transform.scale(scale: widget.property.isExpanded! ? 1 : 0, child: widget.body)
              )
            ],
          )
        );
      },
    );
  }

}

class ExpandPanelProperty {
  String? id;
  bool? isExpanded;
  ExpandPanelProperty({this.id, this.isExpanded});
}