import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tattoo/core/extensions/context_extension.dart';

class GalleryHelper {
  static final GalleryHelper instance = GalleryHelper._init();

  GalleryHelper._init();

  /// Get from gallery
  Future<XFile?> getFromGallery() async {
    return await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
  }

  /// Get from Camera
  Future<XFile?> getFromCamera() async {
    return await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
  }

  Future<List<double>> computeSize(BuildContext context, File file,
      {double? maxWidth, double? maxHeight}) async {
    var decodedImage = await decodeImageFromList(file.readAsBytesSync());

    double w = decodedImage.width.toDouble();
    double h = decodedImage.height.toDouble();

    double wr = w / (maxWidth ?? context.dynamicWidth(0.5));
    double hr = h / (maxHeight ?? context.dynamicHeight(0.3));

    double width;
    double height;

    if (wr > hr) {
      width = w / wr;
      height = h / wr;
    } else {
      width = w / hr;
      height = h / hr;
    }

    return [width, height];
  }
}
