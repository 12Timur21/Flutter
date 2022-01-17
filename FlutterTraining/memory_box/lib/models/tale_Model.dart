import 'package:cloud_firestore/cloud_firestore.dart';

class TaleDeleteStatus {
  bool isDeleted;
  DateTime? deleteDate;

  TaleDeleteStatus({
    required this.isDeleted,
    this.deleteDate,
  });
}

class TaleModel {
  String? ID;
  String? title;
  String? url;
  Duration? duration;
  TaleDeleteStatus? deleteStatus;

  TaleModel({
    this.ID,
    this.duration,
    this.title,
    this.url,
    this.deleteStatus,
  });

  TaleModel copyWith({
    String? ID,
    String? title,
    String? url,
    Duration? duration,
    TaleDeleteStatus? deleteStatus,
  }) {
    return TaleModel(
      ID: ID ?? this.ID,
      title: title ?? this.title,
      url: url ?? this.url,
      duration: duration ?? this.duration,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }

  //!
  // Map<String, dynamic> toMap() {
  //   return {
  //     'title': title ?? '',
  //     'id': ID ?? 0,
  //     'duration': duration ?? Duration.zero,
  //     'isDeleted': ,
  //   };
  // }

  // factory TaleModel.toList(QuerySnapshot<Map<String, dynamic>> snapshot) {
  //   TaleModel? tm;

  //   snapshot.docs.forEach((doc) {
  //     Map<String, dynamic> json = doc.data();

  //     tm = TaleModel.fromJson(json[0]);
  //   });

  //   return tm;
  // }

  factory TaleModel.fromJson(Map<String, dynamic> json) {
    Timestamp? timeStamp = (json['isDeleted']['deleteDate'] as Timestamp?);

    return TaleModel(
      title: json['title'],
      ID: json['taleID'],
      url: json['taleUrl'],
      duration: Duration(
        milliseconds: json['durationInMS'],
      ),
      deleteStatus: TaleDeleteStatus(
        isDeleted: json['isDeleted']['status'],
        deleteDate: DateTime.fromMicrosecondsSinceEpoch(
          timeStamp?.microsecondsSinceEpoch ?? 0,
        ),
      ),
    );
  }

  // factory TaleModel.fromQueryDocumentSnapshot(
  //     QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
  //   return TaleModel(
  //     ID: snapshot['taleID'],
  //     title: snapshot['title'],
  //     url: snapshot['taleUrl'],
  //     isDeleted: {
  //       status: snapshot['isDeleted'],
  //     },
  //     duration: Duration(
  //       milliseconds: snapshot['durationInMS'],
  //     ),
  //   );
  // }
}
