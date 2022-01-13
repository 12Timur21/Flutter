import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/blocks/playListNavigation/playListNavigation_bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/repositories/storage_service.dart';
import 'package:memory_box/screens/playlist_screen/playlist_screen.dart';
import 'package:memory_box/screens/playlist_screen/select_playlist_tales.dart';
import 'package:memory_box/utils/navigationService.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/tale_list_tiles/tale_list_tile_with_popup_menu.dart';
import 'package:memory_box/widgets/undoButton.dart';
import 'package:uuid/uuid.dart';

class CreatePlaylistScreen extends StatefulWidget {
  static const routeName = 'CreatePlaylistScreen';

  const CreatePlaylistScreen({
    this.collectionCreationState,
    Key? key,
  }) : super(key: key);
  final PlayListCreationState? collectionCreationState;

  @override
  _CreatePlaylistScreenState createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isImageValid = true;

  late final PlayListCreationState collectionState;
  late DatabaseService _databaseService;

  @override
  void initState() {
    _databaseService = DatabaseService.instance;
    collectionState = widget.collectionCreationState ?? PlayListCreationState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? _validateCollectionTitleField(value) {
      if (value == null || value.isEmpty) {
        return 'Пожалуйста, введите название подборки';
      }

      return null;
    }

    bool validateImageField() {
      setState(() {
        if (collectionState.photo != null) {
          isImageValid = true;
        } else {
          isImageValid = false;
        }
      });
      return isImageValid;
    }

    void onTitleChanged(value) {
      collectionState.title = value;
      _formKey.currentState?.validate();
    }

    void onDescriptionChanged(value) {
      collectionState.description = value;
    }

    void saveCollection() async {
      bool isTitleValidate = _formKey.currentState?.validate() ?? false;
      bool isPhotoValidate = validateImageField();
      if (isTitleValidate && isPhotoValidate) {
        String uuid = const Uuid().v4();

        String coverUrl = await StorageService.instance.uploadPlayListCover(
          file: collectionState.photo!,
          coverID: uuid,
        );

        await _databaseService.createPlaylist(
          playListID: uuid,
          title: collectionState.title ?? '',
          description: collectionState.description,
          talesIDs: collectionState.talesIDs,
          coverUrl: coverUrl,
        );
      }

      // NavigationService.instance.navigateToPreviousPage();
    }

    Future<void> _pickImage() async {
      XFile? pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      String? path = pickedImage?.path;
      if (path != null) {
        setState(() {
          isImageValid = true;
          collectionState.photo = File(path);
        });
      }
    }

    void undoChanges() {
      Navigator.of(context).pop();
      // NavigationService.instance.navigateToPreviousPage();
    }

    void addSongs() {
      // NavigationService.instance.navigateTo(SelectPlaylistTales.routeName,
      //     arguments: collectionState, saveNewRoute: false);
    }

    return BackgroundPattern(
      patternColor: const Color.fromRGBO(113, 165, 159, 1),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          primary: true,
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: UndoButton(
            undoChanges: undoChanges,
          ),
          title: Container(
            margin: const EdgeInsets.only(top: 10),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Создание',
                style: TextStyle(
                  fontFamily: 'TTNorms',
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                right: 15,
              ),
              child: TextButton(
                onPressed: () {
                  saveCollection();
                },
                child: const Text(
                  'Готово',
                  style: TextStyle(
                    fontFamily: 'TTNorms',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
          elevation: 0,
        ),
        body: Container(
          margin: const EdgeInsets.only(
            top: 25,
            left: 15,
            right: 15,
          ),
          child: Form(
            key: _formKey,

            // SingleChildScrollView(
            // physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  style: const TextStyle(fontSize: 22),
                  initialValue: collectionState.title,
                  validator: _validateCollectionTitleField,
                  onChanged: onTitleChanged,
                  decoration: const InputDecoration(
                    hintText: 'Название...',
                    hintStyle: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(246, 246, 246, 0.9),
                      borderRadius: BorderRadius.circular(15),
                      border: isImageValid
                          ? null
                          : Border.all(
                              width: 2,
                              color: Colors.red,
                            ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 20,
                          // spreadRadius: 1,
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: collectionState.photo != null
                                ? Image.file(
                                    collectionState.photo ?? File(''),
                                    fit: BoxFit.fitWidth,
                                  )
                                : Container(),
                          ),
                        ),
                        Center(
                          child: SvgPicture.asset(
                            'assets/icons/ChosePhoto.svg',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  style: const TextStyle(fontSize: 22),
                  initialValue: collectionState.description,
                  decoration: const InputDecoration(
                    hintText: 'Введите описание...',
                  ),
                  onChanged: onDescriptionChanged,
                  maxLines: 5,
                  minLines: 1,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Готово',
                      style: TextStyle(
                        fontFamily: 'TTNorms',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      FutureBuilder(
                        future: DatabaseService.instance.getFewTaleModels(
                          taleIDs: widget.collectionCreationState?.talesIDs,
                        ),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<List<TaleModel>?> snapshot,
                        ) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return ListView.builder(
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                TaleModel? taleModel = snapshot.data?[index];
                                if (taleModel != null) {
                                  return TaleListTileWithPopupMenu(
                                    taleModel: taleModel,
                                  );
                                }
                                return const SizedBox();
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(246, 246, 246, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                spreadRadius: 1,
                                // offset: Offset(0, -1),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: addSongs,
                            child: const Text(
                              'Добавить аудиофайл',
                              style: TextStyle(
                                height: 2,
                                fontFamily: 'TTNorms',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.transparent,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.black,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(0, -5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
