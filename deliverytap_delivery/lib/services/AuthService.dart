import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/model/UserModel.dart';
import 'package:deliverytap_delivery/utils/Constants.dart';
import 'package:deliverytap_delivery/utils/ModelKey.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> signUpWithEmailPassword({required String email, required String password, String? displayName, String? number}) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) async {
      return await signInWithEmailPassword(email: value.user!.email!, password: password, displayName: displayName, number: number);
    }).catchError((error) {
      throw error.toString();
    });
  }

  Future<UserModel> signInWithEmailPassword({required String email, required String password, String? displayName, String? number}) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
      return await loginFromFirebaseUser(value.user!, LoginTypeApp, fullName: displayName, number: number);
    }).catchError((error) async {
      if (!await isNetworkAvailable()) {
        throw errorInternetNotAvailable;
      }
      log(error.toString());
      throw error.toString();
    });
  }

  Future<UserModel> loginFromFirebaseUser(User currentUser, String loginType, {String? fullName, String? number}) async {
    UserModel userModel = UserModel();

    if (await userService.isUserExist(currentUser.email, loginType)) {
      await userService.getUserByEmail(currentUser.email).then((user) async {
        if (user.role == DELIVERY_BOY) {
          ///Return user data
          userModel = user;
        } else {
          throw 'You are already registered as ${user.role}';
        }
      }).catchError((e) {
        throw e;
      });
    } else {
      /// Create user
      userModel.uid = currentUser.uid;
      userModel.email = currentUser.email;
      userModel.name = (currentUser.displayName) ?? fullName;
      userModel.photoUrl = currentUser.photoURL.validate();
      userModel.createdAt = DateTime.now();
      userModel.updatedAt = DateTime.now();
      userModel.city = appStore.userCurrentCity;
      userModel.isDeleted = false;
      userModel.loginType = loginType.validate();
      userModel.oneSignalPlayerId = getStringAsync(PLAYER_ID);
      userModel.type = 0;
      userModel.role = DELIVERY_BOY;
      userModel.number = number.validate();
      userModel.isTester = false;
      userModel.address = '';
      userModel.availabilityStatus = true;

      await userService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then((value) {
        //
      }).catchError((e) {
        throw e;
      });
    }

    await setValue(LOGIN_TYPE, loginType);
    await setUserDetailPreference(userModel);

    return userModel;
  }

  Future<void> setUserDetailPreference(UserModel user) async {
    await setValue(USER_ID, user.uid);
    await setValue(USER_DISPLAY_NAME, user.name);
    await setValue(USER_EMAIL, user.email);
    await setValue(USER_PHOTO_URL, user.photoUrl.validate());
    await setValue(IS_TESTER, user.isTester.validate());
    await setValue(USER_ROLE, user.role.validate(value: DELIVERY_BOY));
    await setValue(USER_CHECK, user.type.validate());
    await setValue(PHONE_NUMBER, user.number.validate());

    appStore.setLoggedIn(true);
    appStore.setUserCurrentCity(user.city.validate());

    userService.updateDocument(user.uid, {
      UserKey.oneSignalPlayerId: getStringAsync(PLAYER_ID),
      UserKey.availabilityStatus: true,
      CommonKey.updatedAt: DateTime.now(),
    });
  }

  Future<void> forgotPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      //
    }).catchError((error) {
      throw error.toString();
    });
  }
}
