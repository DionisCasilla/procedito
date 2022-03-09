import 'dart:js';

import 'package:fluro/fluro.dart';
import 'package:procredito/main.dart';

class Flurorouter {
  static final FluroRouter router = new FluroRouter();

  static void configureRouter() {
    router.define("/:cedula", handler: _cedulaHander);
  }

  static final Handler _cedulaHander = Handler(handlerFunc: (ctx, params) {
    print(params['cedula']);
    final cedula = params['cedula']?[0] ?? "";
    final nombre = params['nombre']?[0] ?? "";

    return MyHomePage(
      title: 'Procredito Envio de Contratos',
      documento: cedula,
    );
  });
}
