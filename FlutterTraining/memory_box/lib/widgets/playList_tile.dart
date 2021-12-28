// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class PlayListTile extends StatefulWidget {
//   const PlayListTile({,Key? key}) : super(key: key);

//   @override
//   _PlayListTileState createState() => _PlayListTileState();
// }

// class _PlayListTileState extends State<PlayListTile> {

//   @override
//   Widget CollectionTile({
    
//   }) {
//     EdgeInsets margin = index % 2 == 0
//         ? EdgeInsets.only(
//             top: 20,
//             left: 15,
//             right: 8,
//           )
//         : EdgeInsets.only(
//             top: 20,
//             right: 15,
//             left: 8,
//           );

//     return Container(
//       height: 240,
//       width: 190,
//       margin: margin,
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Stack(
//               children: [
//                 CachedNetworkImage(
//                   imageUrl:
//                       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
//                   height: 240,
//                   fit: BoxFit.fill,
//                   placeholder: (context, url) =>
//                       Center(child: CircularProgressIndicator()),
//                   errorWidget: (context, url, error) =>
//                       Center(child: Icon(Icons.error)),
//                 ),
//                 Container(
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: <Color>[
//                         Color.fromRGBO(0, 0, 0, 0),
//                         Color.fromRGBO(69, 69, 69, 1),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             child: Column(
//               children: [
//                 Spacer(),
//                 Container(
//                   padding: EdgeInsets.only(
//                     bottom: 20,
//                     left: 15,
//                     right: 15,
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           title,
//                           style: TextStyle(
//                             fontFamily: 'TTNorms',
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             letterSpacing: 0.5,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '$audioCount аудио',
//                             style: TextStyle(
//                               fontFamily: 'TTNorms',
//                               fontWeight: FontWeight.w400,
//                               fontSize: 12,
//                               color: Colors.white,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 7,
//                           ),
//                           Text(
//                             '${printDurationTime(
//                               duration: sumAudioDuration,
//                               formattingType:
//                                   FormattingType.HourMinuteWithOneDigits,
//                             )} часа',
//                             style: TextStyle(
//                               fontFamily: 'TTNorms',
//                               fontWeight: FontWeight.w400,
//                               fontSize: 12,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
