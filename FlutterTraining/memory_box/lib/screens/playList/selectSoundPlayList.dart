import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/playListNavigation/playListNavigation_bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/search.dart';
import 'package:memory_box/widgets/audio_tale_tile.dart';
import 'package:memory_box/widgets/undoButton.dart';

class SelectSoundPlayList extends StatefulWidget {
  const SelectSoundPlayList({
    this.collectionCreationState,
    Key? key,
  }) : super(key: key);

  final PlayListCreationState? collectionCreationState;
  @override
  _SelectSoundPlayListState createState() => _SelectSoundPlayListState();
}

class _SelectSoundPlayListState extends State<SelectSoundPlayList> {
  late final PlayListCreationState? _playListState;
  final StreamController<String?> _toogleSubscriptionTale =
      StreamController<String>();
  List<String>? _taleModels;

  @override
  void initState() {
    _playListState = widget.collectionCreationState;
    _taleModels = _playListState?.talesIDs ?? [];

    _toogleSubscriptionTale.stream.listen((String? event) {
      String? taleID = event;
      bool isTaleInList = false;

      print(taleID);
      if (taleID != null && _taleModels != null) {
        for (String savedTaleID in _taleModels!) {
          print('$taleID - $savedTaleID');
          if (taleID == savedTaleID) {
            isTaleInList = true;
          }
        }

        if (isTaleInList) {
          _taleModels?.remove(taleID);
        } else {
          _taleModels?.add(taleID);
        }
        print(_taleModels);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _toogleSubscriptionTale.close();
    super.dispose();
  }

  // Future<List<TaleModel>> futureLoaderTales =
  //     DatabaseService.instance.getAllTaleModels();

  @override
  Widget build(BuildContext context) {
    void _undoChanges() {
      final navigationBloc = BlocProvider.of<PlayListNavigationBloc>(context);
      navigationBloc.add(
        OpenPlayListCreationScreen(
          playListCreationState: widget.collectionCreationState,
        ),
      );
    }

    void _saveChanges() {
      final navigationBloc = BlocProvider.of<PlayListNavigationBloc>(context);

      _playListState?.talesIDs = _taleModels;
      navigationBloc.add(
        OpenPlayListCreationScreen(
          playListCreationState: _playListState,
        ),
      );
    }

    // void search(String value) async {
    //   futureLoaderTales = DatabaseService.instance.searchTalesByTitle(value);
    //   final q = await futureLoaderTales;
    //   q.forEach((element) {
    //     print(element.title);
    //   });
    //   setState(() {});
    // }

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
          leading: Container(
              child: UndoButton(
            undoChanges: _undoChanges,
          )),
          title: Container(
            margin: const EdgeInsets.only(top: 10),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Выбрать',
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
                onPressed: _saveChanges,
                child: const Text(
                  'Добавить',
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
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              // Search(
              //   onChange: search,
              // ),
              const SizedBox(
                height: 45,
              ),
              Expanded(
                child: Column(
                  children: [
                    AudioTaleTile(
                      // subscribeSound: _toogleSubscriptionTale,
                      taleModel: TaleModel(ID: '22222'),
                      actions: Builder(
                        builder: (context) {
                          bool isSelected3 = false;
                          return StatefulBuilder(
                            builder: (context, setState2) {
                              return IconButton(
                                onPressed: () {
                                  setState2(() {
                                    isSelected3 = !isSelected3;
                                  });
                                },
                                icon: isSelected3
                                    ? SvgPicture.asset(
                                        'assets/icons/SubmitCircle.svg',
                                      )
                                    : SvgPicture.asset(
                                        'assets/icons/Circle.svg',
                                      ),
                              );
                            },
                          );
                        },
                      ),
                      // isSelected: _taleModels?.contains(id) == true ? true : false,
                    ),
                    AudioTaleTile(
                      // subscribeSound: _toogleSubscriptionTale,
                      taleModel: TaleModel(ID: '22222'),
                      actions: Builder(
                        builder: (context) {
                          bool isSelected3 = false;
                          return StatefulBuilder(
                            builder: (context, setState2) {
                              return IconButton(
                                onPressed: () {
                                  setState2(() {
                                    isSelected3 = !isSelected3;
                                  });
                                },
                                icon: isSelected3
                                    ? SvgPicture.asset(
                                        'assets/icons/SubmitCircle.svg',
                                      )
                                    : SvgPicture.asset(
                                        'assets/icons/Circle.svg',
                                      ),
                              );
                            },
                          );
                        },
                      ),
                      // isSelected: _taleModels?.contains(id) == true ? true : false,
                    ),
                  ],
                ),
                // FutureBuilder(
                //   future: futureLoaderTales,
                //   builder: (
                //     BuildContext context,
                //     AsyncSnapshot<List<TaleModel>> snapshot,
                //   ) {
                //     // print('------');
                //     // snapshot.data?.forEach((element) {
                //     //   print(element.title);
                //     // });
                //     if (snapshot.connectionState == ConnectionState.done) {
                //       return ListView.builder(
                //         itemCount: snapshot.data?.length ?? 0,
                //         itemBuilder: (context, index) {
                //           String id = snapshot.data?[index].ID ?? '';

                //           return TaleSelectionTile(
                //             subscribeSound: _toogleSubscriptionTale,
                //             taleModel: snapshot.data?[index],
                //             isSelected: _taleModels?.contains(id) == true
                //                 ? true
                //                 : false,
                //           );
                //         },
                //       );
                //     } else {
                //       return const Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }
                //   },
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
