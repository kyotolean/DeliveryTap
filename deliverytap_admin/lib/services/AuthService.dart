import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:deliverytap_admin/models/UserModel.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUpWithEmailPassword({required String email, required String password, String? displayName, String? photoUrl, String? role}) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) async {
      /// Create User
      UserModel userModel = UserModel();

      userModel.uid = value.user!.uid.validate();
      userModel.email = value.user!.email.validate();
      userModel.name = displayName.validate();
      userModel.photoUrl = photoUrl.validate();
      userModel.loginType = LoginTypeApp;
      userModel.password = password;
      userModel.role = role ?? '';
      userModel.isAdmin = false;
      userModel.isTester = false;
      userModel.isDeleted = false;
      userModel.oneSignalPlayerId = getStringAsync(PLAYER_ID);
      userModel.createdAt = DateTime.now();
      userModel.updatedAt = DateTime.now();

      await userService.addDocumentWithCustomId(value.user!.uid, userModel.toJson()).then((res) async {
        await signInWithEmailPassword(email: value.user!.email!, password: password, displayName: displayName, photoUrl: photoUrl, role: role);
      }).catchError((e) {
        throw e;
      });
    }).catchError((error) {
      log(error);
      throw error.toString();
    });
  }

  Future<void> signInWithEmailPassword({required String email, required String password, String? displayName, String? photoUrl, String? role}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
      if (await userService.isUserExist(value.user!.email, LoginTypeApp)) {
        await userService.userByEmail(email).then((user) async {
          if (user.role == ADMIN || user.role == REST_MANAGER) {
            await setUserDetailPreference(user);

            await userService.updateDocument({
              TimeDataKey.updatedAt: DateTime.now(),
            }, user.uid);
          } else {
            throw '${"You are already registered with"}${user.role}';
          }
        }).catchError((e) {
          log(e.toString());
          throw e;
        });
      } else {
        throw "You are not registered with us";
      }
    }).catchError((error) async {
      if (!await isNetworkAvailable()) {
        throw "Please check network connection";
      }
      log(error.toString());
      throw "Enter valid email and password";
    });
  }

  Future<void> signOutFromEmailPassword(BuildContext context) async {
    await removeKey(USER_NAME);
    await removeKey(USER_EMAIL);
    await removeKey(USER_IMAGE);
    await removeKey(IS_LOGGED_IN);
    await removeKey(LOGIN_TYPE);
    await removeKey(USER_PASSWORD);

    await removeKey(PLAYER_ID);
    await removeKey(IS_TESTER);

    appStore.setLoggedIn(false);

  }

  Future<void> setUserDetailPreference(UserModel user) async {
    await setValue(USER_ID, user.uid.validate());
    await setValue(USER_NAME, user.name);
    await setValue(USER_EMAIL, user.email);
    await setValue(USER_IMAGE, user.photoUrl.validate());
    await setValue(LOGIN_TYPE, user.loginType.validate());
    await setValue(IS_ADMIN, user.isAdmin.validate());
    await setValue(IS_TESTER, user.isTester.validate());
  }

  Future<void> forgotPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      //
    }).catchError((error) {
      throw error.toString();
    });
  }

  Future<void> resetPassword({required String newPassword}) async {
    await _auth.currentUser!.updatePassword(newPassword).then((value) {
      //
    }).catchError((error) {
      throw error.toString();
    });
  }
}
