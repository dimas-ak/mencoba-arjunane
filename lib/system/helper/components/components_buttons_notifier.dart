import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/models/arjunane_model_buttons_notifier.dart';
import 'package:provider/provider.dart';
import '../flat_colors.dart';
import '../helper.dart';
import 'components_buttons_notifier_status.dart';

class ButtonsNotifier {

  final int milliseconds;
  final BuildContext context;

  final String _keys = Helper.randomString();

  String _defaultText;
  String _loadingText;
  String _successText;
  String _errorText;

  ButtonsNotifier(this.context, {this.milliseconds});

  Widget setButton(String text, {Function onPressed, Function onLongPressed, String loadingText, String successText, String errorText}) {
    _defaultText = text;
    _loadingText = loadingText;
    _successText = successText;
    _errorText = errorText;
    return Selector<ArjunaneModelButtonsNotifier, Map<String, ButtonsNotifierStatus>>(
      builder: (ctx, data, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(_colorButton(data[_keys]))
            ),
            key: ValueKey<ButtonsNotifierStatus>(data[_keys]),
            onPressed: () {  
              if((data[_keys] == null || data[_keys] == ButtonsNotifierStatus.begin) && onPressed != null) {
                onPressed();
              }
            },
            onLongPress: () {
              if((data[_keys] == null || data[_keys] == ButtonsNotifierStatus.begin) && onLongPressed != null) {
                onLongPressed();
              }
            },
            child: _buttons(data[_keys])
          )
        );
      },
      selector: (ctx, model) => model.getButtonsNotifier,
    );
  }

  Color _colorButton(ButtonsNotifierStatus status) {
    Color color;
    switch (status) {
      case ButtonsNotifierStatus.loading:
          color = FlatColors.googleBlue;
        break;
      case ButtonsNotifierStatus.error:
          color = FlatColors.googleRed;
        break;
      case ButtonsNotifierStatus.success:
          color = FlatColors.googleGreen;
        break;
      default:
          color = FlatColors.googleBlue;
        break;
    }
    return color;
  } 

  Widget _buttons(ButtonsNotifierStatus status) {
    Widget widget;
    switch (status) {
      case ButtonsNotifierStatus.loading:
          widget = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(padding: EdgeInsets.all(5), 
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child:  CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white)
                  )
                )
              ),
              if(_loadingText != null) Padding(padding: EdgeInsets.only(left: 10), child: Text(_loadingText))
            ],
          );
        break;
      case ButtonsNotifierStatus.error:
          widget = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cancel_outlined, color: Colors.white),
              if(_errorText != null) Padding(padding: EdgeInsets.only(left: 10), child: Text(_errorText))
            ],
          );
        break;
      case ButtonsNotifierStatus.success:
          widget = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_outlined, color: Colors.white),
              if(_successText != null) Padding(padding: EdgeInsets.only(left: 10), child: Text(_successText))
            ],
          );
        break;
      default:
          widget = Text(_defaultText);
        break;
    }
    return widget;
  }

  void setStatusError() => Provider.of<ArjunaneModelButtonsNotifier>(context, listen: false).changeButtonsNotifierStatus = {_keys : ButtonsNotifierStatus.error};
  void setStatusLoading() => Provider.of<ArjunaneModelButtonsNotifier>(context, listen: false).changeButtonsNotifierStatus = {_keys : ButtonsNotifierStatus.loading};
  void setStatusSuccess() => Provider.of<ArjunaneModelButtonsNotifier>(context, listen: false).changeButtonsNotifierStatus = {_keys : ButtonsNotifierStatus.success};
  void setStatusDefault() => Provider.of<ArjunaneModelButtonsNotifier>(context, listen: false).changeButtonsNotifierStatus = {_keys : ButtonsNotifierStatus.begin};

}