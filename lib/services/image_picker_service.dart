import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  Future<List<String>> pickImages() async {
    List<String> images = [];

    try {
      List<XFile>? pickedImages = await ImagePicker().pickMultiImage(
        imageQuality: 80, // Adjust the image quality as needed
        maxWidth: 800, // Adjust the maximum width of the images
        maxHeight: 800, // Adjust the maximum height of the images
      );

      if (pickedImages != null) {
        images = pickedImages.map((image) => image.path).toList();
      }
    } catch (e) {
      // Handle the exception
      print('Error: $e');
    }

    return images;
  }

  Future<List<String>> pickImagesFromCamera() async {
    List<String> images = [];

    try {
      XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedImage != null) {
        images.add(pickedImage.path);
      }
    } catch (e) {
      // Handle the exception
      print('Error: $e');
      rethrow;
    }

    return images;
  }
}
