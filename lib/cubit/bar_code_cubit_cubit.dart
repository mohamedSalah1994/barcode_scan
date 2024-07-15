import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../models/barcode_model.dart';
import 'bar_code_cubit_state.dart';

class BarcodeCubit extends Cubit<BarcodeState> {
  BarcodeCubit() : super(BarcodeLoading());

  Future<void> getAllSavedData() async {
    try {
      final box = await Hive.openBox<BarcodeModel>('barcodes');
      final List<BarcodeModel> allData = box.values.toList();
      emit(BarcodeLoaded(allData));
    } catch (e) {
      emit(BarcodeError('Failed to fetch data: $e'));
    }
  }

  Future<void> addData(BarcodeModel data) async {
    try {
      final box = await Hive.openBox<BarcodeModel>('barcodes');
      await box.add(data);
      getAllSavedData();
    } catch (e) {
      emit(BarcodeError('Failed to add data: $e'));
    }
  }

  Future<void> deleteData(BarcodeModel data) async {
    try {
      final box = await Hive.openBox<BarcodeModel>('barcodes');
      await box.delete(data.key);
      getAllSavedData();
    } catch (e) {
      emit(BarcodeError('Failed to delete data: $e'));
    }
  }
}
