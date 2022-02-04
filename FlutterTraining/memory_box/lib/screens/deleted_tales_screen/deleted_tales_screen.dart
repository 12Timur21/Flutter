import 'package:flutter/material.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/utils/formatting.dart';
import 'package:memory_box/widgets/appBar/appBar_multirow_title.dart';
import 'package:memory_box/widgets/appBar_withButtons.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/tale_list_tiles/tale_list_tile_with_deleteButton.dart';
import 'package:memory_box/widgets/tale_list_tiles/tale_list_tile_with_popup_menu.dart';

class DeletedTalesScreen extends StatefulWidget {
  static const routeName = 'DeletedTalesScreen';

  const DeletedTalesScreen({Key? key}) : super(key: key);

  @override
  _DeletedTalesScreenState createState() => _DeletedTalesScreenState();
}

class _DeletedTalesScreenState extends State<DeletedTalesScreen> {
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
          toolbarHeight: 95,
          title: const AppBarMultirowTitle(
            title: 'Недавно \n удаленные',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 110,
              ),
              // Expanded(
              //   child: FutureBuilder<List<TaleModel>>(
              //     future: DatabaseService.instance.getAllDeletedTaleModels(),
              //     builder: (
              //       BuildContext context,
              //       AsyncSnapshot<List<TaleModel>> snapshot,
              //     ) {
              //       if (snapshot.connectionState == ConnectionState.done) {
              //         Map<String, List<TaleModel>> talesByDate = {};
              //         snapshot.data?.forEach((element) {
              //           String date = convertDateTimeToString(
              //             date: element.deleteStatus?.deleteDate,
              //             dayTimeFormattingType:
              //                 DayTimeFormattingType.dayMonthYear,
              //           );

              //           if (talesByDate[date] != null) {
              //             talesByDate[date]?.add(element);
              //           } else {
              //             talesByDate[date] = [element];
              //           }
              //         });

              //         return ListView.builder(
              //           itemCount: talesByDate.length,
              //           itemBuilder: (context, index) {
              //             String key = talesByDate.keys.elementAt(index);
              //             List<Widget> customColumn = [
              //               Padding(
              //                 padding: const EdgeInsets.symmetric(
              //                   vertical: 15,
              //                 ),
              //                 child: Text(
              //                   key,
              //                   style: const TextStyle(
              //                     color: Color.fromRGBO(58, 58, 85, 0.5),
              //                     fontWeight: FontWeight.w500,
              //                     fontSize: 14,
              //                   ),
              //                 ),
              //               )
              //             ];

              //             talesByDate[key]?.forEach((TaleModel taleModel) {
              //               customColumn.add(TaleListTileWithDeleteButton(
              //                 taleModel: taleModel,
              //               ));
              //             });

              //             return Column(children: customColumn);
              //           },
              //         );
              //       }
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
