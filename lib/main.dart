import 'dart:io';

import 'package:assets/provider/assetProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kotlin_flavor/scope_functions.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting('ja');
  //runApp(MyApp());
  runApp(MaterialApp(
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => MyApp(),
      '/qr': (BuildContext context) => AssetQR(),
    },
  ));
}

class AssetQR extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<AssetQR> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  Widget build(BuildContext context) {
    return _buildQrView(context);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AssetProvider>(
        create: (context) => AssetProvider(),
        child: MaterialApp(
          title: 'Assets',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Assets'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<AssetProvider>(context, listen: false).fetch();
  }

  void _incrementCounter() async {
    Provider.of<AssetProvider>(context, listen: false).fetch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.title!),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Image.asset("images/logo.png"),
              //child: Text('アセッツ')
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('一覧'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('棚卸し'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('設定'),
            ),
          ],
        ),
      ),
      body: Center(
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return AssetList(
                  index: index,
                );
              },
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.black),
              itemCount: Provider.of<AssetProvider>(context).assets.length)),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

Text switchWidget(String def, String? target) {
  return target == null || target.isEmpty ? Text(def) : Text(target);
}

class AssetList extends StatelessWidget {
  final int index;
  AssetList({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final asset = Provider.of<AssetProvider>(context).assets[this.index];
    return ListTile(
        trailing: Icon(Icons.more_vert),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ListTile(
                  title: Text(asset.asset),
                  subtitle: ListTile(
                      title: asset.user.isEmpty
                          ? Text("| 未使用")
                          : Text("| " + asset.user),
                      subtitle: asset.accessorise.isEmpty
                          ? Text("| 付属品なし")
                          : Text("| " +
                              (asset.accessorise.toString()).let((self) =>
                                  self.substring(1, self.length - 1))))),
            ),
            Expanded(
                child: Table(
              //border: TableBorder.all(),
              columnWidths: const <int, TableColumnWidth>{
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("期限"),
                    ),
                    Center(
                        child: asset.deadline == null
                            ? Text("期限未設定")
                            : Text(DateFormat('yy/MM/dd')
                                .format(asset.deadline!))),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("管理"),
                    ),
                    Center(
                      child: asset.control.isEmpty
                          ? Text("-")
                          : Text(asset.control),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("識別"),
                    ),
                    Center(
                      child: asset.identification.isEmpty
                          ? Text("-")
                          : Text(asset.identification),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("QR"),
                    ),
                    Center(
                      child: asset.qr.isEmpty ? Text("-") : Text(asset.qr),
                    ),
                  ],
                ),
              ],
            )),
          ],
        ));
  }
}
