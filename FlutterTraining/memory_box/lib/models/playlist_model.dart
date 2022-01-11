import 'tale_model.dart';

class PlaylistModel {
  String? ID;
  String? title;
  String? description;
  String? coverUrl;
  Duration? duration;
  List<String>? taleIDsList;

  PlaylistModel({
    required this.ID,
    required this.title,
    this.description,
    required this.coverUrl,
    this.duration,
    this.taleIDsList,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    // print('1----');
    // print(json['taleIDsList'][0]);
    // print(
    //   PlaylistModel(
    //     coverUrl: json['coverUrl'],
    //     ID: json['ID'],
    //     description: json['description'],
    //     title: json['title'],
    //     // taleIDsList: json['taleIDsList'] as List<String>?,
    //     // duration: Duration(
    //     //   milliseconds: json['tilesSumDurationInMs'],
    //     // ),
    //   ),
    // );
    // print('2----');
    return PlaylistModel(
      coverUrl: json['coverUrl'],
      ID: json['ID'],
      description: json['description'],
      title: json['title'],
      // taleIDsList: json['taleIDsList'],
      duration: Duration(
        milliseconds: json['tilesSumDurationInMs'],
      ),
    );
  }
}
