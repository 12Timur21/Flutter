import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SelectionAppBar({
    required this.addTalesToPlaylist,
    required this.createNewPlaylist,
    Key? key,
  }) : super(key: key);

  final VoidCallback addTalesToPlaylist;
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
          ),
        ),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: 15,
            right: 15,
          ),
          child: TextButton(
            onPressed: addTalesToPlaylist,
            child: const Text(
              'Добавить',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'TTNorms',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
      elevation: 0,
    );
  }
}
