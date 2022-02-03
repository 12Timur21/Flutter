import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/blocks/list_builder/list_builder_bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/storage_service.dart';
import 'package:memory_box/resources/app_coloros.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/screens/playlist_screen/select_tales_to_playlist_screen.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/list_builders/list_builder_with_popup.dart';
import 'package:memory_box/widgets/undoButton.dart';
import 'package:uuid/uuid.dart';

class CreatePlaylistScreen extends StatefulWidget {
  static const routeName = 'CreatePlaylistScreen';

  const CreatePlaylistScreen({Key? key}) : super(key: key);

  @override
  _CreatePlaylistScreenState createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isImageValid = false;

  List<TaleModel>? listTaleModels;
  String? _title;
  String? _description;
  File? _playlitst_cover;

  @override
  Widget build(BuildContext context) {
    String? _validatePlaylistTitleField(value) {
      if (value == null || value.isEmpty) {
        return 'Пожалуйста, введите название подборки';
      }

      return null;
    }

    bool validateImageField() {
      // setState(() {
      //   if (collectionState.photo != null) {
      //     isImageValid = true;
      //   } else {
      //     isImageValid = false;
      //   }
      // });
      // return isImageValid;
      return true;
    }

    void onTitleChanged(value) {
      _title = value;
      _formKey.currentState?.validate();
    }

    void onDescriptionChanged(value) {
      // _playlistModel..description = value;
    }

    void saveCollection() async {
      bool isTitleValidate = _formKey.currentState?.validate() ?? false;
      bool isPhotoValidate = validateImageField();
      if (isTitleValidate && isPhotoValidate) {
        String uuid = const Uuid().v4();

        String coverUrl = await StorageService.instance.uploadPlayListCover(
          file: _playlitst_cover!,
          coverID: uuid,
        );

        // await DatabaseService.instance.createPlaylist(
        //   playlistID: uuid,
        //   title: _title!,
        //   description: _description,
        //   talesIDs: collectionState.talesIDs,
        //   coverUrl: coverUrl,
        // );

        Navigator.of(context).pop();
      }
    }

    Future<void> _pickImage() async {
      XFile? pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      String? path = pickedImage?.path;
      if (path != null) {
        setState(() {
          isImageValid = true;
          _playlitst_cover = File(path);
        });
      }
    }

    void undoChanges() {
      Navigator.of(context).pop();
    }

    void addSongs() async {
      await Navigator.of(context).pushNamed(
        SelectTalesToPlaylistScreen.routeName,
        arguments: listTaleModels,
      );
    }

    TextButton _addSongButton = TextButton(
      onPressed: addSongs,
      child: const Text(
        'Добавить аудиофайл',
        style: TextStyle(
          // height: 2,
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
    );
    return BackgroundPattern(
      patternColor: AppColors.seaNymph,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
            left: 15,
            right: 15,
          ),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  style: const TextStyle(fontSize: 22),
                  validator: _validatePlaylistTitleField,
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
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.wildSand.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      border: isImageValid
                          ? null
                          : Border.all(
                              width: 2,
                              color: Colors.red,
                            ),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 4),
                          blurRadius: 20,
                          // spreadRadius: 1,
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: _playlitst_cover != null
                                ? Image.file(
                                    _playlitst_cover ?? File(''),
                                    fit: BoxFit.fitWidth,
                                  )
                                : Container(),
                          ),
                        ),
                        Center(
                          child: SvgPicture.asset(
                            AppIcons.chosePhoto,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  style: const TextStyle(fontSize: 22),
                  // initialValue: collectionState.description,
                  decoration: const InputDecoration(
                    hintText: 'Введите описание...',
                  ),
                  onChanged: onDescriptionChanged,
                  maxLines: 5,
                  minLines: 1,
                ),
                Row(
                  mainAxisAlignment: listTaleModels != null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    if (listTaleModels != null) _addSongButton,
                    TextButton(
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
                  ],
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // listTaleModels != null
                //     ? ListBuilderWithPopup(
                //         initListBuilderEvent:
                //             InitializeListBuilderWithTaleModels(
                //           listTaleModels!,
                //         ),
                //       )
                //     : Container(
                //         margin: const EdgeInsets.only(
                //           top: 50,
                //         ),
                //         child: Center(
                //           child: _addSongButton,
                //         ),
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
