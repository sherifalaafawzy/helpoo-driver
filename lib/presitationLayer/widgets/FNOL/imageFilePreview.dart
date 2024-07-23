import 'package:flutter/material.dart';
import 'dart:io' as io;


class imageFilePreview extends StatefulWidget {
  const imageFilePreview({
    Key? key,
    required this.imagePath,
    required this.requiredImage,
  }) : super(key: key);

  final String? imagePath;
  final String requiredImage;

  @override
  State<imageFilePreview> createState() => _ImageFilePreviewState();
}

class _ImageFilePreviewState extends State<imageFilePreview> {
  @override
  Widget build(BuildContext context) {
    return Image.file(io.File(widget.imagePath!), fit: BoxFit.fill);
  }
}