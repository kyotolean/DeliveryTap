import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_admin/models/UserModel.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';

import '../main.dart';
import 'BaseService.dart';

class UserService extends BaseService {
  UserService() {
    ref = db.collection(Collect.users);
  }

  Stream<List<UserModel>> getAllUsers({String role = '', bool isDash = false}) {
    Query? query;
    if (isDash) {
      query = ref!.limit(10);
    } else if (role.isEmpty) {
      query = ref;
    } else {
      query = ref!.where(UserKeys.role, isEqualTo: role);
    }

    return query!
        .orderBy(TimeDataKey.updatedAt, descending: true)
        .orderBy(UserKeys.isDeleted, descending: false)
        .snapshots()
        .map((event) => event.docs.map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }

  Stream<List<UserModel>> users() {
    return ref!.orderBy('updatedAt', descending: true).snapshots().map((x) => x.docs.map((y) => UserModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  Stream<int> totalUsersCount() {
    return ref!.orderBy('updatedAt', descending: true).snapshots().map((x) => x.docs.length);
  }

  Future<List<UserModel>> usersFuture() async {
    return await ref!.orderBy('updatedAt', descending: true).get().then((x) => x.docs.map((y) => UserModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  Future<bool> isUserExist(String? email, String loginType) async {
    Query query = ref!.limit(1).where('loginType', isEqualTo: loginType).where('email', isEqualTo: email);

    var res = await query.get();

    if (res.docs.isNotEmpty) {
      return res.docs.length == 1;
    } else {
      return false;
    }
  }

  Future<UserModel> loginWithEmail(String email, String password) async {
    return await ref!.where('email', isEqualTo: email).where('password', isEqualTo: password).limit(1).get().then((value) {
      if (value.docs.isNotEmpty) {
        return UserModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'No User Found';
      }
    });
  }

  Future<UserModel> userByEmail(String email) async {
    return await ref!.where('email', isEqualTo: email).limit(1).get().then((value) {
      if (value.docs.isNotEmpty) {
        return UserModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'No User Found';
      }
    });
  }

  Future<UserModel> getUserById({String? userId}) async {
    return ref!.where(UserKeys.uid, isEqualTo: userId).get().then((value) {
      if (value.docs.isNotEmpty) {
        return UserModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'Data not found';
      }
    });
  }
}
