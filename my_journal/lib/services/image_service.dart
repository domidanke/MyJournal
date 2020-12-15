import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  //region Pick Image
  Future<File> pickImage(ImageSource source, {bool circleCrop = false}) async {
    final PickedFile selected = await ImagePicker().getImage(source: source);
    if (selected != null) {
      return cropImage(File(selected.path), circleCrop);
    } else {
      return null;
    }
  }
  //endregion

  //region Crop Image
  Future<File> cropImage(imageFile, bool circleCrop) async {
    if (circleCrop) {
      return await ImageCropper.cropImage(
          cropStyle: CropStyle.circle,
          iosUiSettings: const IOSUiSettings(rotateButtonsHidden: true),
          sourcePath: imageFile.path);
    } else {
      return await ImageCropper.cropImage(
          iosUiSettings: const IOSUiSettings(rotateButtonsHidden: true),
          sourcePath: imageFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3));
    }
  }
  //endregion

}
