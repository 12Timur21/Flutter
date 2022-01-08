import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/widgets/appBar_withButtons.dart';
import 'package:memory_box/widgets/audio_tale_tile.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/drawer/custom_drawer.dart';

class AllTalesScreen extends StatefulWidget {
  static const routeName = 'AllTalesScreen';
  const AllTalesScreen({Key? key}) : super(key: key);

  @override
  _AllTalesScreenState createState() => _AllTalesScreenState();
}

class _AllTalesScreenState extends State<AllTalesScreen> {
  bool isRepitMode = false;
  int? audioLenght;
  Duration? durationList;

  @override
  Widget build(BuildContext context) {
    print('re re render');
    return BackgroundPattern(
      patternColor: const Color.fromRGBO(94, 119, 206, 1),
      height: 260,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBarWithButtons(
          leadingOnPress: () {
            Scaffold.of(context).openDrawer();
          },
          title: Container(
            margin: const EdgeInsets.only(top: 10),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Аудиозаписи',
                style: TextStyle(
                  fontFamily: 'TTNorms',
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  letterSpacing: 0.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\n Все в одном месте',
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsOnPress: () {},
        ),
        drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${audioLenght ?? 0} аудио',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '10:30 часов',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isRepitMode = !isRepitMode;
                      });
                    },
                    child: Container(
                        width: 222,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(
                            246,
                            246,
                            246,
                            isRepitMode == false ? 0.5 : 0.2,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 168,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(246, 246, 246, 1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/Play.svg',
                                    width: 50,
                                  ),
                                  const Text('Запустить все'),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 8,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/Repeat.svg',
                                color: Color.fromRGBO(
                                  246,
                                  246,
                                  246,
                                  isRepitMode == false ? 0.5 : 1,
                                ),
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Expanded(
                child: FutureBuilder<List<TaleModel>>(
                  future: DatabaseService.instance.getAllNotDeletedTaleModels(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<TaleModel>? data = snapshot.data;

                      return ListView.builder(
                        // physics: ClampingScrollPhysics(),
                        itemCount: data?.length,
                        // itemExtent: 80,

                        itemBuilder: (context, index) {
                          return AudioTaleTile(
                            title: data?[index].title ?? 'No name',
                            taleDuration:
                                data?[index].duration ?? Duration.zero,
                            taleID: data?[index].ID ?? '',
                            taleURL: data?[index].url ?? '',
                          );
                        },
                      );
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
