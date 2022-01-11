import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/repositories/database_service.dart';
import 'package:memory_box/screens/playlist_screen/create_playlist_screen.dart';
import 'package:memory_box/utils/navigationService.dart';

class ViewingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ViewingAppBar({
    required this.createNewPlaylist,
    Key? key,
  }) : super(key: key);
  final VoidCallback createNewPlaylist;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      primary: true,
      toolbarHeight: 70,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: Container(
        margin: const EdgeInsets.only(left: 6),
        child: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/Plus.svg',
          ),
          onPressed: createNewPlaylist,
        ),
      ),
      title: Container(
        margin: const EdgeInsets.only(top: 10),
        child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: 'Подборки',
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
      actions: [
        Container(
          margin: const EdgeInsets.only(
            right: 15,
          ),
          child: IconButton(
            onPressed: () {
              DatabaseService.instance.getAllPlayList();
            },
            icon: SvgPicture.asset(
              'assets/icons/More.svg',
            ),
          ),
        )
      ],
      elevation: 0,
    );
  }
}
