import 'tale_model.dart';

class PlaylistModel {
  String? ID;
  String? title;
  String? description;
  String? coverUrl;
  Duration? duration;
  List<String>? tilesIDSList;

  PlaylistModel({
    required this.ID,
    required this.title,
    this.description,
    required this.coverUrl,
    this.duration,
    this.tilesIDSList,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      coverUrl: json['coverUrl'],
      ID: json['ID'],
      title: json['title'],
      tilesIDSList: json['tilesIDSList'],
      duration: Duration(
        milliseconds: json['tilesSumDurationInMs'],
      ),
    );
  }
}
