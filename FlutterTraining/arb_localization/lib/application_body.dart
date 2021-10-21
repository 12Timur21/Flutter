import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'language_widget.dart';

class AppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          LanguagePickerWidget(),
          const SizedBox(width: 12),
        ],
        title: Text(
          AppLocalizations.of(context)!.title,
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LanguageWidget(),
          const SizedBox(height: 25),
          Center(
            child: Text(
              AppLocalizations.of(context)!.randomText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(AppLocalizations.of(context)!.buttonText),
          )
        ],
      ),
    );
  }
}
