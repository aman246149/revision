import 'package:dsanotes/features/DSA%20NOTES/view/screens/add_notes.dart';
import 'package:dsanotes/providers/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/audio_provider.dart';
import '../widgets/app_bar.dart';
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
      appBar: const CommonAppBar(text: "My Notes"),
      body: audioProviderWatch.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : audioProviderWatch.recordingList.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Ops,Seems You Don't Have Any Notes Add New Notes",
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: FilterList(),
                    ),
                    const SizedBox(
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.92,
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
                                context
                                    .read<VideoProvider>()
                                    .closeVideoPlayer();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNotes(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
