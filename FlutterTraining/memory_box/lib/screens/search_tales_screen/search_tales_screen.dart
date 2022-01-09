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
  String? _searchTitle;

  @override
  Widget build(BuildContext context) {
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
                onChange: (value) {
                  if (value.endsWith(' ')) return;
                  setState(() {
                    _searchTitle = value;
                  });
                },
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: FutureBuilder<List<TaleModel>>(
                  future: DatabaseService.instance
                      .searchTalesByTitle(title: _searchTitle),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List<TaleModel>> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.done) {
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
                    }
                    return const CircularProgressIndicator();
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
