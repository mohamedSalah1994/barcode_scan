
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class BarcodeModel extends HiveObject {
  @HiveField(0)
  final String deviceSerial;

  @HiveField(1)
  final String deviceStatus;

  @HiveField(2)
  final String? deviceImage;

  @HiveField(3)
  final String? deviceScannedTime;

  @HiveField(4)
  final int? userId;

  @HiveField(5)
  final int deviceCategoryId;

  @HiveField(6)
  final int networkTypeId;

  @HiveField(7)
  final String? row;

  @HiveField(8)
  final String? containment;

  @HiveField(9)
  final String? rack;
  @HiveField(10)
  final String? partNumber;
  @HiveField(11)
  final String? model;
  @HiveField(12)
  final String? vendor;
  @HiveField(13)
  final String? description;
  @HiveField(14)
  final String? startDate;
  @HiveField(15)
  final String? endDate;
  @HiveField(16)
  final String? powerConsumption;
  @HiveField(17)
  final String? 
  comment;
  @HiveField(18)
  final int? deviceSubCategoryId;

  BarcodeModel(
   {
    required this.deviceSerial,
    required this.deviceStatus,
    required this.deviceImage,
    required this.deviceScannedTime,
    required this.userId,
    required this.deviceCategoryId,
    required this.networkTypeId,
    required this.row,
    required this.containment,
    required this.rack,
    required this.partNumber,
    required this.model,
    required this.vendor,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.powerConsumption,
    required this.deviceSubCategoryId,
    required this.comment, 
  });

Map<String, dynamic> toJson() {
  return {
    'Device_serial': deviceSerial,
    'Device_Status': deviceStatus,
    'Device_Image': deviceImage,
    'Device_Scanned_Time': deviceScannedTime,
    'User_ID': userId,
    'Device_Category_ID': deviceCategoryId,
    'Device_Network_ID': networkTypeId,
    'Device_row': row,
    'Device_containment': containment,
    'Device_rack': rack,
    'Part_num': partNumber,
    'Model': model,
    'Vendor': vendor,
    'Decs': description,
    'Start_Date': startDate,
    'End_Date': endDate,
    'Power_cons': powerConsumption,
    'Comment': comment,
    'Device_Sub_Category_ID': deviceSubCategoryId,
  };
}
}
