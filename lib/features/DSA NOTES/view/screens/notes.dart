import 'package:dsanotes/providers/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/audio_provider.dart';
import '../widgets/filter_list.dart';
import '../widgets/notes_bottom_sheet.dart';
import '../widgets/notes_widget.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  void initState() {
    super.initState();
    initRecorder();
    getRecordingList();
  }

  void initRecorder() async {
    await context.read<AudioProvider>().initAudioService();
  }

  void getRecordingList() async {
    await context.read<AudioProvider>().getListAllRecordingNotes();
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.read<AudioProvider>();
    final audioProviderWatch = context.watch<AudioProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Notes",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ),
      body: audioProviderWatch.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FilterList(),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: audioProviderWatch.recordingList.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 20,
                      thickness: 0.5,
                    ),
                    itemBuilder: (context, index) {
                      return NotesWidget(
                        notes: audioProvider.recordingList[index],
                        index: index,
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => Container(
                              height: MediaQuery.of(context).size.height * 0.92,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0),
                                ),
                              ),
                              child: CustomBottomSheet(
                                audioProvider: audioProvider,
                                index: index,
                                notes: audioProvider.recordingList[index],
                              ),
                            ),
                          ).whenComplete(() {
                            audioProvider.cancelAllSubscriptions();
                            context.read<VideoProvider>().closeVideoPlayer();
                          });
                        },
                        onDelete: () {
                          audioProvider.deleteNotes(
                              audioProvider.recordingList[index].key!);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Visibility(
        visible: false,
        child: Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          height: 100,
          width: double.infinity,
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  audioProvider.startStopRecorder();
                },
                child: Text(
                  audioProviderWatch.recorder!.isRecording ? "Stop" : "Record",
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  audioProvider.startStopPlayer();
                },
                child: Text(
                    audioProviderWatch.player!.isPlaying ? "Stop" : "Play"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
