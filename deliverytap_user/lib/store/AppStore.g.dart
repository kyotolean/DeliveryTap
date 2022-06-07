// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  final _$isLoggedInAtom = Atom(name: '_AppStore.isLoggedIn');

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_AppStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$isNotificationOnAtom = Atom(name: '_AppStore.isNotificationOn');

  @override
  bool get isNotificationOn {
    _$isNotificationOnAtom.reportRead();
    return super.isNotificationOn;
  }

  @override
  set isNotificationOn(bool value) {
    _$isNotificationOnAtom.reportWrite(value, super.isNotificationOn, () {
      super.isNotificationOn = value;
    });
  }

  final _$isAdminAtom = Atom(name: '_AppStore.isAdmin');

  @override
  bool get isAdmin {
    _$isAdminAtom.reportRead();
    return super.isAdmin;
  }

  @override
  set isAdmin(bool value) {
    _$isAdminAtom.reportWrite(value, super.isAdmin, () {
      super.isAdmin = value;
    });
  }

  final _$isReViewAtom = Atom(name: '_AppStore.isReView');

  @override
  bool get isReView {
    _$isReViewAtom.reportRead();
    return super.isReView;
  }

  @override
  set isReView(bool value) {
    _$isReViewAtom.reportWrite(value, super.isReView, () {
      super.isReView = value;
    });
  }

  final _$isQtyExistAtom = Atom(name: '_AppStore.isQtyExist');

  @override
  bool get isQtyExist {
    _$isQtyExistAtom.reportRead();
    return super.isQtyExist;
  }

  @override
  set isQtyExist(bool value) {
    _$isQtyExistAtom.reportWrite(value, super.isQtyExist, () {
      super.isQtyExist = value;
    });
  }

  final _$userProfileImageAtom = Atom(name: '_AppStore.userProfileImage');

  @override
  String? get userProfileImage {
    _$userProfileImageAtom.reportRead();
    return super.userProfileImage;
  }

  @override
  set userProfileImage(String? value) {
    _$userProfileImageAtom.reportWrite(value, super.userProfileImage, () {
      super.userProfileImage = value;
    });
  }

  final _$userFullNameAtom = Atom(name: '_AppStore.userFullName');

  @override
  String? get userFullName {
    _$userFullNameAtom.reportRead();
    return super.userFullName;
  }

  @override
  set userFullName(String? value) {
    _$userFullNameAtom.reportWrite(value, super.userFullName, () {
      super.userFullName = value;
    });
  }

  final _$userEmailAtom = Atom(name: '_AppStore.userEmail');

  @override
  String? get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String? value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  final _$userIdAtom = Atom(name: '_AppStore.userId');

  @override
  String? get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(String? value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  final _$phoneNumberAtom = Atom(name: '_AppStore.phoneNumber');

  @override
  String? get phoneNumber {
    _$phoneNumberAtom.reportRead();
    return super.phoneNumber;
  }

  @override
  set phoneNumber(String? value) {
    _$phoneNumberAtom.reportWrite(value, super.phoneNumber, () {
      super.phoneNumber = value;
    });
  }

  final _$addressModelAtom = Atom(name: '_AppStore.addressModel');

  @override
  AddressModel? get addressModel {
    _$addressModelAtom.reportRead();
    return super.addressModel;
  }

  @override
  set addressModel(AddressModel? value) {
    _$addressModelAtom.reportWrite(value, super.addressModel, () {
      super.addressModel = value;
    });
  }

  final _$cityNameAtom = Atom(name: '_AppStore.cityName');

  @override
  String? get cityName {
    _$cityNameAtom.reportRead();
    return super.cityName;
  }

  @override
  set cityName(String? value) {
    _$cityNameAtom.reportWrite(value, super.cityName, () {
      super.cityName = value;
    });
  }

  final _$mCartListAtom = Atom(name: '_AppStore.mCartList');

  @override
  List<CartModel?> get mCartList {
    _$mCartListAtom.reportRead();
    return super.mCartList;
  }

  @override
  set mCartList(List<CartModel?> value) {
    _$mCartListAtom.reportWrite(value, super.mCartList, () {
      super.mCartList = value;
    });
  }

  final _$setLoggedInAsyncAction = AsyncAction('_AppStore.setLoggedIn');

  @override
  Future<void> setLoggedIn(bool val) {
    return _$setLoggedInAsyncAction.run(() => super.setLoggedIn(val));
  }

  final _$setUserProfileAsyncAction = AsyncAction('_AppStore.setUserProfile');

  @override
  Future<void> setUserProfile(String? val) {
    return _$setUserProfileAsyncAction.run(() => super.setUserProfile(val));
  }

  final _$setUserIdAsyncAction = AsyncAction('_AppStore.setUserId');

  @override
  Future<void> setUserId(String? val) {
    return _$setUserIdAsyncAction.run(() => super.setUserId(val));
  }

  final _$setUserEmailAsyncAction = AsyncAction('_AppStore.setUserEmail');

  @override
  Future<void> setUserEmail(String? val) {
    return _$setUserEmailAsyncAction.run(() => super.setUserEmail(val));
  }

  final _$setFullNameAsyncAction = AsyncAction('_AppStore.setFullName');

  @override
  Future<void> setFullName(String? val) {
    return _$setFullNameAsyncAction.run(() => super.setFullName(val));
  }

  final _$setPhoneNumberAsyncAction = AsyncAction('_AppStore.setPhoneNumber');

  @override
  Future<void> setPhoneNumber(String? val) {
    return _$setPhoneNumberAsyncAction.run(() => super.setPhoneNumber(val));
  }

  final _$setCityNameAsyncAction = AsyncAction('_AppStore.setCityName');

  @override
  Future<void> setCityName(String? value) {
    return _$setCityNameAsyncAction.run(() => super.setCityName(value));
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void addToCart(CartModel? value) {
    final _$actionInfo =
    _$_AppStoreActionController.startAction(name: '_AppStore.addToCart');
    try {
      return super.addToCart(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFromCart(CartModel? value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.removeFromCart');
    try {
      return super.removeFromCart(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCartData(String id, CartModel? value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.updateCartData');
    try {
      return super.updateCartData(id, value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCart() {
    final _$actionInfo =
    _$_AppStoreActionController.startAction(name: '_AppStore.clearCart');
    try {
      return super.clearCart();
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddressModel(AddressModel? val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setAddressModel');
    try {
      return super.setAddressModel(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool val) {
    final _$actionInfo =
    _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNotification(bool val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setNotification');
    try {
      return super.setNotification(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAdmin(bool val) {
    final _$actionInfo =
    _$_AppStoreActionController.startAction(name: '_AppStore.setAdmin');
    try {
      return super.setAdmin(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReview(bool val) {
    final _$actionInfo =
    _$_AppStoreActionController.startAction(name: '_AppStore.setReview');
    try {
      return super.setReview(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setQtyExist(bool val) {
    final _$actionInfo =
    _$_AppStoreActionController.startAction(name: '_AppStore.setQtyExist');
    try {
      return super.setQtyExist(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isLoading: ${isLoading},
isNotificationOn: ${isNotificationOn},
isAdmin: ${isAdmin},
isReView: ${isReView},
isQtyExist: ${isQtyExist},
userProfileImage: ${userProfileImage},
userFullName: ${userFullName},
userEmail: ${userEmail},
userId: ${userId},
phoneNumber: ${phoneNumber},
addressModel: ${addressModel},
cityName: ${cityName},
mCartList: ${mCartList}
    ''';
  }
}
