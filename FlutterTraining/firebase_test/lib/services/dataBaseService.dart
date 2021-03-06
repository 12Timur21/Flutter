// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    // print(brewCollection.doc('tFXXFzRoCKSxuxZAFPJYnXVVuGv2').get());
    return await brewCollection
        .doc(uid)
        .set({'sugar': sugars, 'name': name, 'strength': strength});
  }

  Stream<QuerySnapshot> get brews {
    return brewCollection.snapshots();
  }
}
