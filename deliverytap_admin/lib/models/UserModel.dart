import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';

class UserModel {
  String? uid;
  String? name;
  String? email;
  String? password;
  String? loginType;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isAdmin;
  String? role;
  String? photoUrl;
  int? type;
  bool? isDeleted;
  bool? isTester;
  bool? availabilityStatus;
  String? oneSignalPlayerId;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.password,
    this.loginType,
    this.createdAt,
    this.updatedAt,
    this.isAdmin,
    this.role,
    this.photoUrl,
    this.type,
    this.isDeleted,
    this.isTester,
    this.availabilityStatus,
    this.oneSignalPlayerId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json[UserKeys.uid],
      name: json[UserKeys.name],
      email: json[UserKeys.email],
      password: json[UserKeys.password],
      loginType: json[UserKeys.loginType],
      isAdmin: json[UserKeys.isAdmin],
      role: json[UserKeys.role],
      type: json[UserKeys.type],
      photoUrl: json[UserKeys.photoUrl],
      createdAt: json[TimeDataKey.createdAt] != null ? (json[TimeDataKey.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[TimeDataKey.updatedAt] != null ? (json[TimeDataKey.updatedAt] as Timestamp).toDate() : null,
      isDeleted: json[UserKeys.isDeleted],
      isTester: json[UserKeys.isTester],
      availabilityStatus: json[UserKeys.availabilityStatus],
      oneSignalPlayerId: json[UserKeys.oneSignalPlayerId],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[UserKeys.uid] = this.uid;
    data[UserKeys.name] = this.name;
    data[UserKeys.email] = this.email;
    data[UserKeys.photoUrl] = this.photoUrl;
    data[UserKeys.password] = this.password;
    data[UserKeys.loginType] = this.loginType;
    data[UserKeys.isAdmin] = this.isAdmin;
    data[UserKeys.role] = this.role;
    data[UserKeys.type] = this.type;
    data[TimeDataKey.createdAt] = this.createdAt;
    data[TimeDataKey.updatedAt] = this.updatedAt;
    data[UserKeys.oneSignalPlayerId] = this.oneSignalPlayerId;
    data[UserKeys.isDeleted] = this.isDeleted;
    data[UserKeys.isTester] = this.isTester;
    data[UserKeys.availabilityStatus] = this.availabilityStatus;
    return data;
  }
}
