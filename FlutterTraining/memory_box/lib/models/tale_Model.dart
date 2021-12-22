import 'dart:io';

class TaleModel {
  String? ID;
  String? title;
  String? url;
  Duration? duration;

  TaleModel({
    this.ID,
    this.duration,
    this.title,
    this.url,
  });

  Map<String, String> toMap() {
    print(duration?.inMilliseconds.toString());
    return {
      'title': title ?? '',
      'id': ID ?? '',
      'duration': duration?.inMilliseconds.toString() ?? '',
    };
  }

  factory TaleModel.fromJson(Map<String, dynamic> json) {
    return TaleModel(
      title: json['title'],
      ID: json['id'],
      url: json['url'],
      duration: Duration(
        milliseconds: int.parse(json['duration']),
      ),
    );
  }
}
