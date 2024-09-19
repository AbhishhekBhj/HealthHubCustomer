import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthhubcustomer/View/widgets/alerts/custom_snackbar.dart';
import 'package:healthhubcustomer/View/widgets/buttons/healthhub_custom_button.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:healthhubcustomer/utils/custom_textStyles.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> imagePickAndCrop({required BuildContext context}) async {
  File? image;
  final ImagePicker imagePicker = ImagePicker();
  final ImageCropper imageCropper = ImageCropper();
  final width  = MediaQuery.of(context).size.width;;

  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [appMainColor, Color.fromARGB(255, 224, 180, 232)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
                "Select Image Source",
                style: interBold(
                  color: appWhiteColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              HealthhubCustomButton(
                borderRadius: 12,
                height: 40,
                width: width*0.35,
                text: "Camera",
                backgroundColor: appMainColor,
                textColor: appWhiteColor,
                onPressed: () async{
                  final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    final CroppedFile? croppedFile = await imageCropper.cropImage(
                      sourcePath: pickedFile.path,
                      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                      uiSettings: [
                        AndroidUiSettings(
                          toolbarTitle: 'Crop Image',
                          toolbarColor: Colors.blue,
                          toolbarWidgetColor: appWhiteColor,
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
              ),
              const SizedBox(height: 16),
             HealthhubCustomButton(

              borderRadius: 12,
              onPressed: ()async{
                final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    final CroppedFile? croppedFile = await imageCropper.cropImage(
                      sourcePath: pickedFile.path,
                      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                      uiSettings: [
                        AndroidUiSettings(
                          toolbarTitle: 'Crop Image',
                          toolbarColor: Colors.blue,
                          toolbarWidgetColor: appWhiteColor,
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
              backgroundColor: appMainColor,
              text: "Gallery",
              textColor: appWhiteColor,
              height: 40,
              width: width*0.35,
             ),
              const SizedBox(height: 16),
              HealthhubCustomButton(
                height: 40,
                width: width*0.35,
                onPressed: (){
                  Navigator.pop(context);
                },
                backgroundColor: appMainColor,
                text: "Cancel",
                borderRadius: 12,
                textColor: appWhiteColor,
              ),
            ],
          ),
        ),
      );
    },
  );

  return image;
}




Future<List<File>?> pickMultipleImages(BuildContext context) async {
  try {
    List<File> images = [];
    final ImagePicker imagePicker = ImagePicker();

    return showModalBottomSheet<List<File>>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                "Select Image Source",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final List<XFile>? pickedFiles = await imagePicker.pickMultiImage();
                  if (pickedFiles != null) {
                    for (XFile file in pickedFiles) {
                      images.add(File(file.path));
                    }
                    Navigator.pop(context, images);
                  }
                },
                icon: const Icon(Icons.photo_library),
                label: const Text("Gallery"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel),
                label: const Text("Cancel"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  } catch (e) {
    customSnackBar(context: context, message: e.toString(), snackBarColor: appErrorColor, textColor: appWhiteColor);
    print(e);
    rethrow;
  }
}
