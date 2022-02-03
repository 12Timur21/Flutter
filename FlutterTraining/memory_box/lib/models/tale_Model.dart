import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TaleDeleteStatus {
  bool isDeleted;
  DateTime? deleteDate;

  TaleDeleteStatus({
    required this.isDeleted,
    this.deleteDate,
  });
}

class TaleModel extends Equatable {
  final String? ID;
  final String? title;
  final String? url;
  final Duration? duration;
  final TaleDeleteStatus? deleteStatus;

  const TaleModel({
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

  @override
  List<Object?> get props => [ID, title, url, duration, deleteStatus];

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taleID': ID,
      'title': title,
      'durationInMS': duration?.inMilliseconds ?? Duration.zero,
      'isDeleted': {
        'status': deleteStatus?.isDeleted ?? false,
        'deleteDate': deleteStatus?.deleteDate,
      },
      'taleUrl': url,
      'searchKey': title?.toLowerCase(),
    };
  }
}
