import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_user/models/AddressModel.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? photoUrl;
  String? number;
  String? password;
  String? loginType;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isAdmin;
  bool? isTester;
  List<AddressModel>? listOfAddress;
  String? role;
  String? city;
  bool? isDeleted;
  String? oneSignalPlayerId;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.photoUrl,
    this.number,
    this.password,
    this.loginType,
    this.createdAt,
    this.updatedAt,
    this.isAdmin,
    this.isTester,
    this.listOfAddress,
    this.role,
    this.city,
    this.isDeleted,
    this.oneSignalPlayerId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json[UserKeys.uid],
      name: json[UserKeys.name],
      email: json[UserKeys.email],
      photoUrl: json[UserKeys.photoUrl],
      isAdmin: json[UserKeys.isAdmin],
      isTester: json[UserKeys.isTester],
      number: json[UserKeys.number],
      password: json[UserKeys.password],
      loginType: json[UserKeys.loginType],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
      listOfAddress: json[UserKeys.listOfAddress] != null ? (json[UserKeys.listOfAddress] as List).map<AddressModel>((e) => AddressModel.fromJson(e)).toList() : null,
      role: json[UserKeys.role],
      city: json[UserKeys.city],
      isDeleted: json[CommonKeys.isDeleted],
      oneSignalPlayerId: json[UserKeys.oneSignalPlayerId],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[UserKeys.uid] = this.uid;
    data[UserKeys.name] = this.name;
    data[UserKeys.email] = this.email;
    data[UserKeys.photoUrl] = this.photoUrl;
    data[UserKeys.loginType] = this.loginType;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[UserKeys.isAdmin] = this.isAdmin;
    data[UserKeys.isTester] = this.isTester;
    data[UserKeys.number] = this.number;
    data[UserKeys.password] = this.password;
    data[UserKeys.listOfAddress] = this.listOfAddress!.map((e) => e.toJson()).toList();
    data[UserKeys.role] = this.role;
    data[UserKeys.city] = this.city;
    data[CommonKeys.isDeleted] = this.isDeleted;
    data[UserKeys.oneSignalPlayerId] = this.oneSignalPlayerId;

    return data;
  }
}