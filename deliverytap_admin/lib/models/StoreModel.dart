import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';

class StoreModel {
  String? id;
  String? storeName;
  String? storeEmail;
  String? storeDesc;
  String? photoUrl;
  String? openTime;
  String? closeTime;
  String? storeAddress;
  String? storeState;
  String? storeCity;
  GeoPoint? storeLatLng;
  String? storeContact;
  bool? isDealOfTheDay;
  String? couponCode;
  String? couponDesc;
  List<String>? caseSearch;
  List<String?>? catList;
  String? ownerId;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isDeleted;
  int?deliveryCharge;

  StoreModel({
    this.id,
    this.storeName,
    this.storeEmail,
    this.storeDesc,
    this.photoUrl,
    this.openTime,
    this.closeTime,
    this.storeAddress,
    this.storeState,
    this.storeCity,
    this.storeLatLng,
    this.storeContact,
    this.isDealOfTheDay,
    this.couponCode,
    this.couponDesc,
    this.caseSearch,
    this.catList,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deliveryCharge,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json[StoreKey.id],
      storeName: json[StoreKey.storeName],
      storeEmail: json[StoreKey.storeEmail],
      storeDesc: json[StoreKey.storeDesc],
      photoUrl: json[StoreKey.photoUrl],
      openTime: json[StoreKey.openTime],
      closeTime: json[StoreKey.closeTime],
      storeAddress: json[StoreKey.storeAddress],
      storeState: json[StoreKey.storeState],
      storeCity: json[StoreKey.storeCity],
      storeLatLng: json[StoreKey.storeLatLng],
      storeContact: json[StoreKey.storeContact],
      isDealOfTheDay: json[StoreKey.isDealOfTheDay],
      couponCode: json[StoreKey.couponCode],
      couponDesc: json[StoreKey.couponDesc],
      caseSearch: json[StoreKey.caseSearch] != null ? List<String>.from(json[StoreKey.caseSearch]) : [],
      catList: json[StoreKey.catList] != null ? List<String>.from(json[StoreKey.catList]) : [],
      ownerId: json[StoreKey.ownerId],
      createdAt: json[TimeDataKey.createdAt] != null ? (json[TimeDataKey.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[TimeDataKey.updatedAt] != null ? (json[TimeDataKey.updatedAt] as Timestamp).toDate() : null,
      isDeleted: json[StoreKey.isDeleted],
      deliveryCharge: json[StoreKey.deliveryCharge],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[StoreKey.id] = this.id;
    data[StoreKey.storeName] = this.storeName;
    data[StoreKey.storeEmail] = this.storeEmail;
    data[StoreKey.storeDesc] = this.storeDesc;
    data[StoreKey.photoUrl] = this.photoUrl;
    data[StoreKey.openTime] = this.openTime;
    data[StoreKey.closeTime] = this.closeTime;
    data[StoreKey.storeAddress] = this.storeAddress;
    data[StoreKey.storeState] = this.storeState;
    data[StoreKey.storeCity] = this.storeCity;
    data[StoreKey.storeLatLng] = this.storeLatLng;
    data[StoreKey.storeContact] = this.storeContact;
    data[StoreKey.isDealOfTheDay] = this.isDealOfTheDay;
    data[StoreKey.couponCode] = this.couponCode;
    data[StoreKey.couponDesc] = this.couponDesc;
    data[StoreKey.caseSearch] = this.caseSearch;
    data[StoreKey.catList] = this.catList;
    data[StoreKey.ownerId] = this.ownerId;
    data[TimeDataKey.createdAt] = this.createdAt;
    data[TimeDataKey.updatedAt] = this.updatedAt;
    data[StoreKey.isDeleted] = this.isDeleted;
    data[StoreKey.deliveryCharge] = this.deliveryCharge;

    return data;
  }
}
