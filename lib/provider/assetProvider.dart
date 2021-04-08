import 'package:assets/model/asset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AssetProvider with ChangeNotifier {
  List<Asset> assets = [];

  void fetch() async {
    CollectionReference query = FirebaseFirestore.instance.collection('assets');
    query.get().then((value) async {
      this.assets = value.docs.map((doc) => Asset(doc['asset'])).toList();
      print(this.assets);
      notifyListeners();
    });
  }
}
