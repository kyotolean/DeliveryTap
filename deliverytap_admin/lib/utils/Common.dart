import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

InputDecoration inputDecoration({String? hintText, String? labelText}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: secondaryTextStyle(),
    labelText: labelText ?? '',
    labelStyle: secondaryTextStyle(),
    counterText: '',
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: textPrimaryColor, width: 0.5)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: textPrimaryColor, width: 0.5)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: textPrimaryColor, width: 0.5)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Colors.red, width: 0.5)),
  );
}

List<String> setSearchParam(String caseNumber) {
  List<String> caseSearchList = [];
  String temp = "";
  for (int i = 0; i < caseNumber.length; i++) {
    temp = temp + caseNumber[i];
    caseSearchList.add(temp.toLowerCase());
  }
  return caseSearchList;
}

String getUserRoleText(String role) {
  if (role.validate() == DELIVERY_BOY) {
    return 'Delivery Boy';
  } else if (role.validate() == USER) {
    return 'User';
  } else if (role.validate() == ADMIN) {
    return 'Admin';
  } else if (role.validate() == MANAGER) {
    return 'Manager';
  }
  return role.validate();
}

Future<bool> sendPushNotifications({String? title, String? content, List<String>? listUser, String? orderId}) async {
  Map dataMap = {};

  if (orderId != null) {
    dataMap.putIfAbsent('orderId', () => orderId);
  }

  Map req = {
    'headings': {'en': title},
    'contents': {'en': content},
    //'big_picture': image.validate().isNotEmpty ? image.validate() : '',
    //'large_icon': image.validate().isNotEmpty ? image.validate() : '',
    //'small_icon': mAppIconUrl,
    'data': dataMap,
    'app_id': mOneSignalAppId,
    'android_channel_id': mOneSignalChannelId,
    "include_player_ids": listUser,
  };
  var header = {
    HttpHeaders.authorizationHeader: 'Basic $mOneSignalRestKey',
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
  };

  Response res = await post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    body: jsonEncode(req),
    headers: header,
  );

  log(res.statusCode);
  log(res.body);

  if (res.statusCode.isSuccessful()) {
    return true;
  } else {
    throw "";
  }
}

extension ScreenSize on BuildContext {
  bool isMobile() => MediaQuery.of(this).size.width < 850;

  bool isTab() => MediaQuery.of(this).size.width < 1100 && MediaQuery.of(this).size.width >= 850;

  bool isDesk() => MediaQuery.of(this).size.width >= 1100;
}

extension IntExtenstion on int? {
  String toAmount() => "$currencySymbol" + this.validate().toString();
}