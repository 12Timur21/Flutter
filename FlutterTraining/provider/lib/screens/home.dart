import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/models/darkModeModel.dart';
import 'package:provider_test/providers/click.dart';
import 'package:provider_test/providers/user.dart';
import 'package:provider_test/screens/counterNumber.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    bool isDarkMode = Provider.of<DarkModeModel>(context).isDarkMode;

    void _incrementCounter() {
      setState(() {
        _counter++;
      });
      print(_counter);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Home - Welcome ${user.name}')),
      body: Container(
          decoration:
              BoxDecoration(color: isDarkMode ? Colors.black : Colors.white),
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                    icon: Icon(Icons.settings),
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.grey[900]),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    label: Text('Go to settings')),
              ),
              Center(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: const BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        color: Colors.black,
                      ),
                      child: MultiProvider(providers: [
                        ProxyProvider0<int>(update: (context, _) => _counter),
                        ProxyProvider<int, Click>(
                            update: (_, counter, __) => Click(counter)),
                      ], child: CounterNumber())))
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(Icons.add),
      ),
    );
  }
}
