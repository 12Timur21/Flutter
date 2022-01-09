import 'package:flutter/material.dart';

class BottomSheetChangeConfirmation extends StatelessWidget {
  const BottomSheetChangeConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      color: Colors.red,
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.cancel),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.task_alt),
            ),
          ),
        ],
      ),
    );
  }
}
