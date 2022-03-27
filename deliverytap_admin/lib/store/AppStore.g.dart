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

  final _$userProfileImageAtom = Atom(name: '_AppStore.userProfileImage');

  @override
  String get userProfileImage {
    _$userProfileImageAtom.reportRead();
    return super.userProfileImage;
  }

  @override
  set userProfileImage(String value) {
    _$userProfileImageAtom.reportWrite(value, super.userProfileImage, () {
      super.userProfileImage = value;
    });
  }

  final _$userFullNameAtom = Atom(name: '_AppStore.userFullName');

  @override
  String get userFullName {
    _$userFullNameAtom.reportRead();
    return super.userFullName;
  }

  @override
  set userFullName(String value) {
    _$userFullNameAtom.reportWrite(value, super.userFullName, () {
      super.userFullName = value;
    });
  }

  final _$userEmailAtom = Atom(name: '_AppStore.userEmail');

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  final _$userIdAtom = Atom(name: '_AppStore.userId');

  @override
  String get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(String value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  final _$setLoggedInAsyncAction = AsyncAction('_AppStore.setLoggedIn');

  @override
  Future<void> setLoggedIn(bool val) {
    return _$setLoggedInAsyncAction.run(() => super.setLoggedIn(val));
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void setUserProfile(String image) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setUserProfile');
    try {
      return super.setUserProfile(image);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserId(String val) {
    final _$actionInfo =
    _$_AppStoreActionController.startAction(name: '_AppStore.setUserId');
    try {
      return super.setUserId(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserEmail(String email) {
    final _$actionInfo =
    _$_AppStoreActionController.startAction(name: '_AppStore.setUserEmail');
    try {
      return super.setUserEmail(email);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFullName(String name) {
    final _$actionInfo =
    _$_AppStoreActionController.startAction(name: '_AppStore.setFullName');
    try {
      return super.setFullName(name);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool val, {String? toastMsg}) {
    final _$actionInfo =
    _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val, toastMsg: toastMsg);
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
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isAdmin: ${isAdmin},
isLoading: ${isLoading},
userProfileImage: ${userProfileImage},
userFullName: ${userFullName},
userEmail: ${userEmail},
userId: ${userId}
    ''';
  }
}
