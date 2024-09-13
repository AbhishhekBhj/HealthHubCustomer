import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> imagePickAndCrop({required BuildContext context}) async {
  File? image;
  final ImagePicker imagePicker = ImagePicker();
  final ImageCropper imageCropper = ImageCropper();

  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Image Source",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  final CroppedFile? croppedFile = await imageCropper.cropImage(
                    sourcePath: pickedFile.path,
                                        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),

                    uiSettings: [
                      AndroidUiSettings(
                        toolbarTitle: 'Crop Image',
                        toolbarColor: Colors.blue,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false,
                      ),
                      IOSUiSettings(
                        minimumAspectRatio: 1.0,
                      ),
                    ],
                  );
                  if (croppedFile != null) {
                    image = File(croppedFile.path);
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text("Camera"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  final CroppedFile? croppedFile = await imageCropper.cropImage(
                    sourcePath: pickedFile.path,
                    aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                    uiSettings: [
                      AndroidUiSettings(
                        toolbarTitle: 'Crop Image',
                        toolbarColor: Colors.blue,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false,
                      ),
                      IOSUiSettings(
                        minimumAspectRatio: 1.0,
                      ),
                    ],
                  );
                  if (croppedFile != null) {
                    image = File(croppedFile.path);
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text("Gallery"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      );
    },
  );

  return image;
}


Future<List<File>?> pickMultipleImages(BuildContext context){

  try{

    List<File> images = [];

    final ImagePicker imagePicker = ImagePicker();

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Image Source",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final List<XFile>? pickedFiles = await imagePicker.pickMultiImage();
                  if (pickedFiles != null) {
                    for (XFile file in pickedFiles) {
                      images.add(File(file.path));
                    }
                    Navigator.pop(context, images);
                  }
                },
                child: const Text("Gallery"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      },
    );

  }
  catch(e){
    Get.snackbar("Error", e.toString());
    print(e);
    rethrow;
  }

}
