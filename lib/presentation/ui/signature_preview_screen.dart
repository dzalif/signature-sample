import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class SignaturePreviewScreen extends StatefulWidget {
  final Uint8List? signature;

  const SignaturePreviewScreen({Key? key, required this.signature})
      : super(key: key);

  @override
  State<SignaturePreviewScreen> createState() => _SignaturePreviewScreenState();
}

class _SignaturePreviewScreenState extends State<SignaturePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Signature'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () => saveSignature(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Image.memory(widget.signature!, width: double.infinity),
      ),
    );
  }

  saveSignature(BuildContext context) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = 'signature_$time.png';

    final result = await ImageGallerySaver.saveImage(widget.signature!, name: name);
    final isSuccess = result['isSuccess'];

    if (isSuccess) {
      Navigator.pop(context);
      String message = 'Successfully saved signature';
      _showSnackBar(message, context);
    } else {
      String message = 'Failed to save signature';
      _showSnackBar(message, context);
    }
  }

  void _showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
