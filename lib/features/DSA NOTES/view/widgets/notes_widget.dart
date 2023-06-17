import "package:dsanotes/features/DSA%20NOTES/view/widgets/pop_up_menu_widget.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../../../services/hive_adapters/notes.dart";

class NotesWidget extends StatelessWidget {
  const NotesWidget({
    super.key,
    required this.notes,
    required this.index,
    required this.onTap, required this.onDelete,
  });
  final Notes notes;
  final int index;
  final Function() onTap;
  final Function() onDelete;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      leading: Image.network(
          "https://media.geeksforgeeks.org/wp-content/cdn-uploads/graph.png"),
      title: Text(
        notes.fileName ?? "",
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontSize: 20, fontWeight: FontWeight.w800),
      ),
      subtitle: Text(notes.topicName ?? "",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 15, fontWeight: FontWeight.w400)),
      trailing: GestureDetector(
          onTapDown: (TapDownDetails details) {
            showPopupMenu(context, details.globalPosition,onDelete);
          },
          child: Icon(Icons.more_vert)),
    );
  }
}
