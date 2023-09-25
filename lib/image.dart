import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fractal/lib.dart';
import 'package:fractal/types/file.dart';
import 'package:fractal/types/image.dart';
import 'package:url_launcher/url_launcher.dart';

class FractalImage extends StatefulWidget {
  final FileF file;
  final BoxFit fit;

  const FractalImage(
    this.file, {
    this.fit = BoxFit.contain,
    super.key,
  });

  @override
  State<FractalImage> createState() => _FractalImageState();

  //final hash = md5(); //sha256.convert(f).toString();

  /*&
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Uploading ${hash.toString()}'),
        backgroundColor: Colors.orange,
      ),
    );
    */

  //ctrl.text = ctrl.text + ' ${file_hash.toString()} ';

  /*

      /*
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Uploaded image: $responseBody'),
          backgroundColor: Colors.green,
        ),
      );
      */
      return hash;
    } else {
      /*
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $responseBody'),
          backgroundColor: Colors.red,
        ),
      );
      */
      return null;
    }
    */

  static Future<ImageF?> pick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    final bytes = result?.files.first.bytes;
    if (bytes == null) return null;
    //result?.files.first.

    return ImageF.bytes(bytes);

    //final hash = await FData.publish(bytes);

    //final hash = sha256.convert(_image);
    //return await upload(bytes);
  }
}

class _FractalImageState extends State<FractalImage> {
  Image? image;

  @override
  void initState() {
    super.initState();
    initImage();
  }

  initImage() async {
    final bytes = await widget.file.load();
    setState(() {
      image = Image.memory(
        bytes,
        fit: BoxFit.cover,
      );
    });
  }

  openFile() {
    //if (widget.event == null || widget.event!.file.isEmpty) return;
    final uri = Uri.parse(
      widget.file.url,
    );
    launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return image ?? const CircularProgressIndicator();
  }
}
