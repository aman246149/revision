import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/audio_provider.dart';
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
        title: const Text("Notes"),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_alt),
            itemBuilder: (BuildContext context) {
              return audioProvider.filters.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
            onSelected: (String selectedValue) {
              // Handle selected value
              print('Selected: $selectedValue');
            },
          ),
          SizedBox(width: 15),
        ],
      ),
      body: audioProviderWatch.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
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
                      builder: (_) => CustomBottomSheet(
                        audioProvider: audioProvider,
                        index: index,
                        notes: audioProvider.recordingList[index],
                      ),
                    ).whenComplete(
                        () => audioProvider.cancelAllSubscriptions());
                  },
                );
              },
            ),
      bottomNavigationBar: Visibility(
        visible: true,
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
    );
  }
}
