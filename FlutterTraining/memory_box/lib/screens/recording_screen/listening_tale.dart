// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:memory_box/blocks/audioplayer/audioplayer_bloc.dart';
// import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_bloc.dart';
// import 'package:memory_box/blocks/bottomSheetNavigation/bottomSheet_event.dart';
// import 'package:memory_box/blocks/bottom_navigation_index_control/bottom_navigation_index_control_cubit.dart';

// import 'package:memory_box/models/tale_model.dart';
// import 'package:memory_box/repositories/storage_service.dart';
// import 'package:memory_box/screens/recording_screen/widgets/bottom_sheet_wrapper.dart';
// import 'package:memory_box/screens/recording_screen/widgets/tale_controls_buttons.dart';
// import 'package:memory_box/widgets/audioSlider.dart';
// import 'package:memory_box/widgets/deleteAlert.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';

// class ListeningPage extends StatefulWidget {
//   static const routeName = 'ListeningPage';

//   const ListeningPage({Key? key}) : super(key: key);
//   @override
//   _ListeningPageState createState() => _ListeningPageState();
// }

// class _ListeningPageState extends State<ListeningPage> {
//   AudioplayerBloc? _audioBloc;
//   Directory? appDirectory;
//   String? pathToSaveAudio;
//   @override
//   void initState() {
//     _audioBloc = BlocProvider.of<AudioplayerBloc>(context);

//     changeRecordingButton();
//     asyncInit();

//     super.initState();
//   }

//   void asyncInit() async {
//     appDirectory = await getApplicationDocumentsDirectory();
//     if (appDirectory != null) {
//       pathToSaveAudio = appDirectory!.path + '/' + 'Аудиозапись' + '.aac';
//       _audioBloc?.add(
//         InitPlayer(
//           soundModel: TaleModel(
//             url: pathToSaveAudio,
//             ID: const Uuid().v4(),
//           ),
//         ),
//       );

//       int index = await StorageService.instance.filesLength(
//         fileType: FileType.tale,
//       );

//       _audioBloc?.add(
//         UpdateSoundModel(
//           title: 'Запись №$index',
//         ),
//       );
//     }
//   }

//   void changeRecordingButton() {
//     BlocProvider.of<BottomNavigationIndexControlCubit>(context).changeIcon(
//       RecorderButtonStates.defaultIcon,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     void shareSound() {
//       _audioBloc?.add(ShareTale());
//     }

//     void localDownloadSound() {
//       // _soundPlayer?.localDownloadSound();
//     }

//     void deleteSound() async {
//       bool? isDelete = await showDialog<bool>(
//         context: context,
//         builder: (BuildContext context) {
//           return const DeleteAlert(
//             title: 'Удалить эту аудиозапись?',
//             content: 'Вы действительно хотите удалить аудиозапись?',
//           );
//         },
//       );
//       if (isDelete == true) {
//         _audioBloc?.add(DeleteSound());
//         _audioBloc?.add(DisposePlayer());
//         Navigator.of(context).pop();
//       }
//     }

//     void navigateToPreviewPage() {
//       final navigationBloc = BlocProvider.of<BottomSheetBloc>(context);
//       navigationBloc.add(
//         OpenPreviewPage(),
//       );
//     }

//     void saveSound() async {
//       if (pathToSaveAudio != null) {
//         // final file = File(pathToSaveAudio!);
//         // TaleModel? taleModel = _audioBloc?.state.soundModel;
//         // if (taleModel != null) {
//         //   await StorageService.instance.uploadTaleFIle(
//         //     file: file,
//         //     duration: taleModel.duration ?? Duration.zero,
//         //     taleID: taleModel.ID ?? '',
//         //     title: taleModel.title ?? '',
//         //   );
//         // }
//         // // await DatabaseService.instance.updateSongTitle(
//         // //     oldTitle: "oldTitle", newTitle: "newTitle", uid: "uid");

//         // _audioBloc?.add(StopTimer());
//         // _audioBloc?.add(Pause());
//         // _audioBloc?.add(
//         //   Seek(currentPlayTimeInSec: 0),
//         // );

//         navigateToPreviewPage();
//         //!!!!
//         // await CloudService.instance.isFileExist(
//         //   fileType: FileType.sound,
//         //   fileName: 'test2.aac',
//         // );

//         // Navigator.of(context).pop();
//       }
//     }

//     void moveBackward() {
//       _audioBloc = BlocProvider.of<AudioplayerBloc>(context);
//       _audioBloc?.add(MoveBackward15Sec());
//     }

//     void moveForward() {
//       _audioBloc = BlocProvider.of<AudioplayerBloc>(context);
//       _audioBloc?.add(MoveForward15Sec());
//     }

//     void tooglePlay() {
//       _audioBloc = BlocProvider.of<AudioplayerBloc>(context);
//       bool? isPlay = _audioBloc?.state.isPlay;
//       if (isPlay == true) {
//         _audioBloc?.add(
//           Pause(),
//         );
//       } else {
//         _audioBloc?.add(
//           Play(),
//         );
//       }
//     }

//     return BottomSheetWrapeer(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 20,
//           horizontal: 30,
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       padding: const EdgeInsets.only(right: 20),
//                       onPressed: shareSound,
//                       icon: SvgPicture.asset('assets/icons/Share.svg'),
//                     ),
//                     IconButton(
//                       onPressed: localDownloadSound,
//                       icon: SvgPicture.asset('assets/icons/PaperDownload.svg'),
//                     ),
//                     IconButton(
//                       padding: const EdgeInsets.only(left: 20),
//                       onPressed: deleteSound,
//                       icon: SvgPicture.asset('assets/icons/Delete.svg'),
//                     ),
//                   ],
//                 ),
//                 TextButton(
//                   onPressed: saveSound,
//                   child: const Text(
//                     'Сохранить',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontFamily: 'TTNorms',
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 90,
//             ),
//             Expanded(
//               child: BlocBuilder<AudioplayerBloc, AudioplayerState>(
//                 builder: (context, state) {
//                   return Column(
//                     children: [
//                       // Text(
//                       //   state.soundModel?.title ?? 'Запись №_',
//                       //   style: const TextStyle(
//                       //     fontFamily: 'TTNorms',
//                       //     fontWeight: FontWeight.w500,
//                       //     fontSize: 24,
//                       //     letterSpacing: 0.4,
//                       //   ),
//                       // ),
//                       const SizedBox(
//                         height: 40,
//                       ),
//                       Expanded(
//                         child: AudioSlider(
//                           onChanged: () {
//                             if (state.isPlay == true) {
//                               _audioBloc?.add(StopTimer());
//                             }
//                           },
//                           onChangeEnd: (double value) {
//                             _audioBloc?.add(
//                               Seek(currentPlayTimeInSec: value),
//                             );

//                             if (state.isPlay == true) {
//                               _audioBloc?.add(StartTimer());
//                             }
//                           },
//                           currentPlayDuration: state.currentPlayDuration,
//                           // soundDuration: state.soundModel?.duration,
//                         ),
//                       ),
//                       TaleControlButtons(
//                         tooglePlay: tooglePlay,
//                         moveBackward: moveBackward,
//                         moveForward: moveForward,
//                       )
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
