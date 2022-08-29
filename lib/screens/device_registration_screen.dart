import 'package:flutter/material.dart';
import 'package:punch_it/screens/home_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:punch_it/repositories/punch_bag_repository.dart';

class DeviceRegistrationScreen extends StatefulWidget {
  const DeviceRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<DeviceRegistrationScreen> createState() =>
      _DeviceRegistrationScreenState();
}

class _DeviceRegistrationScreenState extends State<DeviceRegistrationScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Builder(builder: (context) {
            if (result != null) {
              PunchBagRepository.getInstance().registerDevice(result!.code);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
              );
            }
            return const Expanded(
              flex: 1,
              child: Center(
                child: Text('Scan a code'),
              ),
            );
          })
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
