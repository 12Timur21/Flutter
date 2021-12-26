import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/repositories/storage_service.dart';
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
    // final test =
    //     await StorageService.instance.getTaleMetadata(taleID: '312312');
    // print(test);
  }

  void getAudioModel() async {
    TaleModel taleModel = await DatabaseService.instance.getTaleModel(
      taleID: '13221321321321312',
    );
    print(taleModel);
  }

  void createTale() async {
    await DatabaseService.instance.createTale(
      duration: Duration(
        seconds: 1,
      ),
      taleID: Uuid().v4(),
      title: 'Sound title',
      taleUrl:
          'https://static.wikia.nocookie.net/memes9731/images/c/c5/S1200.jpg/revision/latest?cb=20200601181627&path-prefix=ru',
    );
  }

  void updateTaleTitle() async {
    await DatabaseService.instance.updateTaleData(
      taleID: '13221321321321312',
      isDeleted: true,
      title: 'xyz',
    );
  }

  void getTaleModel() async {
    TaleModel tm = await DatabaseService.instance.getTaleModel(
      taleID: '13221321321321312',
    );
    print(tm);
  }

  Future<void> getAllTalesModels() async {
    List<TaleModel> tm = await DatabaseService.instance.getAllTaleModels();
  }

  void changeDeletedStatus() async {}

  void removeTale() async {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.lightGreen,
        width: double.infinity,
        child: ListView(
          children: [
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
              onPressed: getAllTalesModels,
              child: Text(
                'get all tales models',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: createTale,
              child: Text(
                'create tale',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: updateTaleTitle,
              child: Text(
                'update tale title',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: changeDeletedStatus,
              child: Text(
                'change status on "deleted"',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: removeTale,
              child: Text(
                'remove tile',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getTaleModel,
              child: Text(
                'getTaleModel',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getAllTalesModels,
              child: Text(
                'getAllTaleModels',
                style: TextStyle(fontSize: 24),
              ),
            )
          ],
        ),
      ),
    );
  }
}
