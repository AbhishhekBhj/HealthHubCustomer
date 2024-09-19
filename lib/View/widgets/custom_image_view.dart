import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Asset Image with Shape and Border Radius
Widget customImageViewAsset({
  required String image,
  required double width,
  required double height,
  required BoxFit fit,
  double borderRadius = 0.0, // Default is no border radius
  bool isCircular = false, // Default is rectangular
}) {
  return isCircular
      ? ClipOval(
          child: Image.asset(
            image,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
        )
      : ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.asset(
            image,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
        );
}

/// Network Image with Shape and Border Radius
Widget customImageViewNetwork({
  required String image,
  required double width,
  required double height,
  required BoxFit fit,
  double borderRadius = 0.0,
  bool isCircular = false,
}) {
  return isCircular
      ? ClipOval(
          child: CachedNetworkImage(
            imageUrl: image,
            width: width,
            height: height,
            fit: fit,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        )
      : ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: CachedNetworkImage(
            imageUrl: image,
            width: width,
            height: height,
            fit: fit,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        );
}

/// File Image (Local File) with Shape and Border Radius
Widget customImageViewFile({
  required File image,
  required double width,
  required double height,
  required BoxFit fit,
  double borderRadius = 0.0,
  bool isCircular = false,
}) {
  return isCircular
      ? ClipOval(
          child: Image.file(
            image,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
        )
      : ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.file(
            image,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
        );
}

/// Memory Image with Shape and Border Radius
Widget customImageViewMemory({
  required Uint8List image,
  required double width,
  required double height,
  required BoxFit fit,
  double borderRadius = 0.0,
  bool isCircular = false,
}) {
  return isCircular
      ? ClipOval(
          child: Image.memory(
            image,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
        )
      : ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.memory(
            image,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
        );
}
