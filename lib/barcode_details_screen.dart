import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'components/details_item.dart';
import 'components/my_button.dart';
import 'models/barcode_model.dart';

class BarcodeDetailsPage extends StatefulWidget {
  final String category;
  final String subCategory;
  final String network;
  final String barcode;
  final String row;
  final String containment;
  final String rack;
  final DateTime deviceScannedTime;
  final String partNumber;
  final String model;
  final String vendor;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String powerConsumption;
  final String comment;

  const BarcodeDetailsPage({
    Key? key,
    required this.category,
    required this.barcode,
    required this.deviceScannedTime,
    required this.network,
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
    required this.subCategory,
  }) : super(key: key);

  @override
  State<BarcodeDetailsPage> createState() => _BarcodeDetailsPageState();
}

class _BarcodeDetailsPageState extends State<BarcodeDetailsPage> {
  String _deviceStatus = "Active";

  final Map<String, int> _categoryMap = {
    'Network': 1,
    'Server': 2,
    'Storage': 3,
  };
  final Map<String, int> _subCategoryMap = {
    'a': 1,
    'b': 2,
    'c': 3,
  };
  final Map<String, int> _networkMap = {
    'M': 1,
    'p': 2,
    'G': 3,
  };

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    bool _isBarcodeAlreadyExists(Box<BarcodeModel> box, String barcode) {
      return box.values.any((element) => element.deviceSerial == barcode);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Details'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailsItem(title: 'Barcode: ', value: widget.barcode),
                  const SizedBox(height: 10),
                  DetailsItem(title: 'Category: ', value: widget.category),
                  const SizedBox(height: 10),
                  DetailsItem(title: 'Sub Category: ', value: widget.subCategory),
                  const SizedBox(height: 10),
                  DetailsItem(title: 'Network: ', value: widget.network),
                  const SizedBox(height: 10),
                  DetailsItem(title: 'Row: ', value: widget.row),
                  const SizedBox(height: 10),
                  DetailsItem(
                      title: 'Containment: ', value: widget.containment),
                  const SizedBox(height: 10),
                  DetailsItem(title: 'Rack: ', value: widget.rack),
                  const SizedBox(height: 10),
                  DetailsItem(title: 'Part Number: ', value: widget.partNumber),
                  const SizedBox(height: 10),
                  DetailsItem(title: 'Model: ', value: widget.model),
                  const SizedBox(height: 10),
                  DetailsItem(title: 'Vendor: ', value: widget.vendor),
                  const SizedBox(height: 10),
                  DetailsItem(
                      title: 'Description: ', value: widget.description),
                  const SizedBox(height: 10),
                  DetailsItem(
                    title: 'Start Date: ',
                    value: widget.startDate != null
                        ? DateFormat('yyyy-MM-dd').format(widget.startDate!)
                        : 'Not provided',
                  ),
                  const SizedBox(height: 10),
                  DetailsItem(
                    title: 'End Date: ',
                    value: widget.endDate != null
                        ? DateFormat('yyyy-MM-dd').format(widget.endDate!)
                        : 'Not provided',
                  ),
                  const SizedBox(height: 10),
                  DetailsItem(
                    title: 'Power Consumption: ',
                    value: widget.powerConsumption,
                  ),
                  const SizedBox(height: 10),
                  DetailsItem(
                    title: 'Comment: ',
                    value: widget.comment,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Text('Status: '),
                      DropdownButton<String>(
                        value: _deviceStatus,
                        onChanged: (value) {
                          setState(() {
                            _deviceStatus = value!;
                          });
                        },
                        items: <String>['Active', 'Inactive']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            MyButton(
              onTap: () async {
                final box = await Hive.openBox<BarcodeModel>('barcodes');
                if (_isBarcodeAlreadyExists(box, widget.barcode)) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Barcode already exists.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Get category ID from the map
                  final categoryId = _categoryMap[widget.category];
                  final subCategoryId = _subCategoryMap[widget.subCategory];
                  final networkId = _networkMap[widget.network];
                  if (categoryId != null && networkId != null && subCategoryId != null) {
                    await box.add(
                      BarcodeModel(
                        deviceCategoryId: categoryId,
                        deviceScannedTime: widget.deviceScannedTime.toString(),
                        deviceSerial: widget.barcode,
                        deviceImage:
                            '', // You may add image path here if available
                        deviceStatus: _deviceStatus,
                        userId:
                            1, // Assuming user ID is fixed or can be retrieved from somewhere
                        networkTypeId: networkId,
                        containment: widget.containment,
                        rack: widget.rack,
                        row: widget.row,
                        description: widget.description,
                        endDate: widget.endDate.toString(),
                        model: widget.model,
                        partNumber: widget.partNumber,
                        powerConsumption: widget.powerConsumption,
                        startDate: widget.startDate.toString(),
                        vendor: widget.vendor,
                        comment: widget.comment,
                        deviceSubCategoryId: subCategoryId,
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data saved successfully.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid category name.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              title: 'Save to Local',
            ),
          ],
        ),
      ),
    );
  }
}
