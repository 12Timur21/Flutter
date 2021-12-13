import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/search.dart';
import 'package:memory_box/widgets/undoButton.dart';

class SelectSoundCollection extends StatefulWidget {
  const SelectSoundCollection({Key? key}) : super(key: key);

  @override
  _SelectSoundCollectionState createState() => _SelectSoundCollectionState();
}

class _SelectSoundCollectionState extends State<SelectSoundCollection> {
  @override
  Widget build(BuildContext context) {
    return BackgroundPattern(
      patternColor: Color.fromRGBO(113, 165, 159, 1),
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
            undoChanges: () {},
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
              margin: EdgeInsets.only(
                top: 20,
                right: 15,
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
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
          margin: EdgeInsets.only(
            top: 25,
            left: 15,
            right: 15,
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Search(),
              SizedBox(
                height: 45,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(41)),
                        border: Border.all(
                          color: Color.fromRGBO(58, 58, 85, 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Play.svg',
                            color: Color.fromRGBO(113, 165, 159, 1),
                            width: 60,
                          ),
                          Container(
                            margin: EdgeInsets.only(
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
                            width: 60,
                            height: 60,
                            child: IconButton(
                              onPressed: () {},
                              icon: true
                                  ? SvgPicture.asset(
                                      'assets/icons/Circle.svg',
                                    )
                                  : SvgPicture.asset(
                                      'assets/icons/SubmitCircle.svg',
                                    ),
                            ),
                          ),
                        ],
                      ),
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
