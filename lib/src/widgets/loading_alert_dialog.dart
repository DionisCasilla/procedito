import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:procredito/src/helper/cresponsive.dart';

class LoadingAlertDialog extends StatefulWidget {
  final String loadingTitle;
  final int tipo;
  final String subTitle;
  final String textToCopy;
  final bool showBtn;

  ///[tipo]
  ///muestra el header 1-Cargando 2-Completado 3- Error
  LoadingAlertDialog({required this.loadingTitle, this.tipo = 1, this.subTitle = "", this.textToCopy = "", this.showBtn = false});

  @override
  _LoadingAlertDialogState createState() => _LoadingAlertDialogState();
}

class _LoadingAlertDialogState extends State<LoadingAlertDialog> {
  List<String> a = [];
  List<Widget> textRequerido = [];
  final _controller = TextEditingController();

  double heightCustom = 90.0;

  @override
  void initState() {
    // TO DO: implement initState
    //  print(widget.subTitle);
    if (widget.subTitle.contains("-")) {
      final aaa = widget.subTitle.trim().toString();
      a = aaa.split(".");

      final b = ((a.length) * 25);
      heightCustom = 150.00 + b;
      // print(a);
    } else {
      if (widget.subTitle != "") {
        heightCustom = 150;
      } else {
        heightCustom = widget.tipo == 3 ? 150 : 50;
      }
    }
    if (widget.textToCopy != "") {
      _controller.text = widget.textToCopy;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (a.isNotEmpty) {
      for (var i = 1; i < a.length; i++) {
        textRequerido.add(
          Text(
            "${a[i]}",
            style: textos(ctn: context, fSize: 16, fontWeight: FontWeight.w500),
          ),
        );
      }
    }

    return AlertDialog(
        insetPadding: EdgeInsets.only(top: 12, left: 12, right: 16, bottom: 0),
        backgroundColor: Colors.white, //Color.fromRGBO(255, 255, 255, 0.35),
        content: Container(
          width: widthheight(ctn: context, fSize: 350),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
              _tipo(widget.tipo, context),
              SizedBox(
                height: widthheight(ctn: context, fSize: 15),
              ),
              Center(
                child: Text(
                  widget.loadingTitle,
                  style: textos(ctn: context, fSize: widget.tipo == 1 ? 20 : 18, fontWeight: FontWeight.w500),
                ),
              ),
              widget.showBtn
                  ? Center(
                      child: Padding(padding: const EdgeInsets.only(top: 12, bottom: 0), child: Container()),
                    )
                  : Container(),
              widget.subTitle != ""
                  ? SizedBox(
                      height: widthheight(ctn: context, fSize: 5),
                    )
                  : Container(),
              a.isEmpty
                  ? widget.subTitle != ""
                      ? Center(
                          child: Text(
                            widget.subTitle,
                            style: textos(
                              ctn: context,
                              fSize: 14,
                            ),
                          ),
                        )
                      : Container()
                  : Column(
                      children: [
                        Text(
                          "${a[0].toUpperCase()}:",
                          style: textos(ctn: context, fSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Column(children: textRequerido),
                        // Stack(
                        //   // mainAxisSize: MainAxisSize.min,
                        //   // mainAxisAlignment: MainAxisAlignment.start,
                        //   // crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: textRequerido,
                        // )
                        //
                        //
                        //
                        //
                        widget.textToCopy != ""
                            ? TextField(
                                controller: _controller,
                              )
                            : Container()
                      ],
                    )
            ]),
          ),
        ));
  }

  Widget _tipo(int tipo, BuildContext ctn) {
    Widget element;
    if (tipo == 1) {
      element = Center(
          child: SizedBox(
        height: widthheight(ctn: ctn, fSize: 60),
        child: LoadingIndicator(
            indicatorType: Indicator.lineScalePulseOut,

            /// Required, The loading type of the widget
            colors: [
              Colors.red,
              Colors.blue,
              Colors.red,
              Colors.blue,
              Colors.red,
              Colors.blue,
            ],

            /// Optional, The color collections
            strokeWidth: 1,

            /// Optional, The stroke of the line, only applicable to widget which contains line
            backgroundColor: Colors.white,

            /// Optional, Background of the widget
            pathBackgroundColor: Colors.white

            /// Optional, the stroke backgroundColor
            ),
      ));
    } else if (tipo == 2) {
      element = Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: widthheight(ctn: ctn, fSize: 80),
              color: Colors.green.shade400,
            )
          ],
        ),
      );
    } else if (tipo == 4) {
      element = Center(
        child: Column(
          children: [
            Icon(
              Icons.alarm,
              color: Colors.orangeAccent,
            )
          ],
        ),
      );
    } else {
      element = Center(
          child: Container(
              width: widthheight(ctn: context, fSize: 80),
              height: widthheight(ctn: context, fSize: 80),
              child: Icon(
                Icons.error,
                size: widthheight(ctn: ctn, fSize: 80),
                color: Colors.yellow.shade700,
              )));
    }

    return element;
  }
}
