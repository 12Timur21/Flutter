import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memory_box/models/taleModel.dart';
import 'package:memory_box/repositories/databaseService.dart';
import 'package:memory_box/repositories/storageService.dart';
import 'package:uuid/uuid.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  late StorageService storageService;
  @override
  void initState() {
    storageService = StorageService.instance;
    super.initState();
  }

  void getFile() {
    storageService.uploadFile(
      file: File(''),
      fileType: FileType.tale,
      fileName: '',
    );
  }

  void createCollection() {
    DatabaseService.instance.createPlayList(
      playListID: Uuid().v4(),
      title: 'Colec',
      description: 'dsadsadsasa',
    );
  }

  void updateCollection() {
    DatabaseService.instance.updatePlayList(
      playListID: 'fa98a41c-63ed-455e-a7b7-8c3d4bbce27d',
      title: 'rdd23232132',
      // description: 'ccccccccccccccc',
    );
  }

  void deleteCollection() {
    DatabaseService.instance.deletePlayList(
      playListID: '',
    );
  }

  void uploadCoverFile() {
    StorageService.instance.uploadPlayListCover(
      file: File('sdcard/download/test2.aac'),
      coverID: 'coverID',
    );
  }

  void deletePlayListCovereCover() {
    StorageService.instance.deletePlayListCover(
      coverID: 'coverID',
    );
  }

  void uploadAudioFile() {
    StorageService.instance.uploadTaleFIle(
      file: File('sdcard/download/test2.aac'),
      taleID: Uuid().v4(),
      title: '2132121',
      duration: Duration(milliseconds: 35000),
    );
  }

  void deleteAudioFile() {
    StorageService.instance.deleteTale(
      taleID: '312312',
    );
  }

  void addTalesToPlayList() {
    DatabaseService.instance.addTalesToPlayList(
      playListID: 'da361902-8cbc-4ccf-8efa-4fa407bde2fa',
      talesIDs: ['dsasa', 'dsssd'],
    );
  }

  void getPlayList() async {
    final test = await DatabaseService.instance
        .getPlayList(playListID: 'da361902-8cbc-4ccf-8efa-4fa407bde2fa');
    print(test);
  }

  void removeTalesFromPlayList() {
    DatabaseService.instance.removeTalesFromPlayList(
      playListID: 'da361902-8cbc-4ccf-8efa-4fa407bde2fa',
      talesIDs: ['dsasa', 'dsssd'],
    );
  }

  void getTaleMetadata() async {
    final test =
        await StorageService.instance.getTaleMetadata(taleID: '312312');
    print(test);
  }

  void getAudioModel() async {
    TaleModel? taleModel = await StorageService.instance.getTaleModel(
      taleID: '312312',
    );
  }

  void getAllTaleModels() async {
    await StorageService.instance.getAllTaleModels();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.lightGreen,
        width: double.infinity,
        child: ListView(
          children: [
            TextButton(
              onPressed: getFile,
              child: Text(
                'GetFile',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: createCollection,
              child: Text(
                'Create collection',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: updateCollection,
              child: Text(
                'Update collection',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: deleteCollection,
              child: Text(
                'Delete collection',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: uploadCoverFile,
              child: Text(
                'Upload play list cover file',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: deletePlayListCovereCover,
              child: Text(
                'Delete play list cover file',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: uploadAudioFile,
              child: Text(
                'Upload audio fIle',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: deleteAudioFile,
              child: Text(
                'Delete audio file',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: addTalesToPlayList,
              child: Text(
                'Add tales to play list',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getPlayList,
              child: Text(
                'Get play list',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: removeTalesFromPlayList,
              child: Text(
                'Remove tales from play list',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getTaleMetadata,
              child: Text(
                'Get tale Metadata',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getAudioModel,
              child: Text(
                'get audio model',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getAllTaleModels,
              child: Text(
                'get all tales models',
                style: TextStyle(fontSize: 24),
              ),
            )
          ],
        ),
      ),
    );
  }
}
