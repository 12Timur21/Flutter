import 'package:flutter/material.dart';

class DeleteAlert extends StatelessWidget {
  const DeleteAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: AlertDialog(
        title: const Text(
          'Удалить эту аудиозапись?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'TTNorms',
          ),
        ),
        content: const Text(
          'Вы действительно хотите удалить аудиозапись?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'TTNorms',
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'Подтвердить',
                  style: TextStyle(
                    fontFamily: 'TTNorms',
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text(
                  'Отменить',
                  style: TextStyle(
                    fontFamily: 'TTNorms',
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
