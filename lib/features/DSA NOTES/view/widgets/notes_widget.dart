import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../../../services/hive_adapters/notes.dart";

class NotesWidget extends StatelessWidget {
  const NotesWidget({
    super.key,
    required this.notes,
    required this.index,
    required this.onTap,
  });
  final Notes notes;
  final int index;
  final Function() onTap;
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
      trailing: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
    );
  }
}
