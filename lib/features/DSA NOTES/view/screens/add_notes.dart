import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/image_picker_service.dart';

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
  final TextEditingController _questionTitleController =
      TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final List<String> _tags = [];
  final List<String> _references = [];
  final List<NoteOption> _selectedOptions = [];
  List<XFile>? _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _selectedOptions.add(NoteOption.Text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Question Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _questionTitleController,
                decoration: const InputDecoration(
                  hintText: 'Enter question title',
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
                  hintText: 'Enter tag',
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
                  hintText: 'Enter references',
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
    );
  }

  Widget _buildOptionTile(NoteOption option) {
    return IntrinsicWidth(
      child: CheckboxMenuButton(
          value: _selectedOptions.contains(option),
          onChanged: (value) {
            if (_selectedOptions.contains(option)) {
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
    return Column(
      children: _selectedOptions.map((option) {
        Widget optionWidget;
        if (option == NoteOption.Audio) {
          optionWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              const Text(
                'Add Audio Note Here',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  CommonButton(
                    icon: Icons.record_voice_over,
                    text: "Record audio",
                    onTap: () async {},
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CommonButton(
                    icon: Icons.play_arrow,
                    text: "Play audio",
                    onTap: () async {},
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
              SizedBox(height: 8),
              const Text(
                'Add Video Note Here',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  CommonButton(
                    icon: Icons.photo_sharp,
                    text: "From Gallery",
                    onTap: () async {},
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CommonButton(
                    icon: Icons.camera_alt,
                    text: "From Camera",
                    onTap: () async {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          );
        } else if (option == NoteOption.Images) {
          optionWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              const Text(
                'Add Images Note Here',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  CommonButton(
                    icon: Icons.photo_sharp,
                    text: "From Gallery",
                    onTap: () async {
                      _selectedImages = await ImagePickerService().pickImages();
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CommonButton(
                    icon: Icons.camera_alt,
                    text: "From Camera",
                    onTap: () async {
                      _selectedImages = await ImagePickerService().pickImages();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          );
        } else if (option == NoteOption.Text) {
          optionWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // SizedBox(height: 16),
              const Text(
                'Add Text Note Here',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
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
  const CommonButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });
  final Function() onTap;
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {
          onTap();
        },
        label: Text(text),
        icon: Icon(icon),
      ),
    );
  }
}
