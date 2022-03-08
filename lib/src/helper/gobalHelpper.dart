import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:procredito/src/helper/cresponsive.dart';
import 'package:procredito/src/widgets/loading_alert_dialog.dart';
import 'package:procredito/src/widgets/txtG.dart';

class GlobalHelpper {
  String _mindatetime = '${DateTime.now().year - 100}-01-01';

  String _maxdatetime = '${DateTime.now().year + 16}-12-31';
  String _initdate = DateTime.now().toString();
  // String fORMATDATE = 'dd/MM/yyyy';

  DateTimePickerLocale _locale = DateTimePickerLocale.es;

  Future<bool> get isInDebugMode async {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  String convetirFechaSistema(String fecha) {
    if (fecha == null) {
      throw ArgumentError.notNull('string');
    }

    if (fecha.isEmpty) {
      return fecha;
    }
    // print(fecha);
    final sp = fecha.split("/");

    final formatoFecha = "${sp[2].toString()}-${sp[1].toString()}-${sp[0].toString()}";

    return formatoFecha;
  }

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError.notNull('string');
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  String cedulaFormat(String string) {
    String _string = "";
    if (string == null) {
      throw ArgumentError.notNull('string');
    }

    if (string.isEmpty) {
      return string;
    }

    if (string.length == 13 && string.contains("-")) {
      _string = string;
    }

    if (string.length == 11) {
      _string = string.substring(0, 2) + "-" + string.substring(3, 10) + "-" + string.substring(string.length, -1);
    }

    return _string;
  }

  Future<void> seleccionFecha({required BuildContext context, TextEditingController? txtController, int tipo = 0, String? fORMATDATE = "dd/MM/yyyy"}) async {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Listo', style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor)),
        cancel: Text('Cancelar', style: TextStyle(fontSize: 18, color: Colors.red)),
      ),
      minDateTime: tipo == 0 ? DateTime.parse(_mindatetime) : DateTime.parse(_mindatetime),
      maxDateTime: tipo == 0 ? DateTime.parse(_maxdatetime) : DateTime.parse(_initdate),
      initialDateTime: txtController!.text == "" ? DateTime.parse(_initdate) : DateTime.parse(this.convetirFechaSistema(txtController.text)),
      dateFormat: fORMATDATE,
      locale: _locale,
      onConfirm: (DateTime dateTime, List<int> i) {
        txtController.text = DateFormat(fORMATDATE).format(dateTime).toString();
      },
    );
  }

  Future<void> showValidation({required BuildContext ctn, String titulo = "Alerta", String msg = "", GlobalKey<ScaffoldState>? globalKey, int tipo = 0}) async {
    dynamic scaffold;
    if (tipo == 0) {
      scaffold = Scaffold.of(ctn);
    } else {
      scaffold = globalKey!.currentState;
    }
    Future.delayed(
        Duration.zero,
        () => scaffold.showSnackBar(new SnackBar(
              content: SingleChildScrollView(
                child: Container(
                  //color: Color565050,
                  //height: widthHeight(ctn: ctn, fSize: 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(titulo, style: textos(ctn: ctn, customcolor: Colors.white, fSize: 24)),
                      Divider(
                        height: widthheight(ctn: ctn, fSize: 25),
                        color: Colors.white,
                      ),
                      Text(msg,
                          style: textos(
                            ctn: ctn,
                            fSize: 16.0,
                            fontWeight: FontWeight.w400,
                            customcolor: Colors.white,
                            fontFamily: 'Inter',
                          )),
                    ],
                  ),
                ),
              ),
              // backgroundColor: color202832,
            )));
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  int daysBetween({required DateTime from, required DateTime to}) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Widget generarField({required BuildContext ctn, required dynamic elemento, TextEditingController? textEditingController, Function? selectData}) {
    Widget _elementos = SizedBox();

    switch (elemento.type) {
      case "STRING":
        _elementos = TxtG(
          controller: textEditingController,
          id: elemento.id,
          label: elemento.description,
          // onChangedText: (String s) => elemento.selectData(s),
        );

        break;
      case "NUMBER":
        _elementos = TxtG(
          id: elemento.id,
          label: elemento.description,
          textInputType: TextInputType.number,
          controller: textEditingController,
          // onChangedText: (String s) => elemento.selectData(s),
        );

        break;
      case "TEXT":
        _elementos = TxtG(
          id: elemento.id,
          lineOnText: 3,
          label: elemento.description,
          // textInputType: TextInputType.number,
          controller: textEditingController,
          // onChangedText: (String s) => elemento.selectData(s),
        );

        break;
      case "DATE":
        _elementos = InkWell(
          onTap: () async {
            await GlobalHelpper().seleccionFecha(context: ctn, txtController: textEditingController, tipo: 1);
            FocusScope.of(ctn).requestFocus(FocusNode());
          },
          child: TxtG(
            id: elemento.id,
            lineOnText: 1,
            label: elemento.description,
            isReadOnly: true,
            // textInputType: TextInputType.number,
            controller: textEditingController,
            // onChangedText: (String s) => elemento.selectData(s),
          ),
        );
        break;
      case "YEAR":
        _elementos = InkWell(
          onTap: () async {
            await GlobalHelpper().seleccionFecha(context: ctn, txtController: textEditingController, tipo: 1, fORMATDATE: "yyyy");
            FocusScope.of(ctn).requestFocus(FocusNode());
          },
          child: TxtG(
            id: elemento.id,
            lineOnText: 1,
            label: elemento.description,
            isReadOnly: true,
            // textInputType: TextInputType.number,
            controller: textEditingController,
            // onChangedText: (String s) => elemento.selectData(s),
          ),
        );
        break;
      case "TIME":
        _elementos = InkWell(
          onTap: () async {
            await GlobalHelpper().seleccionFecha(context: ctn, txtController: textEditingController, tipo: 1, fORMATDATE: "hh:mm");
            FocusScope.of(ctn).requestFocus(FocusNode());
          },
          child: TxtG(
            id: elemento.id,
            lineOnText: 1,
            label: elemento.description,
            isReadOnly: true,
            // textInputType: TextInputType.number,
            controller: textEditingController,
            // onChangedText: (String s) => elemento.selectData(s),
          ),
        );
        break;
      case "DATETIME":
        _elementos = InkWell(
          onTap: () async {
            await GlobalHelpper().seleccionFecha(context: ctn, txtController: textEditingController, tipo: 1, fORMATDATE: "dd/MM/yyy hh:mm");
            FocusScope.of(ctn).requestFocus(FocusNode());
          },
          child: TxtG(
            id: elemento.id,
            lineOnText: 1,
            label: elemento.description,
            isReadOnly: true,
            // textInputType: TextInputType.number,
            controller: textEditingController,
            // onChangedText: (String s) => elemento.selectData(s),
          ),
        );
        break;
      // case "LIST":
      //   List<DDLIpItems> _elementosLista = [];
      //   _elementosLista.addAll(elemento.values.split("|").asMap().map((key, value) => MapEntry(key, DDLIpItems(id: key.toString(), descripcion: value))).values.toList());

      //   _elementos = DDLIp(
      //       id: elemento.id,
      //       label: elemento.description,
      //       itemsList: _elementosLista,
      //       itemSelect: (DDLIpItems item) {
      //         selectData!(item.descripcion);
      //       });

      //   break;
      default:
    }
    return _elementos;
  }
}

class Alertas {
  final String titulo;
  final String? subtitulo;
  final String? textToCopy;
  final int tipo;
  final BuildContext ctn;
  final bool barrierDismissible;

  ///[tipo]
  ///muestra el header 1-Cargando 2-Completado 3- Error

  Alertas({required this.titulo, required this.ctn, this.subtitulo = "", this.tipo = 1, this.barrierDismissible = false, this.textToCopy = ""});

  void showAlert() {
    showDialog(
        context: ctn,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return LoadingAlertDialog(
            loadingTitle: titulo,
            subTitle: subtitulo!,
            tipo: tipo,
            textToCopy: textToCopy!,
          );
        });
  }

  void disspose() {
    Navigator.pop(ctn);
  }
}
