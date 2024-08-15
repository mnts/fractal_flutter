import 'dart:async';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fractal/lib.dart';
import 'package:fractal/types/file.dart';
import 'package:fractal/types/image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image/image.dart' as Img;

class FractalImage extends StatefulWidget {
  final FileF file;
  final BoxFit fit;

  const FractalImage(
    this.file, {
    this.fit = BoxFit.fitHeight,
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

  static Future<ImageF> rotate(FileF file, [num deg = 90]) async {
    final b = await file.load();

    final srcImg = Img.decodeImage(b)!;

    final newImg = Img.copyRotate(srcImg, angle: deg);
    final newB = Img.encodeJpg(newImg);
    return ImageF.bytes(newB);
  }

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
  }

  @override
  void dispose() {
    //image.
    super.dispose();
  }

  Future<Image> get img async {
    if (image != null) return image!;
    final bytes = await widget.file.load();
    return image = Image.memory(
      bytes,
      fit: widget.fit,
    );
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
    return FutureBuilder(
      future: img,
      builder: (ctx, snap) => snap.data ?? const CircularProgressIndicator(),
    );
  }
}
