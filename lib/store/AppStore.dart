import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Constants.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  Color primaryColor = Colors.blue;

  @observable
  bool isLoggedIn = false;

  @observable
  bool isLoading = false;

  @observable
  bool isDarkMode = false;

  @observable
  String userCurrentCity = '';



  @action
  void setPrimaryColor(Color color) => primaryColor = color;

  @action
  void setLoading(bool val) => isLoading = val;

  @action
  Future<void> setUserCurrentCity(String val) async {
    userCurrentCity = val;
    await setValue(CITY, val);
  }

  @action
  Future<void> setLoggedIn(bool val) async {
    isLoggedIn = val;
    await setValue(IS_LOGGED_IN, val);
  }
}
