import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/barcode_model.dart';

class SavedDataScreen extends StatelessWidget {
  final String deviceCategoryId; // Updated to deviceCategoryId

  const SavedDataScreen({Key? key, required this.deviceCategoryId, required String category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Data - $deviceCategoryId'), // Updated to deviceCategoryId
      ),
      body: Center(
        child: FutureBuilder<List<BarcodeModel>>(
          future: _getSavedData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final savedData = snapshot.data!;
              return ListView.builder(
                itemCount: savedData.length,
                itemBuilder: (context, index) {
                  final item = savedData[index];
                  return ListTile(
                    title: Text(item.deviceSerial),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<BarcodeModel>> _getSavedData() async {
    final box = await Hive.openBox<BarcodeModel>('barcodes');
    final List<BarcodeModel> allData = box.values.toList();
    // ignore: unrelated_type_equality_checks
    final filteredData = allData.where((data) => data.deviceCategoryId == deviceCategoryId).toList(); // Updated to deviceCategoryId
    return filteredData;
  }
}
