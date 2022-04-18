import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:signaturesample/presentation/ui/signature_preview_screen.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({Key? key}) : super(key: key);

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  late SignatureController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Signature Sample'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Signature(controller: controller, height: MediaQuery.of(context).size.height / 1.23, backgroundColor: Colors.white,),
            _buttonCheckClear(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _buttonCheckClear() {
    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buttonCheck(),
          _buttonClear()
      ],),
    );
  }

  _buttonCheck() {
    return IconButton(
      iconSize: 36,
      icon: const Icon(Icons.check, color: Colors.green),
      onPressed: () async {
        if (controller.isNotEmpty) {
          final signature = await exportSignature();
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SignaturePreviewScreen(signature: signature),
          ));
          controller.clear();
        }
      },
    );
  }

  _buttonClear() {
    return IconButton(
      iconSize: 36,
      icon: const Icon(Icons.clear, color: Colors.red),
      onPressed: () => controller.clear(),
    );
  }

  Future<Uint8List?> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      points: controller.points,
    );

    final signature = await exportController.toPngBytes();
    exportController.dispose();

    return signature;
  }
}
