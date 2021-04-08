import 'package:assets/provider/assetProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
  int _counter = 0;

  void _incrementCounter() async {
    Provider.of<AssetProvider>(context, listen: false).fetch();
    setState(() {
      _counter++;
    });
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
    return Text(Provider.of<AssetProvider>(context).assets[this.index].asset);
  }
}
