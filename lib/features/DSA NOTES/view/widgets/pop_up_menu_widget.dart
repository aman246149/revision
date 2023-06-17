import 'package:flutter/material.dart';

void showPopupMenu(
    BuildContext context, Offset offset, Function() onTap) async {
  double left = offset.dx;
  double top = offset.dy;
  await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(left, top, left + 1, top + 1),
    items: [
      PopupMenuItem<String>(
        child: const Text('Delete'),
        value: 'Delete',
        onTap: () {
          onTap();
        },
      ),
    ],
    elevation: 8.0,
  );
}
