import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:page_transition/page_transition.dart';

import 'barcode_details_screen.dart';
import 'components/dynamic_button.dart';
import 'components/my_button.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key? key,
    required this.selectedCategory,
    required this.selectedNetworkType,
    required this.row,
    required this.containment,
    required this.rack,
    required this.partNumber,
    required this.model,
    required this.vendor,
    required this.description,
    this.startDate,
    this.endDate,
    required this.powerConsumption,
    required this.comment,
    required this.selectedSubCategory,
  }) : super(key: key);

  final String selectedCategory;
  final String selectedSubCategory;
  final String selectedNetworkType;
  final String row;
  final String containment;
  final String rack;
  final String partNumber;
  final String model;
  final String vendor;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String powerConsumption;
  final String comment;

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: DynamicButton(
                          onTap: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return Text(
                              'Flash: ${snapshot.data}',
                              style: const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: DynamicButton(
                          onTap: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return Text(
                                'Camera facing ${describeEnum(snapshot.data!)}',
                                style: const TextStyle(color: Colors.white),
                              );
                            } else {
                              return const Text(
                                'loading',
                                style: TextStyle(color: Colors.white),
                              );
                            }
                          },
                          future: controller?.getCameraInfo(),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: MyButton(
                          onTap: () async {
                            await controller?.pauseCamera();
                          },
                          title: 'pause',
                          paddingNum: 20,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: MyButton(
                          onTap: () async {
                            await controller?.resumeCamera();
                          },
                          title: 'resume',
                          paddingNum: 20,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanWidth = MediaQuery.of(context).size.width;
    var scanHeight = MediaQuery.of(context).size.height * 0.11;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutHeight: scanHeight,
        cutOutWidth: scanWidth,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  bool _isNavigated = false;

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (result != null && !_isNavigated) {
        _isNavigated = true;

        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: BarcodeDetailsPage(
              barcode: result!.code!,
              category: widget.selectedCategory,
              deviceScannedTime: DateTime.now(),
              network: widget.selectedNetworkType,
              row: widget.row,
              containment: widget.containment,
              rack: widget.rack,
              partNumber: widget.partNumber,
              model: widget.model,
              vendor: widget.vendor,
              description: widget.description,
              startDate: widget.startDate,
              endDate: widget.endDate,
              powerConsumption: widget.powerConsumption,
              comment: widget.comment,
              subCategory: widget.selectedSubCategory,
            ),
          ),
        ).then((value) {
          _isNavigated = false;
          Navigator.pop(context, true); // Signal to clear fields
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
