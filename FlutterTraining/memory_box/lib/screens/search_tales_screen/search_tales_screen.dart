import 'package:flutter/material.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/widgets/appBar/appBar_multirow_title.dart';
import 'package:memory_box/widgets/appBar_withButtons.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/search.dart';
import 'package:memory_box/widgets/tale_list_tiles/tale_list_tile_with_popup_menu.dart';

class SearchTalesScreen extends StatefulWidget {
  static const routeName = 'SearchTalesScreen';

  const SearchTalesScreen({Key? key}) : super(key: key);

  @override
  _SearchTalesScreenState createState() => _SearchTalesScreenState();
}

class _SearchTalesScreenState extends State<SearchTalesScreen> {
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

  @override
  Widget build(BuildContext context) {
    print('main build');
    return BackgroundPattern(
      patternColor: const Color.fromRGBO(103, 139, 210, 1),
      isShort: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBarWithButtons(
          leadingOnPress: () {},
          actionsOnPress: () {},
          title: const AppBarMultirowTitle(
            title: 'Поиск',
            subtitile: 'Найди потеряшку',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
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
                              // return TaleListTileWithPopupMenu(
                              //   taleModel: taleModel,
                              // );
                            }
                            return const SizedBox();
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
