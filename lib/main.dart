import 'package:barcode_scan/core/helper_functions/in_generate_routes.dart';
import 'package:barcode_scan/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'models/barcode_model.dart';
import 'models/barcode_model.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(BarcodeModelAdapter()); // Register adapter for BarcodeModel
  await Hive.openBox<BarcodeModel>('barcodes'); // Open the Hive box
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[300],
        useMaterial3: true,
      ),
      onGenerateRoute: onGenerateRoute,
      initialRoute: LoginPage.routeName,
    );
  }
}


