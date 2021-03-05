import 'package:flutter/material.dart';
import '../../arjunane.dart';
import '../../arjunane_model.dart';
import 'package:provider/provider.dart';

class AlertsDialogNotifier {
  
  final double _width = 75;

  Future show(BuildContext context, {bool dismissible = false, Function onClickSuccess, String textButtonSuccess = "OK", Function onClickError, String textButtonError = "OK"}) async {
    updateAlertsDialog(context);
    return await showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: dismissible,
      barrierLabel: '',
      transitionBuilder: (ctx, anim1, anim2, widget) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Container(
                      width: double.infinity,
                      height: 75,
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          
                          // progress
                          Consumer<ArjunaneModel>(builder: (context, data, _) => AnimatedPositioned(
                            top: data.getAlertsDialogNotifierStatus == AlertsDialogStatus.progress ? 2 : -_width,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(FlatColors.googleBlue)
                            ), duration : Duration(milliseconds: 200)
                          )),
                          
                          // success
                          Consumer<ArjunaneModel>(builder: (context, data, _) {
                            return AnimatedPositioned(
                              top: data.getAlertsDialogNotifierStatus == AlertsDialogStatus.success? 0 : -_width,
                              duration: Duration(milliseconds: 200),
                              child: Container(
                                child: Icon(Icons.check_circle, color: FlatColors.googleGreen, size: 50)
                              ),
                            );
                          }),

                          // error
                          Consumer<ArjunaneModel>(builder: (context, data, _) {
                            return AnimatedPositioned(
                              top: data.getAlertsDialogNotifierStatus == AlertsDialogStatus.error ? 0 : -_width,
                              duration: Duration(milliseconds: 200),
                              child: Container(
                                child: Icon(Icons.error_outlined, color: FlatColors.googleGreen, size: 50)
                              ),
                            );
                          }),

                        ],
                      )
                    ),
                    Consumer<ArjunaneModel>(builder: (context, data, _) {
                      return Text(data.getAlertsDialogNotifierMessage);
                    }),
                    Align(
                      alignment: Alignment.topRight,
                      child: Consumer<ArjunaneModel>(builder: (context, data, _) {
                        if(data.getAlertsDialogNotifierStatus == AlertsDialogStatus.success) {
                          return TextButton(child: Text(textButtonSuccess), onPressed: () {
                            if(onClickSuccess != null) onClickSuccess();
                            closeDialog(context);
                          });
                        }
                        else if(data.getAlertsDialogNotifierStatus == AlertsDialogStatus.error) {
                          return TextButton(child: Text(textButtonError), onPressed: () {
                            if(onClickError != null) onClickError();
                            closeDialog(context);
                          });
                        }
                        else return Container();
                      }),
                    )
                  ],
                ),
              )
            )
          )
        );
      }, pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => null
    ); 
  }

  void updateAlertsDialog(BuildContext context, {AlertsDialogStatus status = AlertsDialogStatus.progress, String message = 'Loading ...'}) {
    Provider.of<ArjunaneModel>(context, listen: false).changeMessageAlertDialogNotifier = message;
    Provider.of<ArjunaneModel>(context, listen: false).changeStatusAlertDialogNotifier = status;
  }
}

enum AlertsDialogStatus {
  progress,
  success,
  error
}