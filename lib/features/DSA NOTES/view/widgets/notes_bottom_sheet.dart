import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:dsanotes/features/DSA%20NOTES/model/notes_model.dart';
import 'package:dsanotes/providers/video_provider.dart';
import 'package:dsanotes/services/url_launcher_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../../providers/audio_provider.dart';
import '../../../../services/hive_adapters/notes.dart';
import '../screens/add_notes.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    Key? key,
    required this.audioProvider,
    required this.index,
    required this.notes,
    required this.controller,
  }) : super(key: key);

  final AudioProvider audioProvider;
  final int index;
  final NotesModel notes;
  final ScrollController controller;

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  _CustomBottomSheetState();
  bool _isFullScreen = false;
  double customHeight = 200;
  int rotationTurnt = 0;

  @override
  void initState() {
    super.initState();
    if (widget.notes.videoPath!.isNotEmpty) {
      context.read<VideoProvider>().setVideoPath(widget.notes.videoPath!, true);
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        customHeight = MediaQuery.of(context).size.height;
        rotationTurnt = 1;
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      } else {
        customHeight = 200;
        rotationTurnt = 0;
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  void _togglePlayPause() {
    final videoProvider = context.read<VideoProvider>();
    if (videoProvider.videoPlayerController.value.isPlaying) {
      videoProvider.videoPlayerController.pause();
    } else {
      videoProvider.videoPlayerController.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = context.watch<VideoProvider>();
    final audioProviderWatch = context.watch<AudioProvider>();

    return ListView(
      controller: widget.controller,
      children: [
        Text(
          widget.notes.noteTitle ?? "",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          widget.notes.textNote ?? "",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          "Your Images Notes",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
        ),
        SizedBox(
          height: 15,
        ),
        widget.notes.selectedImages!.isEmpty
            ? const SizedBox()
            : SizedBox(
                height: 180,
                child: ListView.separated(
                  itemCount: widget.notes.selectedImages?.length ?? 0,
                  separatorBuilder: (context, index) => SizedBox(
                    width: 10,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 150,
                        width: 200,
                        child: Image.file(
                          File(widget.notes.selectedImages![index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
        SizedBox(
          height: 20,
        ),

        Text(
          "References",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: widget.notes.references!
              .map((e) => GestureDetector(
                    onTap: () {
                      canlaunchUrl(e);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        e,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        //!If video notes required
        if (widget.notes.videoPath != null &&
            widget.notes.videoPath!.isNotEmpty) ...[
          //! Video is required
          Text(
            "Your Video Notes",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          videoProvider.isVideoLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  height: customHeight,
                  width: double.infinity,
                  child: Center(
                    child:
                        videoProvider.videoPlayerController.value.isInitialized
                            ? Stack(
                                children: [
                                  RotatedBox(
                                    quarterTurns: rotationTurnt,
                                    child: AspectRatio(
                                      aspectRatio: 4 / 2,
                                      child: VideoPlayer(
                                          videoProvider.videoPlayerController),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: VideoProgressIndicator(
                                      videoProvider.videoPlayerController,
                                      allowScrubbing:
                                          true, // Optional: Enable user scrubbing
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: GestureDetector(
                                      onTap: _toggleFullScreen,
                                      child: Icon(
                                        _isFullScreen
                                            ? Icons.fullscreen_exit
                                            : Icons.fullscreen,
                                        size: 30,
                                        // color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: _togglePlayPause,
                                      child: Center(
                                        child: Icon(
                                          videoProvider.videoPlayerController
                                                  .value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: 50,
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                  )),
          const SizedBox(height: 12),
        ],
        //! if audio notes required
        if (widget.notes.audioPath != null &&
            widget.notes.audioPath!.isNotEmpty) ...[
          Text(
            "Your Recorded Notes",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              CommonButton(
                icon: Icons.play_arrow,
                text: "Play",
                onTap: () async {
                  widget.audioProvider.setCurrentPlayingRecording(
                    widget.audioProvider.recordingList[widget.index].key!,
                  );
                  widget.audioProvider.isPlayForDb = true;
                  widget.audioProvider.startStopPlayer();
                  setState(() {});
                },
                isVisible: widget.audioProvider.player!.isStopped,
              ),
              const SizedBox(
                width: 10,
              ),
              CommonButton(
                icon: Icons.stop,
                text: "stop",
                onTap: () async {
                  if (widget.audioProvider.player!.isPlaying) {
                    widget.audioProvider.startStopPlayer();
                  }
                  setState(() {});
                },
                isVisible: widget.audioProvider.player!.isStopped == false,
              ),
            ],
          ),
          const SizedBox(height: 15),
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
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
