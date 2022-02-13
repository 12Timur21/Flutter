import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';

class SubscriptionScreen extends StatefulWidget {
  static const routeName = 'SubscriptionScreen';

  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    Widget subscriptionType(bool isActive) {
      return Container(
        // height: 200,
        padding: const EdgeInsets.only(
          top: 50,
          bottom: 10,
        ),
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 4),
              color: Color.fromRGBO(0, 0, 0, 0.1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '300р',
              style: TextStyle(
                fontFamily: 'TTNorms',
                fontWeight: FontWeight.w400,
                fontSize: 24,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'в месяц',
              style: TextStyle(
                fontFamily: 'TTNorms',
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: IconButton(
                onPressed: () {},
                icon: isActive
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
    }

    return BackgroundPattern(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          primary: true,
          toolbarHeight: 70,
          // backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: Container(
            margin: const EdgeInsets.only(left: 6),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/Burger.svg',
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Container(
            margin: const EdgeInsets.only(
              top: 15,
              bottom: 15,
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Подписка',
                style: TextStyle(
                  fontFamily: 'TTNorms',
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  letterSpacing: 0.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\n Расширь возможности',
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          color: Colors.white,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(246, 246, 246, 1),
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  spreadRadius: 6,
                  blurRadius: 8,
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Выбери подписку',
                  style: TextStyle(
                    fontFamily: 'TTNorms',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: subscriptionType(true),
                    ),
                    Expanded(
                      child: subscriptionType(false),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Что даёт подписка:',
                          style: TextStyle(
                            fontFamily: 'TTNorms',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Infinite.svg',
                                width: 25,
                              ),
                              const SizedBox(width: 10),
                              const Text('Неограниченая память'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/CloudUpload.svg',
                                width: 25,
                              ),
                              const SizedBox(width: 10),
                              const Text('Все файлы хранятся в облаке'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/PaperDownload.svg',
                                width: 25,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                  'Возможность скачивать без ограничений'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  child: const Text(
                    'Подписаться на месяц',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(51),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(241, 180, 136, 1),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 100,
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
