import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocks/playListNavigation/playListNavigation_bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/screens/playlist_screen/create_playlist_screen.dart';
import 'package:memory_box/utils/navigationService.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/search.dart';
import 'package:memory_box/widgets/tale_list_tiles/tale_list_tile_with_checkbox.dart';
import 'package:memory_box/widgets/undoButton.dart';

class SelectPlaylistTales extends StatefulWidget {
  static const routeName = 'SelectPlaylistTales';

  const SelectPlaylistTales({
    this.collectionCreationState,
    Key? key,
  }) : super(key: key);

  final PlayListCreationState? collectionCreationState;
  @override
  _SelectPlaylistTalesState createState() => _SelectPlaylistTalesState();
}

class _SelectPlaylistTalesState extends State<SelectPlaylistTales> {
  late final PlayListCreationState? _playListState;
  final StreamController<String?> _toogleSubscriptionTale =
      StreamController<String>();
  List<String>? _taleModels;

  //!
  String? _searchValue;
  bool _searchHasFocus = false;
  final TextEditingController _searchFieldContoller = TextEditingController();

  void _onSearchFocusChange(bool hasFocus) {
    setState(() {
      _searchHasFocus = hasFocus;
    });
  }

  void _onSearchValueChange(String value) {
    if (value.endsWith(' ')) return;
    setState(() {
      _searchValue = value;
    });
  }

  void _onSearchValueSelected(String value) {
    setState(() {
      _searchHasFocus = false;

      _searchValue = value;

      _searchFieldContoller.text = _searchValue ?? '';

      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  //!

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
      NavigationService.instance.navigateTo(
        CreatePlaylistScreen.routeName,
        widget.collectionCreationState,
      );
    }

    void _saveChanges() {
      _playListState?.talesIDs = _taleModels;

      NavigationService.instance.navigateTo(
        CreatePlaylistScreen.routeName,
        _playListState,
      );
    }

    void subscibeTale(String taleID) {
      _taleModels?.add(taleID);
    }

    void unSubscribeTale(String taleID) {
      _taleModels?.remove(taleID);
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
              Search(
                searchFieldContoller: _searchFieldContoller,
                onChange: _onSearchValueChange,
                onFocusChange: _onSearchFocusChange,
              ),
              _searchHasFocus
                  ? const SizedBox(
                      height: 15,
                    )
                  : const SizedBox(
                      height: 50,
                    ),
              Expanded(
                child: FutureBuilder<List<TaleModel>>(
                  future: DatabaseService.instance
                      .searchTalesByTitle(title: _searchValue),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List<TaleModel>> snapshot,
                  ) {
                    print('future builder');
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (_searchHasFocus && snapshot.data?.length != 0) {
                        return Container(
                          height: 210,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 40,
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(246, 246, 246, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 20,
                                color: Color.fromRGBO(0, 0, 0, 0.18),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              print('list view builder');
                              TaleModel? taleModel = snapshot.data?[index];
                              if (taleModel != null) {
                                return GestureDetector(
                                  onTap: () {
                                    _onSearchValueSelected(
                                      snapshot.data?[index].title ?? '',
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: index == 0 ? 0 : 25,
                                    ),
                                    child: Text(
                                      taleModel.title ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'TTNorms',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            TaleModel? taleModel = snapshot.data?[index];
                            if (taleModel != null) {
                              bool isSelected = false;
                              if (_taleModels?.contains(taleModel.ID) ??
                                  false) {
                                isSelected = true;
                              }
                              return TaleListTileWithCheckBox(
                                taleModel: taleModel,
                                isSelected: isSelected,
                                subscribeTale: subscibeTale,
                                unSubscribeTale: unSubscribeTale,
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
