import 'package:hive/hive.dart';
import 'barcode_model.dart';

class BarcodeModelAdapter extends TypeAdapter<BarcodeModel> {
  @override
  final int typeId = 0;

  @override
  BarcodeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarcodeModel(
      deviceSerial: fields[0] as String,
      deviceStatus: fields[1] as String,
      deviceImage: fields[2] as String?,
      deviceScannedTime: fields[3] as String?,
      userId: fields[4] as int?,
      deviceCategoryId: fields[5] as int,
      networkTypeId: fields[6] as int,
      row: fields[7] as String?,
      containment: fields[8] as String?,
      rack: fields[9] as String?,
      partNumber: fields[10] as String?,
      model: fields[11] as String?,
      vendor: fields[12] as String?,
      description: fields[13] as String?,
      startDate: fields[14] as String?,
      endDate: fields[15] as String?,
      powerConsumption: fields[16] as String?,
      comment: fields[17] as String?,
      deviceSubCategoryId: fields[18] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, BarcodeModel obj) {
    writer
      ..writeByte(19) // Number of fields in the class
      ..writeByte(0)
      ..write(obj.deviceSerial)
      ..writeByte(1)
      ..write(obj.deviceStatus)
      ..writeByte(2)
      ..write(obj.deviceImage)
      ..writeByte(3)
      ..write(obj.deviceScannedTime)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.deviceCategoryId)
      ..writeByte(6)
      ..write(obj.networkTypeId)
      ..writeByte(7)
      ..write(obj.row)
      ..writeByte(8)
      ..write(obj.containment)
      ..writeByte(9)
      ..write(obj.rack)
      ..writeByte(10)
      ..write(obj.partNumber)
      ..writeByte(11)
      ..write(obj.model)
      ..writeByte(12)
      ..write(obj.vendor)
      ..writeByte(13)
      ..write(obj.description)
      ..writeByte(14)
      ..write(obj.startDate)
      ..writeByte(15)
      ..write(obj.endDate)
      ..writeByte(16)
      ..write(obj.powerConsumption)
      ..writeByte(17)
      ..write(obj.comment)
      ..writeByte(18)
      ..write(obj.deviceSubCategoryId);
  }
}
