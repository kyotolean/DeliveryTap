import 'package:flutter/material.dart';
import 'package:deliverytap_user/models/AddressModel.dart';
import 'package:deliverytap_user/models/CartModel.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  bool isLoading = false;

  @observable
  bool isNotificationOn = true;

  @observable
  bool isAdmin = false;

  @observable
  bool isReView = false;

  @observable
  bool isQtyExist = false;

  @observable
  String? userProfileImage = '';

  @observable
  String? userFullName = '';

  @observable
  String? userEmail = '';

  @observable
  String? userId = '';

  @observable
  String? phoneNumber = '';

  @observable
  AddressModel? addressModel;

  @observable
  String? cityName = '';

  @observable
  List<CartModel?> mCartList = [];

  @action
  void addToCart(CartModel? value) {
    mCartList.add(value);
  }

  @action
  void removeFromCart(CartModel? value) {
    mCartList.remove(value);
  }

  @action
  void updateCartData(String id, CartModel? value) {
    mCartList.forEachIndexed((element, index) {
      if (element!.id == id) {
        mCartList[index] = value;
      }
    });
  }

  @action
  void clearCart() {
    mCartList.clear();
  }

  @action
  void setAddressModel(AddressModel? val) {
    addressModel = val;
  }

  @action
  void setLoading(bool val) => isLoading = val;

  @action
  Future<void> setLoggedIn(bool val) async {
    isLoggedIn = val;
    await setValue(IS_LOGGED_IN, val);
  }

  @action
  void setNotification(bool val) {
    isNotificationOn = val;

    setValue(IS_NOTIFICATION_ON, val);

    if (isMobile) {
      // OneSignal.shared.setSubscription(val);
    }
  }

  @action
  Future<void> setUserProfile(String? val) async {
    userProfileImage = val;
    await setValue(USER_PHOTO_URL, val.validate());
  }

  @action
  Future<void> setUserId(String? val) async {
    userId = val;
    await setValue(USER_ID, val.validate());
  }

  @action
  Future<void> setUserEmail(String? val) async {
    userEmail = val;
    await setValue(USER_EMAIL, val.validate());
  }

  @action
  Future<void> setFullName(String? val) async {
    userFullName = val;
    await setValue(USER_DISPLAY_NAME, val.validate());
  }

  @action
  Future<void> setPhoneNumber(String? val) async {
    phoneNumber = val;
    await setValue(PHONE_NUMBER, val.validate());
  }

  @action
  void setAdmin(bool val) {
    isAdmin = val;
  }

  @action
  void setReview(bool val) {
    isReView = val;
  }

  @action
  void setQtyExist(bool val) {
    isQtyExist = val;
  }

  @action
  Future<void> setCityName(String? value) async {
    cityName = value;
    await setValue(USER_CITY_NAME, value.validate());
  }
}