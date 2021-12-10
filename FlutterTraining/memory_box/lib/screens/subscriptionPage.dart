import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/navigationMenu.dart';

class SubscriptionPage extends StatefulWidget {
  static const routeName = 'SubscriptionPage';

  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    Widget subscriptionType(bool isActive) {
      return Container(
        // height: 200,
        padding: EdgeInsets.only(
          top: 50,
          bottom: 10,
        ),
        margin: EdgeInsets.all(10),
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
            SizedBox(
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
            SizedBox(
              height: 10,
            ),
            Container(
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
            margin: EdgeInsets.only(left: 6),
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
        drawer: const NavigationBar(),
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
                SizedBox(
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
                SizedBox(
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
                SizedBox(
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
                          SizedBox(height: 20),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Infinite.svg',
                                width: 25,
                              ),
                              SizedBox(width: 10),
                              Text('Неограниченая память'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/CloudUpload.svg',
                                width: 25,
                              ),
                              SizedBox(width: 10),
                              Text('Все файлы хранятся в облаке'),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/PaperDownload.svg',
                                width: 25,
                              ),
                              SizedBox(width: 10),
                              Text('Возможность скачивать без ограничений'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                TextButton(
                  child: Text(
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
                      Color.fromRGBO(241, 180, 136, 1),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 100,
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
                SizedBox(
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
