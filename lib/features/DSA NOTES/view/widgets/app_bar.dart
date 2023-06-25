import 'package:flutter/material.dart';


class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key, required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontSize: 24, fontWeight: FontWeight.w800),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
