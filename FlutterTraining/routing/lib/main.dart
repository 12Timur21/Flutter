import 'package:flutter/material.dart';

class User {
  String name = 'Timur';
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Home(),
        '/settings': (BuildContext context) => Settings()
      },
      onGenerateRoute: (routeSettings) {
        List<String?> path = routeSettings.name?.split('/') ?? [];

        if (path[1] == 'settings') {
          return MaterialPageRoute(builder: (context) => Settings(id: path[2]));
        } else {
          return MaterialPageRoute(builder: (context) => Settings());
        }
      },
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? numberFromPopUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Container(
        color: Colors.green[100],
        child: Center(
            child: Column(
          children: [
            Text('$numberFromPopUp'),
            TextButton(
                child: const Text(
                  'Settings через императивнуя навигацию',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Settings(id: '12345')))),
            TextButton(
                child: const Text(
                  'Settings через декларативную навигацию',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, '/settings/12345')),
            TextButton(
                child: const Text(
                  'Открыть PopUp и получить число',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  numberFromPopUp = await Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (BuildContext context, _, __) =>
                              MyPopup()));

                  setState(() {});
                }),
          ],
        )),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  String? _id;

  Settings({id}) : _id = id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[200],
      appBar: AppBar(
        title: Text('Setting Page $_id'),
      ),
      body: Center(
        child: TextButton(
          child:
              Text('Back To HomeScreen', style: TextStyle(color: Colors.white)),
          // color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

class MyPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ваш ответ:'),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context, '1');
          },
          child: Text('1'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context, '5');
          },
          child: Text('5'),
        ),
      ],
    );
  }
}
