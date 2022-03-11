import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/model/UserModel.dart';
import 'package:deliverytap_delivery/services/BaseService.dart';
import 'package:deliverytap_delivery/utils/ModelKey.dart';

class UserService extends BaseService {
  UserService() {
    ref = db.collection('users');
  }

  Future<bool> isUserExist(String? email, String loginType) async {
    Query query = ref.limit(1).where(UserKey.loginType, isEqualTo: loginType).where(UserKey.email, isEqualTo: email);

    var res = await query.get();

    return res.docs.length == 1;
  }

  Future<UserModel> getUserByEmail(String? email) {
    return ref.where(UserKey.email, isEqualTo: email).limit(1).get().then((res) {
      if (res.docs.isNotEmpty) {
        return UserModel.fromJson(res.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'User not found';
      }
    });
  }

  Future<UserModel> getUserById({String? userId}) {
    return ref.where(UserKey.uid, isEqualTo: userId).get().then((res) {
      if (res.docs.isNotEmpty) {
        return UserModel.fromJson(res.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'User not found';
      }
    });
  }

  Future<bool> isUserExists(String id) async {
    return await getUserByEmail(id).then((value) {
      return true;
    }).catchError((e) {
      return false;
    });
  }
}
