import '../models/barcode_model.dart';

abstract class BarcodeState {}

class BarcodeLoading extends BarcodeState {}

class BarcodeLoaded extends BarcodeState {
  final List<BarcodeModel> barcodes;

  BarcodeLoaded(this.barcodes);
}

class BarcodeError extends BarcodeState {
  final String message;

  BarcodeError(this.message);
}
