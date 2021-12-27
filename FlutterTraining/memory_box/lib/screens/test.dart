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
      playListID: const Uuid().v4(),
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
      taleID: const Uuid().v4(),
      title: '2132121',
      duration: const Duration(milliseconds: 35000),
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
      duration: const Duration(
        seconds: 1,
      ),
      taleID: const Uuid().v4(),
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

  void removeTale() async {}

  void getFilteredTales() async {
    List<TaleModel> lt = await DatabaseService.instance.getFilteringTales('f');
    print(lt);
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
              onPressed: createCollection,
              child: const Text(
                'Create collection',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: updateCollection,
              child: const Text(
                'Update collection',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: deleteCollection,
              child: const Text(
                'Delete collection',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: uploadCoverFile,
              child: const Text(
                'Upload play list cover file',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: deletePlayListCovereCover,
              child: const Text(
                'Delete play list cover file',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: uploadAudioFile,
              child: const Text(
                'Upload audio fIle',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: deleteAudioFile,
              child: const Text(
                'Delete audio file',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: addTalesToPlayList,
              child: const Text(
                'Add tales to play list',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getPlayList,
              child: const Text(
                'Get play list',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: removeTalesFromPlayList,
              child: const Text(
                'Remove tales from play list',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getTaleMetadata,
              child: const Text(
                'Get tale Metadata',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getAudioModel,
              child: const Text(
                'get audio model',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getAllTalesModels,
              child: const Text(
                'get all tales models',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: createTale,
              child: const Text(
                'create tale',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: updateTaleTitle,
              child: const Text(
                'update tale title',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: removeTale,
              child: const Text(
                'remove tile',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getTaleModel,
              child: const Text(
                'getTaleModel',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getAllTalesModels,
              child: const Text(
                'getAllTaleModels',
                style: TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: getFilteredTales,
              child: const Text(
                'get Filtered Tales',
                style: const TextStyle(fontSize: 24),
              ),
            )
          ],
        ),
      ),
    );
  }
}
