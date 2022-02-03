import 'tale_model.dart';

class PlaylistModel {
  final String ID;
  final String title;
  final String? description;
  final String? coverURL;
  final List<String>? taleModels;

  PlaylistModel({
    required this.ID,
    required this.title,
    this.description,
    this.coverURL,
    this.taleModels,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      ID: json['ID'],
      title: json['title'],
      description: json['description'],
      coverURL: json['coverURL'],
      taleModels: json['taleModels'],
    );
  }
}
