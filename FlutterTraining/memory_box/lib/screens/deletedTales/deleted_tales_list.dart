import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/widgets/audio_tale_tile.dart';

class DeletedTalesList extends StatefulWidget {
  const DeletedTalesList({Key? key}) : super(key: key);

  @override
  _DeletedTalesListState createState() => _DeletedTalesListState();
}

class _DeletedTalesListState extends State<DeletedTalesList> {
  Map<DateTime, List<String>> deletedTalesList = {
    DateTime(2021, 12, 29): <String>['Tale id 1', 'tale id 2', 'tald id 3'],
    DateTime(2021, 12, 28): <String>[
      'Tale id 4',
      'tale id 5',
      'tald id 6',
      'tald id 7'
    ],
    DateTime(2021, 12, 27): <String>[
      'Tale id n',
      'tale id 2',
      'tald id 3',
    ],
    DateTime(2021, 12, 26): <String>[
      'Tale id 1',
      'tale id 2',
      'tald id 3',
    ],
    DateTime(2021, 12, 25): <String>[
      'Tale id 1',
      ' tale id 2',
      'tald id 3',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
      child: Container(),
      // FutureBuilder<List<TaleModel>>(
      //     future: DatabaseService.instance.getDeletedTales(),
      //     builder: (context, snapshot) {
      //       return ListView.builder(
      //         itemCount: deletedTalesList.length,
      //         itemBuilder: (context, index) {
      //           final deletedTaleDate = deletedTalesList.keys.elementAt(index);

      //           return Container(
      //             child: Column(
      //               children: [
      //                 Text(deletedTaleDate.toString()),
      //                 // TaleSelectionTile(
      //                 //   subscribeSound: _toogleSubscriptionTale,
      //                 //   taleModel: snapshot.data?[index],
      //                 //   isSelected: _taleModels?.contains(id) == true ? true : false,
      //                 // ),
      //                 Column(
      //                   children: deletedTalesList.values
      //                       .elementAt(index)
      //                       .map((item) => Text(item))
      //                       .toList(),
      //                 ),
      //               ],
      //             ),
      //           );
      //         },
      //       );
      //     }),
    );
  }
}
