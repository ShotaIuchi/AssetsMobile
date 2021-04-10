import 'package:assets/provider/assetProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

class AssetList extends StatelessWidget {
  final int index;
  AssetList({Key? key, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final asset = Provider.of<AssetProvider>(context).assets[this.index];
    //Text(Provider.of<AssetProvider>(context).assets[this.index].asset);
    return ListTile(
      title: Text(asset.asset),
      subtitle: Text(asset.qr),
    );
  }
}
