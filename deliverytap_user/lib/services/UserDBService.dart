import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/models/UserModel.dart';
import 'package:deliverytap_user/services/BaseService.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';

class UserDBService extends BaseService {
  UserDBService() {
    ref = db.collection(USERS);
  }

  Stream<UserModel> userById(String? id) {
    return ref.where(UserKeys.uid, isEqualTo: id).snapshots().map((value) {
      if (value.docs.isNotEmpty) {
        return UserModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw "No User Found";
      }
    });
  }

  Future<UserModel> getUserById(String? id) async {
    return await ref.where(UserKeys.uid, isEqualTo: id).get().then((value) {
      if (value.docs.isNotEmpty) {
        return UserModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw "No User Found";
      }
    });
  }

  Future<List<UserModel>> usersFuture() async {
    return await ref.orderBy(CommonKeys.updatedAt, descending: true)
        .get()
        .then((x) =>
        x.docs.map((y) => UserModel.fromJson(y.data() as Map<String, dynamic>))
            .toList());
  }

  Future<bool> isUserExist(String? email, String loginType) async {
    Query query = ref.where(UserKeys.loginType, isEqualTo: loginType).where(
        UserKeys.email, isEqualTo: email);

    var res = await query.limit(1).get();

    if (res.docs.isNotEmpty) {
      return res.docs.length == 1;
    } else {
      return false;
    }
  }

  Future<UserModel> loginWithEmail({String? email, String? password}) async {
    return await ref.where(UserKeys.email, isEqualTo: email).limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        UserModel user = UserModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>);
        if (!user.isDeleted!) {
          return user;
        } else {
          throw "Please Contact to Admin";
        }
      } else {
        throw "No User Found";
      }
    });
  }

  Future<UserModel> getUserByEmail(String? email) async {
    return await ref.where(UserKeys.email, isEqualTo: email).limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        UserModel user = UserModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>);
        if (!user.isDeleted!) {
          return user;
        } else {
          throw "Please Contact to Admin";
        }
      } else {
        throw "No User Found";
      }
    });
  }
}