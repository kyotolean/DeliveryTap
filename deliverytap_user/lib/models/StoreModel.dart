import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';

class StoreModel {
  String? id;
  String? storeName;
  String? categoryId;
  String? photoUrl;
  String? openTime;
  String? closeTime;
  String? storeAddress;
  String? storeContact;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isDealOfTheDay;
  String? couponCode;
  String? couponDesc;
  List<String>? caseSearch;
  String? storeDesc;
  List<String>? catList;
  String? storeCity;
  int?deliveryCharge;

  StoreModel({
    this.storeName,
    this.id,
    this.photoUrl,
    this.openTime,
    this.closeTime,
    this.storeAddress,
    this.storeContact,
    this.createdAt,
    this.updatedAt,
    this.isDealOfTheDay,
    this.couponCode,
    this.couponDesc,
    this.caseSearch,
    this.storeDesc,
    this.catList,
    this.storeCity,
    this.deliveryCharge,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json[CommonKeys.id],
      storeName: json[StoreKeys.storeName],
      photoUrl: json[StoreKeys.photoUrl],
      openTime: json[StoreKeys.openTime],
      closeTime: json[StoreKeys.closeTime],
      storeAddress: json[StoreKeys.storeAddress],
      storeContact: json[StoreKeys.storeContact],
      isDealOfTheDay: json[StoreKeys.isDealOfTheDay],
      couponCode: json[StoreKeys.couponCode],
      couponDesc: json[StoreKeys.couponDesc],
      caseSearch: json[StoreKeys.caseSearch] != null ? List<String>.from(json[StoreKeys.caseSearch]) : [],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
      storeDesc: json[StoreKeys.storeDesc],
      catList: json[StoreKeys.catList] != null ? List<String>.from(json[StoreKeys.catList]) : [],
      storeCity: json[StoreKeys.storeCity],
      deliveryCharge: json[StoreKeys.deliveryCharge],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[StoreKeys.storeName] = this.storeName;
    data[StoreKeys.photoUrl] = this.photoUrl;
    data[StoreKeys.openTime] = this.openTime;
    data[StoreKeys.closeTime] = this.closeTime;
    data[StoreKeys.storeAddress] = this.storeAddress;
    data[StoreKeys.storeContact] = this.storeContact;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[StoreKeys.isDealOfTheDay] = this.isDealOfTheDay;
    data[StoreKeys.couponCode] = this.couponCode;
    data[StoreKeys.couponDesc] = this.couponDesc;
    data[StoreKeys.caseSearch] = this.caseSearch;
    data[StoreKeys.storeDesc] = this.storeDesc;
    data[StoreKeys.catList] = this.catList;
    data[StoreKeys.storeCity] = this.storeCity;
    data[StoreKeys.deliveryCharge] = this.deliveryCharge;
    return data;
  }
}
