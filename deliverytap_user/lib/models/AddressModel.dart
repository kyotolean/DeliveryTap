import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';

class AddressModel {
  String? address;
  String? otherDetails;
  GeoPoint? userLocation;

  AddressModel({this.address, this.otherDetails, this.userLocation});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      address: json[AddressKeys.address],
      otherDetails: json[AddressKeys.details],
      userLocation: json[AddressKeys.userLocation],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[AddressKeys.address] = this.address;
    data[AddressKeys.details] = this.otherDetails;
    data[AddressKeys.userLocation] = this.userLocation;

    return data;
  }
}