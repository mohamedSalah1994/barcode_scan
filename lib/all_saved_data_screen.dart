// all_saved_data_screen.dart

import 'dart:convert';
import 'dart:io';
import 'package:barcode_scan/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'components/my_button.dart';
import 'models/barcode_model.dart';

class AllSavedDataScreen extends StatefulWidget {
  const AllSavedDataScreen({Key? key}) : super(key: key);

  @override
  State<AllSavedDataScreen> createState() => _AllSavedDataScreenState();
}

class _AllSavedDataScreenState extends State<AllSavedDataScreen> {
  final Map<int, String> _categories = {
    1: 'Network',
    2: 'Server',
    3: 'Storage',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Data'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FutureBuilder<Box<BarcodeModel>>(
              future: _getAllSavedData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final savedData = snapshot.data!.values.toList();
                  final groupedData = _groupDataByCategory(savedData);
                  return ListView.builder(
                    itemCount: groupedData.length,
                    itemBuilder: (context, index) {
                      final categoryData = groupedData[index];
                      return ExpansionTile(
                        title: Text(
                          '${_categories[categoryData.category] ?? 'Unknown'} (${categoryData.items.length})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: categoryData.items.map((data) {
                          return Dismissible(
                            key: Key(data.deviceSerial),
                            onDismissed: (direction) {
                              _deleteData(data);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: ListTile(
                              title: Text(data.deviceSerial),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: MyButton(
              onTap: () => FileStorage.saveAllSavedDataToJson(context),
              title: 'Save Data',
            ),
          ),
        ],
      ),
    );
  }

  Future<Box<BarcodeModel>> _getAllSavedData() async {
    final box = await Hive.openBox<BarcodeModel>('barcodes');
    return box;
  }

  void _deleteData(BarcodeModel data) async {
    final box = await Hive.openBox<BarcodeModel>('barcodes');
    box.delete(data.key);
  }

  List<CategoryData> _groupDataByCategory(List<BarcodeModel> data) {
    final groupedData = <CategoryData>[];
    final categories = data.map((e) => e.deviceCategoryId).toSet();
    for (final category in categories) {
      final items = data.where((e) => e.deviceCategoryId == category).toList();
      groupedData.add(CategoryData(category: category, items: items));
    }
    return groupedData;
  }
}

class CategoryData {
  final int category;
  final List<BarcodeModel> items;

  CategoryData({required this.category, required this.items});
}

class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/Documents");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;

    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(String bytes, String name) async {
    final path = await _localPath;
    File file = File('$path/$name');

    return file.writeAsString(bytes);
  }

  static Future<void> saveAllSavedDataToJson(BuildContext context) async {
    final box = await Hive.openBox<BarcodeModel>('barcodes');
    final savedData = box.values.toList();

    final jsonData = savedData.map((item) => item.toJson()).toList();
    final jsonString = json.encode(jsonData);

    final status = await Permission.storage.status;

    if (!status.isGranted) {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission is required to save data'),
          ),
        );
        return;
      }
    }

    final path = await _localPath;
    final fileName = "saved_data_${DateTime.now().millisecondsSinceEpoch}.json";
    final file = File('$path/$fileName');

    try {
      await file.writeAsString(jsonString);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data saved successfully'),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context , HomeScreen.routeName);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save data: $e'),
        ),
      );
    }
  }
}
