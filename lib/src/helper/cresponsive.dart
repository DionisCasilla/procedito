import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

TextStyle textos({required BuildContext ctn, double fSize = 16, FontWeight fontWeight = FontWeight.normal, Color customcolor = Colors.black, String fontFamily = 'Poppins'}) {
  final itemSize = fSize / 375;
  return TextStyle(
    fontSize: kIsWeb ? fSize : MediaQuery.of(ctn).size.width * itemSize,
    fontWeight: fontWeight,
    color: customcolor,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
  );
}

/// [tipo] 1 si es para el width y 2 si es para el height .
/// [fSize] tamaño deseado .
double widthheight({required BuildContext ctn, required double fSize, int tipo = 1}) {
  final itemSize = fSize / ((tipo == 1) ? 375 : 812);
  final t = tipo == 1 ? MediaQuery.of(ctn).size.width : MediaQuery.of(ctn).size.height;
  return kIsWeb ? fSize : t * itemSize;
}
