import 'package:flutter/material.dart';
import 'package:memory_box/models/playlist_model.dart';

class PreviewPlaylistScreen extends StatefulWidget {
  const PreviewPlaylistScreen({
    required this.playlistModel,
    Key? key,
  }) : super(key: key);

  final PlaylistModel playlistModel;

  @override
  _PreviewPlaylistScreenState createState() => _PreviewPlaylistScreenState();
}

class _PreviewPlaylistScreenState extends State<PreviewPlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: ,
        );
  }
}
