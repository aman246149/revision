import "dart:io";

import "package:dsanotes/features/DSA%20NOTES/view/widgets/pop_up_menu_widget.dart";
import "package:flutter/material.dart";

import "../../../../services/hive_adapters/notes.dart";
import "../../model/notes_model.dart";

class NotesWidget extends StatelessWidget {
  const NotesWidget({
    super.key,
    required this.notes,
    required this.index,
    required this.onTap,
    required this.onDelete,
  });
  final NotesModel notes;
  final int index;
  final Function() onTap;
  final Function() onDelete;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      leading: Image.file(
        File(notes.selectedImages?[0] ?? ""),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
      title: Text(
        notes.noteTitle ?? "",
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontSize: 20, fontWeight: FontWeight.w800),
      ),
      subtitle: Text(notes.tagName?.join(", ") ?? "",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 15, fontWeight: FontWeight.w400)),
      trailing: GestureDetector(
          onTapDown: (TapDownDetails details) {
            showPopupMenu(context, details.globalPosition, onDelete);
          },
          child: const Icon(Icons.more_vert)),
    );
  }
}
