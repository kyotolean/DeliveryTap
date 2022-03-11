import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_delivery/utils/ModelKey.dart';

class UserModel {
  String? uid;
  String? photoUrl;
  String? name;
  int? type;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? role;
  String? address;
  String? number;
  String? loginType;
  String? city;
  bool? isDeleted;
  String? oneSignalPlayerId;
  bool? isTester;
  bool? availabilityStatus;

  UserModel({
    this.photoUrl,
    this.name,
    this.type,
    this.uid,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.address,
    this.number,
    this.loginType,
    this.city,
    this.isDeleted = false,
    this.oneSignalPlayerId,
    this.isTester,
    this.availabilityStatus = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        photoUrl: json[UserKey.photoUrl],
        name: json[UserKey.name],
        type: json[UserKey.type],
        uid: json[UserKey.uid],
        email: json[UserKey.email],
        role: json[UserKey.role],
        address: json[UserKey.address],
        number: json[UserKey.number],
        loginType: json[UserKey.loginType],
        city: json[UserKey.city],
        isDeleted: json[UserKey.isDeleted],
        oneSignalPlayerId: json[UserKey.oneSignalPlayerId],
        isTester: json[UserKey.isTester],
        availabilityStatus: json[UserKey.availabilityStatus],
        createdAt: json[CommonKey.createdAt] != null ? (json[CommonKey.createdAt] as Timestamp).toDate() : null,
        updatedAt: json[CommonKey.updatedAt] != null ? (json[CommonKey.updatedAt] as Timestamp).toDate() : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[UserKey.name] = this.name;
    data[UserKey.type] = this.type;
    data[UserKey.uid] = this.uid;
    data[UserKey.email] = this.email;
    data[UserKey.role] = this.role;
    data[CommonKey.createdAt] = this.createdAt;
    data[CommonKey.updatedAt] = this.updatedAt;
    data[UserKey.address] = this.address;
    data[UserKey.number] = this.number;
    data[UserKey.photoUrl] = this.photoUrl;
    data[UserKey.loginType] = this.loginType;
    data[UserKey.city] = this.city;
    data[UserKey.isDeleted] = this.isDeleted;
    data[UserKey.oneSignalPlayerId] = this.oneSignalPlayerId;
    data[UserKey.isTester] = this.isTester;
    data[UserKey.availabilityStatus] = this.availabilityStatus;
    return data;
  }
}
