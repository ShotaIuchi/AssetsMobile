import 'package:assets/model/asset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AssetProvider with ChangeNotifier {
  List<Asset> assets = [];

  void fetch() async {
    CollectionReference query = FirebaseFirestore.instance.collection('assets');
    query.get().then((value) async {
      this.assets = value.docs.map((doc) {
        print(doc.data());
        String asset = doc.data()['asset'];
        List<String> accessorise =
            List.castFrom<dynamic, String>(doc.data()['accessorise']);
        String control = doc.data()['control'];
        var deadlineTmp = doc.data()['deadline'];
        DateTime? deadline =
            deadlineTmp != null && ((deadlineTmp as String).length > 0)
                ? DateTime.parse(deadlineTmp)
                : null;
        String identification = doc.data()['identification'];
        String qr = doc.data()['qr'];
        int status = doc.data()['status'];
        DateTime? aram = doc.data()['aram']?.toDate();
        String user = doc.data()['user'];
        String owner = doc.data()['owner'];
        String ownerGroup = doc.data()['ownerGroup'];
        var c = Asset(
          asset,
          accessorise,
          control,
          deadline,
          identification,
          qr,
          status,
          aram,
          user,
          owner,
          ownerGroup,
        );
        return c;
      }).toList();
      print(this.assets);
      notifyListeners();
    });
  }
}
