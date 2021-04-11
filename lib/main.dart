import 'package:assets/provider/assetProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kotlin_flavor/scope_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting('ja');
  runApp(MyApp());
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
        title: Text(widget.title!),
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
