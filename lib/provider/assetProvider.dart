import 'package:assets/model/asset.dart';
import 'package:flutter/material.dart';

class AssetProvider with ChangeNotifier {
  List<Asset> assets = [Asset("first")];

  void fetch() {
    this.assets.add(Asset(DateTime.now().toString()));
    notifyListeners();
  }
}
