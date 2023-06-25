import 'package:image_picker/image_picker.dart';

class VideoService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> videoFromCamera() async {
    final pickedVideo = await _imagePicker.pickVideo(source: ImageSource.camera);
    return pickedVideo?.path;
  }

  Future<String?> videoFromGallery() async {
    final pickedVideo = await _imagePicker.pickVideo(source: ImageSource.gallery);
    return pickedVideo?.path;
  }
}