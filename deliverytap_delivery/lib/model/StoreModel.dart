import 'package:deliverytap_delivery/utils/ModelKey.dart';

class StoreModel {
  String? id;
  String? storeAddress;
  String? photoUrl;
  String? storeName;
  String? storeContact;

  StoreModel({this.storeAddress, this.photoUrl, this.storeName, this.storeContact, this.id});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json[CommonKey.id],
      storeAddress: json[StoreKey.storeAddress],
      photoUrl: json[StoreKey.photoUrl],
      storeName: json[StoreKey.storeName],
      storeContact: json[StoreKey.storeContact],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKey.id] = this.id;
    data[StoreKey.storeAddress] = this.storeAddress;
    data[StoreKey.photoUrl] = this.photoUrl;
    data[StoreKey.storeName] = this.storeName;
    data[StoreKey.storeContact] = this.storeContact;

    return data;
  }
}
