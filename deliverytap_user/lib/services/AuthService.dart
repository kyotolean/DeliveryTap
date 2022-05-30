import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';
import 'package:deliverytap_user/models/UserModel.dart';

Future<User?> _signInWithEmail(String email, String password) async {
  return await auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
    return value.user;
  }).catchError((e) {
    throw e;
  });
}

Future<void> signUpWithEmail(String name, String email, String password, String phone) async {
  UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

  if (userCredential.user != null) {
    User currentUser = userCredential.user!;
    UserModel userModel = UserModel();

    /// Create user
    userModel.uid = currentUser.uid.validate();
    userModel.email = currentUser.email.validate();
    userModel.password = password.validate();
    userModel.name = name.validate();
    userModel.number = phone.validate();
    userModel.photoUrl = currentUser.photoURL.validate();
    userModel.loginType = LoginTypeApp;
    userModel.updatedAt = DateTime.now();
    userModel.createdAt = DateTime.now();
    userModel.listOfAddress = [];
    userModel.isAdmin = false;
    userModel.isTester = false;
    userModel.role = USER_ROLE;

    userModel.city = '';
    userModel.isDeleted = false;

    userModel.oneSignalPlayerId = getStringAsync(PLAYER_ID);

    await userDBService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then((value) async {
      await signInWithEmail(email: email, password: password).then((value) {
        //
      });
    }).catchError((e) {
      throw e;
    });
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<UserModel> signInWithEmail({String? email, String? password}) async {
  if (await userDBService.isUserExist(email, LoginTypeApp)) {
    return await _signInWithEmail(email!, password!).then((user) async {
      return await userDBService.loginWithEmail(email: user!.email, password: password).then((value) async {
        await saveUserDetails(value, LoginTypeApp);
        if (value.role == USER_ROLE) {
          ///Return user data
          return value;
        } else {
          throw '${"You are already registered as"} ${value.role}';
        }
      }).catchError((e) {
        throw e;
      });
    });
  } else {
    throw "You are not registered with us";
  }
}

Future<void> saveUserDetails(UserModel userModel, String loginType) async {
  await setValue(LOGIN_TYPE, loginType);

  await setValue(ADMIN, userModel.isAdmin.validate());
  await setValue(TESTER, userModel.isTester.validate());
  await setValue(USER_ROLE, userModel.role.validate());

  await appStore.setLoggedIn(true);
  await appStore.setUserId(userModel.uid);
  await appStore.setFullName(userModel.name);
  await appStore.setUserEmail(userModel.email);
  await appStore.setUserProfile(userModel.photoUrl);
  await appStore.setPhoneNumber(userModel.number);
  await appStore.setCityName(userModel.city);


  /// Update user data
  userDBService.updateDocument({
    UserKeys.oneSignalPlayerId: getStringAsync(PLAYER_ID).validate(),
    CommonKeys.updatedAt: DateTime.now(),
  }, userModel.uid);
}

Future<void> logout() async {
  userDBService.updateDocument({
    UserKeys.oneSignalPlayerId: '',
    CommonKeys.updatedAt: DateTime.now(),
  }, appStore.userId).then((value) async {
    //
  }).catchError((e) {
    throw e;
  });
  await removeKey(IS_NOTIFICATION_ON);
  await removeKey(USER_HOME_ADDRESS);
  await removeKey(USER_ROLE);
  await removeKey(TESTER);

  appStore.setAddressModel(null);
  appStore.setLoggedIn(false);
  appStore.setUserId('');
  appStore.setFullName('');
  appStore.setUserEmail('');
  appStore.setUserProfile('');
  appStore.setCityName('');

  appStore.clearCart();
}

Future<void> forgotPassword({required String email}) async {
  await auth.sendPasswordResetEmail(email: email).then((value) {
    //
  }).catchError((error) {
    throw error.toString();
  });
}