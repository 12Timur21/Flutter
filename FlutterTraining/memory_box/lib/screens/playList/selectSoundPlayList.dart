import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/playListNavigation/playListNavigation_bloc.dart';
import 'package:memory_box/models/taleModel.dart';
import 'package:memory_box/repositories/databaseService.dart';
import 'package:memory_box/repositories/storageService.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/search.dart';
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
  StreamController<String?> _subscribeSound = StreamController<String>();
  List<String>? _taleModels;

  @override
  void initState() {
    _playListState = widget.collectionCreationState;
    _taleModels = _playListState?.talesIDs ?? [];

    _subscribeSound.stream.listen((String? event) {
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
    _subscribeSound.close();
    super.dispose();
  }

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

    return BackgroundPattern(
      patternColor: Color.fromRGBO(113, 165, 159, 1),
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
              const Search(),
              const SizedBox(
                height: 45,
              ),
              Expanded(
                child: FutureBuilder(
                    future: StorageService.instance.getAllTaleModels(),
                    builder: (
                      context,
                      AsyncSnapshot<List<TaleModel?>> snapshot,
                    ) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return AudioSelectionTile(
                            subscribeSound: _subscribeSound,
                            taleModel: snapshot.data?[index],
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioSelectionTile extends StatefulWidget {
  const AudioSelectionTile({
    required this.subscribeSound,
    this.taleModel,
    Key? key,
  }) : super(key: key);
  final StreamController<String?> subscribeSound;
  final TaleModel? taleModel;
  @override
  _AudioSelectionTileState createState() => _AudioSelectionTileState();
}

class _AudioSelectionTileState extends State<AudioSelectionTile> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    void selectSound() {
      setState(() {
        widget.subscribeSound.add(widget.taleModel?.ID);
        isSelected = !isSelected;
      });
    }

    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(41)),
        border: Border.all(
          color: Color.fromRGBO(58, 58, 85, 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/Play.svg',
            color: Color.fromRGBO(113, 165, 159, 1),
            width: 60,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.taleModel?.title ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'TTNorms',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.taleModel?.duration?.inMinutes != 0
                      ? '${widget.taleModel?.duration?.inMinutes} минут'
                      : '${widget.taleModel?.duration?.inSeconds} секунд',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'TTNorms',
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(58, 58, 85, 0.5),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 60,
            height: 60,
            child: IconButton(
              onPressed: selectSound,
              icon: isSelected
                  ? SvgPicture.asset(
                      'assets/icons/SubmitCircle.svg',
                    )
                  : SvgPicture.asset(
                      'assets/icons/Circle.svg',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
