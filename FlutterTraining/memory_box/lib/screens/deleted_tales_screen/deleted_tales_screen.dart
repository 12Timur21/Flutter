import 'package:flutter/material.dart';

class DeletedTalesScreen extends StatefulWidget {
  static const routeName = 'DeletedTalesScreen';

  const DeletedTalesScreen({Key? key}) : super(key: key);

  @override
  _DeletedTalesScreenState createState() => _DeletedTalesScreenState();
}

class _DeletedTalesScreenState extends State<DeletedTalesScreen> {
  Map<DateTime, List<String>> DeletedTalesScreen = {
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
      //     future: DatabaseService.instance.getDeletedTalesScreen(),
      //     builder: (context, snapshot) {
      //       return ListView.builder(
      //         itemCount: DeletedTalesScreen.length,
      //         itemBuilder: (context, index) {
      //           final deletedTaleDate = DeletedTalesScreenScreen.keys.elementAt(index);

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
      //                   children: DeletedTalesScreenScreen.values
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
