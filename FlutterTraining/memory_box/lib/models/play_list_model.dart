import 'tale_model.dart';

class PlayListModel {
  String? coverUrl;
  String? title;
  String? ID;
  String? description;

  List<TaleModel>? soundCollection;

  PlayListModel({
    required this.ID,
    required this.coverUrl,
    this.description,
    this.soundCollection,
    required this.title,
  });
}
