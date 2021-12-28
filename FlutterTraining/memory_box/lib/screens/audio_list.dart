import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/widgets/appBar_withButtons.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/custom_navigationBar.dart';

class AudioListPage extends StatefulWidget {
  static const routeName = 'AudioListPage';
  const AudioListPage({Key? key}) : super(key: key);

  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  bool isRepitMode = false;

  @override
  Widget build(BuildContext context) {
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
        drawer: const CustomNavigationBar(),
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
                        '20 часов',
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
                child: ListView.builder(
                  // physics: ClampingScrollPhysics(),
                  itemCount: 45,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(41),
                        border: Border.all(
                          color: const Color.fromRGBO(58, 58, 85, 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Play.svg',
                            color: const Color.fromRGBO(94, 119, 206, 1),
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
                                  'Малыш кокки ${index.toString()}',
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
                                const Text(
                                  '30 минут',
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
                          Container(
                            margin: const EdgeInsets.only(
                              right: 10,
                            ),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                'assets/icons/More.svg',
                                color: Colors.black,
                                width: 28,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    );
                    // return ListTile(
                    //   tileColor: Color.fromRGBO(58, 58, 85, 0.2),
                    //   shape: RoundedRectangleBorder(

                    //       borderRadius: BorderRadius.circular(20.0)),
                    //   leading: SvgPicture.asset(
                    //     'assets/icons/Play.svg',
                    //     color: Color.fromRGBO(94, 119, 206, 1),
                    //   ),
                    //   title: Text('$index'),
                    //   subtitle: Text('30 минут'),
                    //   trailing: SvgPicture.asset(
                    //     'assets/icons/More.svg',
                    //     color: Colors.black,
                    //   ),
                    // );
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
