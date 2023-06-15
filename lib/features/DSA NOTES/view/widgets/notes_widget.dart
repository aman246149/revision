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
    return GestureDetector(
      onTap: () {
        onTap();
        // final audioProvider=context.read<AudioProvider>();
        // audioProvider.setCurrentPlayingRecording(
        //     audioProvider.recordingList[index].key!);
        // audioProvider.isPlayForDb = true;
        // audioProvider.startStopPlayer();
      },
      child: ColoredBox(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                  "https://media.geeksforgeeks.org/wp-content/cdn-uploads/graph.png"),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                notes.fileName ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(notes.topicName ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w400)),
                  Text(DateFormat("dd-MMM-yyyy").format(notes.dateTime!),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}