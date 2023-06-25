import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


enum NoteOption {
  Audio,
  Video,
  Images,
  Text,
}

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController _questionTitleController = TextEditingController();
  TextEditingController _tagController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();
  List<String> _tags = [];
  List<String> _references = [];
  List<NoteOption> _selectedOptions = [];
  List<XFile> _selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notes'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _questionTitleController,
                decoration: InputDecoration(
                  hintText: 'Enter question title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Tags',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _tagController,
                decoration: InputDecoration(
                  hintText: 'Enter tags',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _tags.add(_tagController.text.trim());
                        _tagController.clear();
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    _tags.add(value.trim());
                    _tagController.clear();
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                'References',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _referenceController,
                decoration: InputDecoration(
                  hintText: 'Enter references',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _references.add(_referenceController.text.trim());
                        _referenceController.clear();
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    _references.add(value.trim());
                    _referenceController.clear();
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                'Add',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Column(
                children: [
                  _buildOptionTile(NoteOption.Audio),
                  _buildOptionTile(NoteOption.Video),
                  _buildOptionTile(NoteOption.Images),
                  _buildOptionTile(NoteOption.Text),
                ],
              ),
              SizedBox(height: 16),
              _buildSelectedOptionFields(),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _buildTagChips(_tags),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _buildReferenceChips(_references),
              ),
              SizedBox(height: 8),
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
    );
  }

  Widget _buildOptionTile(NoteOption option) {
    return ListTile(
      title: Text(option.toString().split('.').last),
      onTap: () {
        setState(() {
          if (_selectedOptions.contains(option)) {
            _selectedOptions.remove(option);
          } else {
            _selectedOptions.add(option);
          }
        });
      },
      selected: _selectedOptions.contains(option),
      selectedTileColor: Colors.grey[300],
    );
  }

  Widget _buildSelectedOptionFields() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: _selectedOptions.map((option) {
          Widget optionWidget;
          if (option == NoteOption.Audio) {
            optionWidget = Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        // Logic for selecting audio from device
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.audio,
                        );
                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            // Handle the selected audio file
                            PlatformFile file = result.files.first;
                            // Do something with the selected audio file
                          });
                        }
                      },
                      icon: Icon(Icons.audiotrack),
                    ),
                    IconButton(
                      onPressed: () {
                        // Logic for recording audio
                        // Implement your audio recording logic here
                      },
                      icon: Icon(Icons.mic),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            );
          } else if (option == NoteOption.Video) {
            optionWidget = Column(
              children: [
                SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        // Logic for selecting video from device
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.video,
                        );
                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            // Handle the selected video file
                            PlatformFile file = result.files.first;
                            // Do something with the selected video file
                          });
                        }
                      },
                      icon: Icon(Icons.video_library),
                    ),
                    IconButton(
                      onPressed: () async {
                        // Logic for recording video using camera
                        XFile? recordedVideo = await ImagePicker().pickVideo(source: ImageSource.camera);
                        if (recordedVideo != null) {
                          setState(() {
                            // Handle the recorded video
                            // Do something with the recorded video
                          });
                        }
                      },
                      icon: Icon(Icons.videocam),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            );
          }
          else if (option == NoteOption.Images) {
            optionWidget = Column(
              children: [
                SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        // Logic for selecting images from device
                        List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
                        if (selectedImages != null) {
                          setState(() {
                            // Handle the selected images
                            // Do something with the selected images
                          });

                        }
                      },
                      icon: Icon(Icons.photo_library),
                    ),
                    IconButton(
                      onPressed: () async {
                        // Logic for capturing image using camera
                        XFile? capturedImage = await ImagePicker().pickImage(source: ImageSource.camera);
                        if (capturedImage != null) {
                          setState(() {
                            // Handle the captured image
                            // Do something with the captured image
                          });
                        }
                      },
                      icon: Icon(Icons.camera_alt),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            );
          } else if (option == NoteOption.Text) {
            optionWidget = Column(
              children: [
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Add text',
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
              Divider(height: 1, color: Colors.grey),
            ],
          );
        }).toList(),
      ),
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
