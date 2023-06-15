import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import '../../../../providers/audio_provider.dart';
import '../../../../services/hive_adapters/notes.dart';



class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet(
      {super.key,
      required this.audioProvider,
      required this.index,
      required this.notes});
  final AudioProvider audioProvider;
  final int index;
  final Notes notes;
  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  _CustomBottomSheetState();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.notes.fileName ?? "",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 200,
            width: double.maxFinite,
            child: Image.network(
              "https://media.geeksforgeeks.org/wp-content/cdn-uploads/graph.png",
              fit: BoxFit.cover,
            ),
          ),
          Text(
            "Your Written Notes here, This notes only be show here when its not empty",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Your Recorded Notes",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      widget.audioProvider.setCurrentPlayingRecording(widget
                          .audioProvider.recordingList[widget.index].key!);
                      widget.audioProvider.isPlayForDb = true;
                      widget.audioProvider.startStopPlayer();
                      setState(() {});
                    },
                    child: const Text("Play")),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      widget.audioProvider.setCurrentPlayingRecording(widget
                          .audioProvider.recordingList[widget.index].key!);
                      widget.audioProvider.isPlayForDb = true;
                      widget.audioProvider.startStopPlayer();
                      setState(() {});
                    },
                    child: const Text("Stop")),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          StreamBuilder<Duration>(
            stream: widget.audioProvider.duration?.stream,
            builder: (context, totalDurationSnapshot) {
              if (totalDurationSnapshot.hasData) {
                return StreamBuilder<Duration>(
                  stream: widget.audioProvider.position?.stream,
                  builder: (context, positionSnapshot) {
                    return ProgressBar(
                      thumbRadius: 6,
                      timeLabelTextStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 12),
                      timeLabelType: TimeLabelType.totalTime,
                      timeLabelPadding: 7,
                      progress: positionSnapshot.data ?? Duration.zero,
                      total: totalDurationSnapshot.data ?? Duration.zero,
                      onSeek: widget.audioProvider.seek,
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
