// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class CloudService {
//   static final FirebaseStorage _cloud = FirebaseStorage.instanceFor(
//     app: Firebase.app('MemoryBox'),
//   );
//   const CloudService._();
//   static const CloudService instance = CloudService._();

//   void init() {
//     // _cloud.
//   }

//   Future<void> uploadFile(String filePath) async {
//     File file = File(filePath);

//     try {
//       await _cloud.ref('colobok.aac').putFile(file);
//     } on FirebaseException catch (e) {
//       // e.g, e.code == 'canceled'
//       print(e);
//     }
//   }

//   void dispose() {}
// }
