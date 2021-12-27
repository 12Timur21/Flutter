class TaleModel {
  String? ID;
  String? title;
  String? url;
  Duration? duration;
  bool? isDeleted = false;

  TaleModel({
    this.ID,
    this.duration,
    this.title,
    this.url,
    this.isDeleted,
  });

  Map<String, dynamic> toMap() {
    print(duration?.inMilliseconds.toString());
    return {
      'title': title ?? '',
      'id': ID ?? 0,
      'duration': duration ?? Duration.zero,
      'isDeleted': isDeleted ?? false,
    };
  }

  factory TaleModel.fromJson(Map<String, dynamic> json) {
    return TaleModel(
      title: json['title'],
      ID: json['id'],
      url: json['url'],
      duration: Duration(
        milliseconds: json['duration'],
      ),
      isDeleted: json['isDeleted'],
    );
  }
}
