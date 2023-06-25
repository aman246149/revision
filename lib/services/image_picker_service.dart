import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  Future<List<XFile>> pickImages() async {
    List<XFile> images = [];

    try {
      List<XFile>? pickedImages = await ImagePicker().pickMultiImage(
        imageQuality: 80, // Adjust the image quality as needed
        maxWidth: 800, // Adjust the maximum width of the images
        maxHeight: 800, // Adjust the maximum height of the images
      );

      if (pickedImages != null) {
        images.addAll(pickedImages);
      }
    } catch (e) {
      // Handle the exception
      print('Error: $e');
    }

    return images;
  }
}
