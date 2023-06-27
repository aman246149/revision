// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:dsanotes/providers/video_provider.dart';
import 'package:dsanotes/services/hive_adapters/notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../../providers/audio_provider.dart';
import '../../../../services/database_service.dart';
import '../../../../services/get_video_service.dart';
import '../../../../services/image_picker_service.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final TextEditingController _questionTitleController =
      TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _textNoteController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final List<String> _tags = [];
  final List<String> _references = [];
  final List<NoteOption> _selectedOptions = [];
  List<String>? _selectedImages = [];
  String? videoPath = "";
  final kHintStyle = const TextStyle(color: Colors.grey, fontSize: 14);
  Color color = Colors.red;
  bool loader = false;

  @override
  void initState() {
    super.initState();
    _selectedOptions.add(NoteOption.Text);
  }

  void saveToDatabase() async {
    final audioProvider = context.read<AudioProvider>();
    setState(() {
      loader = true;
    });

    if (audioProvider.recorder!.isRecording) {
      audioProvider.recorder!.stopRecorder();
      await Future.delayed(Duration(seconds: 1));
    }

    var notes = NotesHive()
      ..audioPath = context.read<AudioProvider>().audioPathFromRecorder
      ..noteTitle = _questionTitleController.text
      ..noteTypes = _selectedOptions
      ..references = _references
      ..selectedImages = _selectedImages
      ..textNote = _textNoteController.text
      ..videoPath = videoPath
      ..tagName = _tags
      ..dateTime = DateTime.now();

    await GetIt.I<DataBaseService>().putBox(notes.dateTime.toString(), notes);
    await audioProvider.getListAllRecordingNotes();
    final snackBar = SnackBar(content: Text('Successfully saved'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      loader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<VideoProvider>().closeVideoPlayer();
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Notes'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Note Title',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _questionTitleController,
                    decoration: const InputDecoration(
                      hintText: 'Find max in Array without Sorting',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Note Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    children: [
                      _buildOptionTile(NoteOption.Audio),
                      _buildOptionTile(NoteOption.Video),
                      _buildOptionTile(NoteOption.Images),
                      _buildOptionTile(NoteOption.Text),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildSelectedOptionFields(),
                  const SizedBox(height: 16),
                  const Text(
                    'Tags',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      hintText: 'Enter tag (Like Graph,Arrays)',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _tags.add(_tagController.text.trim());
                            _tagController.clear();
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _tags.add(value.trim());
                        _tagController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _buildTagChips(_tags),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'References',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _referenceController,
                    decoration: InputDecoration(
                      hintText: 'Enter references (Like Google)',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _references.add(_referenceController.text.trim());
                            _referenceController.clear();
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        _references.add(value.trim());
                        _referenceController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _buildReferenceChips(_references),
                  ),

                  const SizedBox(height: 8),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: _selectedImages.length,
                  //   itemBuilder: (context, index) {
                  //     return Image.file(File(_selectedImages[index].path));
                  //   },
                  // ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.green.shade100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: loader
                    ? IntrinsicHeight(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const Text("SAVE"),
              ),
              onPressed: () => saveToDatabase(),
            ),
          )),
    );
  }

  Widget _buildOptionTile(NoteOption option) {
    return IntrinsicWidth(
      child: CheckboxMenuButton(
          value: _selectedOptions.contains(option),
          onChanged: (value) {
            if (_selectedOptions.contains(option)) {
              // if (option == NoteOption.Text) {
              //   return;
              // }
              _selectedOptions.remove(option);
            } else {
              _selectedOptions.add(option);
            }
            setState(() {});
          },
          child: Text(option.toString().split('.').last)),
    );
  }

  Widget _buildSelectedOptionFields() {
    bool isStartRecording = false;
    final audioProvider = context.read<AudioProvider>();
    final audioProviderWatch = context.watch<AudioProvider>();
    final videoProvider = context.read<VideoProvider>();
    return Column(
      children: _selectedOptions.map((option) {
        Widget optionWidget;
        if (option == NoteOption.Audio) {
          optionWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Add Audio Note Here',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CommonButton(
                    icon: Icons.record_voice_over,
                    text: audioProviderWatch.recorder!.isRecording
                        ? "Stop Recording"
                        : "Start Record",
                    onTap: () async {
                      audioProvider.startStopRecorder();
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CommonButton(
                    icon: Icons.play_arrow,
                    text: audioProviderWatch.player!.isPlaying
                        ? "Stop audio"
                        : "Play audio",
                    onTap: () async {
                      audioProvider.startStopPlayer();
                    },
                    isVisible: !audioProviderWatch.recorder!.isRecording,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          );
        } else if (option == NoteOption.Video) {
          optionWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Add Video Note Here',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CommonButton(
                    icon: Icons.photo_sharp,
                    text: "From Gallery",
                    onTap: () async {
                      videoPath = await VideoService().videoFromGallery();
                      videoProvider.setVideoPath(videoPath!, true);
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CommonButton(
                    icon: Icons.camera_alt,
                    text: "From Camera",
                    onTap: () async {
                      videoPath = await VideoService().videoFromCamera();
                      await videoProvider.setVideoPath(videoPath!, true);

                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              videoPath!.isEmpty && videoProvider.isVideoLoading
                  ? const SizedBox()
                  : AspectRatio(
                      aspectRatio:
                          videoProvider.videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(videoProvider.videoPlayerController),
                    ),
              const SizedBox(height: 8),
            ],
          );
        } else if (option == NoteOption.Images) {
          optionWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Add Images Note Here',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CommonButton(
                    icon: Icons.photo_sharp,
                    text: "From Gallery",
                    onTap: () async {
                      _selectedImages = await ImagePickerService().pickImages();
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CommonButton(
                    icon: Icons.camera_alt,
                    text: "From Camera",
                    onTap: () async {
                      _selectedImages =
                          await ImagePickerService().pickImagesFromCamera();
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _selectedImages!.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: 180,
                      child: ListView.separated(
                        itemCount: _selectedImages?.length ?? 0,
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
                                File(_selectedImages![index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 8),
            ],
          );
        } else if (option == NoteOption.Text) {
          optionWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 16),
              Text(
                'Add Text Note Here',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _textNoteController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Write Notes ....',
                  border: OutlineInputBorder(),
                ),
                // Add text-specific logic here
              ),
              SizedBox(height: 8),
            ],
          );
        } else {
          optionWidget = Container();
        }

        return Column(
          children: [
            optionWidget,
          ],
        );
      }).toList(),
    );
  }

  List<Widget> _buildTagChips(List<String> tags) {
    return tags.map((tag) {
      return Chip(
        label: Text(tag),
        onDeleted: () {
          setState(() {
            _tags.remove(tag);
          });
        },
      );
    }).toList();
  }

  List<Widget> _buildReferenceChips(List<String> references) {
    return references.map((reference) {
      return Chip(
        label: Text(reference),
        onDeleted: () {
          setState(() {
            _references.remove(reference);
          });
        },
      );
    }).toList();
  }

  @override
  void dispose() {
    _questionTitleController.dispose();
    _tagController.dispose();
    _referenceController.dispose();
    super.dispose();
  }
}

class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.icon,
      this.isVisible = true});
  final Function() onTap;
  final String text;
  final IconData icon;
  final bool isVisible;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Expanded(
        child: ElevatedButton.icon(
          onPressed: () {
            onTap();
          },
          label: Text(text),
          icon: Icon(icon),
        ).animate().shimmer(),
      ),
    );
  }
}
