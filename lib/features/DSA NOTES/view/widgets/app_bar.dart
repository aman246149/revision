import 'package:dsanotes/providers/theme_provider.dart';
import 'package:dsanotes/theme/custom_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        text,
      ),
      actions: [
        IconButton(
            onPressed: () {
              context.read<ThemeProvider>().switchCurrentTheme();
            },
            icon: context.watch<ThemeProvider>().lightTheme
                ? Icon(Icons.brightness_4)
                : Icon(Icons.brightness_2))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
