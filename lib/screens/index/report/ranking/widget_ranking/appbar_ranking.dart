import 'package:flutter/material.dart';

class RankingAppbar extends StatelessWidget implements PreferredSizeWidget {
  const RankingAppbar({
    super.key,
    required this.backgroundColor,
    required this.contentColor,
  });

  final Color backgroundColor;
  final Color contentColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: contentColor,
            )),
      ),
      backgroundColor: backgroundColor,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert_rounded,
                color: contentColor,
              )),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
