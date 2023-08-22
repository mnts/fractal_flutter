import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fractal/lib.dart';
import 'package:fractal/types/file.dart';
import 'package:url_launcher/url_launcher.dart';

class FractalImage extends StatefulWidget {
  final String hash;
  const FractalImage(
    this.hash, {
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

  static Future<FileF?> pick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    final bytes = result?.files.first.bytes;
    if (bytes == null) return null;
    //result?.files.first.

    return FileF.bytes(bytes);

    //final hash = await FData.publish(bytes);

    //final hash = sha256.convert(_image);
    //return await upload(bytes);
  }
}

class _FractalImageState extends State<FractalImage> {
  FileF? file;
  String get hash => widget.hash.trim();
  Image? image;

  initImage() async {
    if (hash.isEmpty) return;
    file = FileF(hash);
    setState(() async {
      final bytes = await file!.load();
      image = Image.memory(bytes);
    });
  }

  Uri getUri() {
    final uri = Uri.parse(hash);
    if (uri.scheme.isEmpty) {
      return Uri.parse(
        FileF.urlImage(hash),
      );
    }
    return uri;
  }

  openFile() {
    //if (widget.event == null || widget.event!.file.isEmpty) return;
    final uri = getUri();
    launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onSecondaryTap: openFile,
      onLongPress: openFile,
      onTap: openFile,
      child: image ?? const CircularProgressIndicator(),
    );
  }
}
