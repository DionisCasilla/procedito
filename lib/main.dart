import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:procredito/src/helper/gobalHelpper.dart';
import 'package:procredito/src/router/router.dart';
import 'package:signature/signature.dart';

void main() {
  Flurorouter.configureRouter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Procredito Envio de Contratos',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Flurorouter.router.generator,
      initialRoute: "/",
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, this.documento = ""}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String documento;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _email = TextEditingController();
  final _nombre = TextEditingController();
  final _cedula = TextEditingController();
  final _direccion = TextEditingController();
  final _ciudad = TextEditingController();
  final _tel1 = TextEditingController();
  final _tel2 = TextEditingController();
  bool isSwitched = false;

  var maskFormatterCedula = MaskTextInputFormatter(mask: '###-#######-#', filter: {"#": RegExp(r'[0-9]')});
  var maskFormatterTelefono = MaskTextInputFormatter(mask: '+1########## ', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    if (widget.documento != "" && widget.documento != "/") {
      _cedula.text = GlobalHelpper().cedulaFormat(widget.documento);
      WidgetsBinding.instance?.addPostFrameCallback((_) => buscadoCedula()
          //Future.delayed(Duration(seconds: 3), () => yourFunction());
          );
    }
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                  controller: _cedula,
                  decoration: InputDecoration(border: const UnderlineInputBorder(), labelText: 'Cedula', suffix: IconButton(onPressed: () => buscadoCedula(), icon: const Icon(Icons.search))),
                  inputFormatters: [maskFormatterCedula],
                  onSubmitted: (a) => buscadoCedula()),
              const SizedBox(
                height: 30,
              ),
              const Text("Metodo Envio Formulario"),
              Row(
                children: [
                  const Text("SMS"),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                  ),
                  const Text("EMAIL"),
                ],
              ),
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email Destino',
                ),
              ),
              TextField(
                controller: _nombre,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nombre',
                ),
              ),
              TextField(
                controller: _ciudad,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Ciudad',
                ),
              ),
              TextField(
                controller: _direccion,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Dirección',
                ),
              ),
              TextField(
                controller: _tel1,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Celular',
                ),
                inputFormatters: [maskFormatterTelefono],
              ),
              TextField(
                controller: _tel2,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Celular 2',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // Signature(
              //   controller: _controller,
              //   height: 300,
              //   backgroundColor: Colors.lightBlueAccent,
              // ),
              // Row(
              //   children: [
              //     IconButton(
              //       icon: const Icon(Icons.undo),
              //       color: Colors.blue,
              //       onPressed: () {
              //         setState(() => _controller.undo());
              //       },
              //     ),
              //     IconButton(
              //       icon: const Icon(Icons.redo),
              //       color: Colors.blue,
              //       onPressed: () {
              //         setState(() => _controller.redo());
              //       },
              //     ),
              //     //CLEAR CANVAS
              //     IconButton(
              //       icon: const Icon(Icons.clear),
              //       color: Colors.blue,
              //       onPressed: () {
              //         setState(() => _controller.clear());
              //       },
              //     ),
              //     IconButton(
              //       icon: const Icon(Icons.check),
              //       color: Colors.blue,
              //       onPressed: () async {
              //         if (_controller.isNotEmpty) {
              //           final Uint8List? data = await _controller.toPngBytes();
              //           if (data != null) {
              //             await Navigator.of(context).push(
              //               MaterialPageRoute<void>(
              //                 builder: (BuildContext context) {
              //                   return Scaffold(
              //                     appBar: AppBar(),
              //                     body: Center(
              //                       child: Container(
              //                         color: Colors.grey[300],
              //                         child: Image.memory(data),
              //                       ),
              //                     ),
              //                   );
              //                 },
              //               ),
              //             );
              //           }
              //         }
              //       },
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isSwitched) {
            if (_email.text == "") {
              final _alerta = Alertas(ctn: context, titulo: "Email es requerido", tipo: 3);
              _alerta.showAlert();
              await Future.delayed(const Duration(seconds: 3));
              _alerta.disspose();
              return;
            }
          } else {
            if (_tel1.text == "") {
              final _alerta = Alertas(ctn: context, titulo: "Celular es requerido", tipo: 3);
              _alerta.showAlert();
              await Future.delayed(const Duration(seconds: 3));
              _alerta.disspose();
              return;
            }
            // return;
          }

          final _alerta = Alertas(ctn: context, titulo: "Enviando Formulario");
          _alerta.showAlert();
          final _data = {
            "tipoenvio": !isSwitched ? 1 : 2,
            "emailDestino": _email.text,
            "infoCliente": {
              "nombre": _nombre.text,
              "cedula": _cedula.text,
              "direccion": _direccion.text,
              "celular": "+1" + _tel1.text.replaceAll("-", "").replaceAll('+1', ""),
              "ciudad": _ciudad.text,
              "celular2": _tel2.text,
              "dia": DateTime.now().day,
              "mes": DateTime.now().month,
              "ano": DateTime.now().year
            }
          };

          // print(jsonEncode(_data));

          final respuesta = await http.post(Uri.parse("https://itmsrdbackend.herokuapp.com/procredito/submitForm"),
              headers: {"Content-Type": "application/json; charset=utf-8", 'Accept': 'application/json'}, body: jsonEncode(_data));
          _alerta.disspose();
          final decodedata = json.decode(respuesta.body);
          if (decodedata["success"]) {
            setState(() {
              resetValues();
            });
            final _alerta = Alertas(ctn: context, titulo: "Formulario Enviado", tipo: 2);
            _alerta.showAlert();
            await Future.delayed(const Duration(seconds: 3));
            _alerta.disspose();
          } else {
            final _alerta = Alertas(ctn: context, titulo: decodedata["message"], tipo: 3);
            _alerta.showAlert();
            await Future.delayed(const Duration(seconds: 3));
            _alerta.disspose();
          }
          // print(decodedata);
        },
        tooltip: 'Enviar',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  buscadoCedula() async {
    final _alerta = Alertas(ctn: context, titulo: "Consultando...");
    _alerta.showAlert();
    final respuesta = await http.get(
      Uri.parse("https://itmsrdbackend.herokuapp.com/procredito/bcedula/${_cedula.text}"),
      headers: {"Content-Type": "application/json; charset=utf-8", 'Accept': 'application/json'},
    );
    final decodedata = json.decode(respuesta.body);
    // print(decodedata["success"]);
    _alerta.disspose();
    if (decodedata["success"]) {
      _nombre.text = decodedata["result"]["cliente"]["NOMBRE"];
      _direccion.text = decodedata["result"]["cliente"]["DIRECCION"];
      _tel1.text = decodedata["result"]["cliente"]["TELEFONO"].toString().replaceAll('+1', "");
      // _nombre.text = decodedata["result"]["cliente"]["NOMBRE"];
      // _nombre.text = decodedata["result"]["cliente"]["NOMBRE"];
      // _nombre.text = decodedata["result"]["cliente"]["NOMBRE"];
      // _nombre.text = decodedata["result"]["cliente"]["NOMBRE"];
    } else {
      final _alerta = Alertas(ctn: context, titulo: decodedata["message"], tipo: 3);
      _alerta.showAlert();
      await Future.delayed(const Duration(seconds: 3));
      _alerta.disspose();
    }
  }

  resetValues() {
    isSwitched = false;
    _nombre.text = "";
    _email.text = "";
    _cedula.text = "";
    _direccion.text = "";
    _ciudad.text = "";
    _tel1.text = "";
    _tel2.text = "";
  }
}
