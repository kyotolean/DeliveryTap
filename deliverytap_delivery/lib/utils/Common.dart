import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> saveOneSignalPlayerId() async {
  await OneSignal.shared.getDeviceState().then((value) async {
    if (value!.userId.validate().isNotEmpty) await setValue(PLAYER_ID, value.userId.validate());
  });
}

InputDecoration buildInputDecoration(String name) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 16, top: 16, right: 8),
    labelText: name,
    labelStyle: primaryTextStyle(
        color: appStore.isDarkMode ? colorWhite : textNameColor),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
            color: appStore.isDarkMode ? colorWhite : textNameColor,
            width: 0.5)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
            color: appStore.isDarkMode ? colorWhite : textNameColor,
            width: 0.5)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
            color: appStore.isDarkMode ? colorWhite : textNameColor,
            width: 0.5)),
  );
}


Future<bool> checkPermission() async {
  // Request app level location permission
  LocationPermission locationPermission = await Geolocator.requestPermission();

  if (locationPermission == LocationPermission.whileInUse ||
      locationPermission == LocationPermission.always) {
    // Check system level location permission
    if (!await Geolocator.isLocationServiceEnabled()) {
      return await Geolocator.openLocationSettings()
          .then((value) => false)
          .catchError((e) => false);
    } else {
      return true;
    }
  } else {
    toast('Allow Location Permission');

    // Open system level location permission
    await Geolocator.openAppSettings();

    return false;
  }
}

Future<String?> getUserCurrentCity() async {
  if (await checkPermission()) {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return place.locality;
  } else {
    throw 'Location permission not allowed';
  }
}


String? getOrderStatusText(String? orderStatus) {
  if (orderStatus == ORDER_STATUS_NEW) {
    return 'Order is being approved';
  } else if (orderStatus == ORDER_STATUS_COOKING || orderStatus == ORDER_STATUS_ASSIGNED) {
    return 'Order is cooking';
  } else if (orderStatus == ORDER_STATUS_READY) {
    return 'Order is ready to picked up. You are travelling to Restaurant';
  } else if (orderStatus == ORDER_STATUS_DELIVERING) {
    return 'You are delivering. You are travelling to Customer';
  } else if (orderStatus == ORDER_STATUS_COMPLETE) {
    return 'Order is delivered';
  } else if (orderStatus == ORDER_STATUS_CANCELLED) {
    return 'Cancelled';
  }
  return orderStatus;
}

Color getOrderStatusColor(String? orderStatus) {
  if (orderStatus == ORDER_STATUS_NEW) {
    return Color(0xFF9A8500);
  } else if (orderStatus == ORDER_STATUS_COOKING) {
    return Colors.blue;
  } else if (orderStatus == ORDER_STATUS_ASSIGNED) {
    return Colors.orangeAccent;
  } else if (orderStatus == ORDER_STATUS_DELIVERING) {
    return Colors.greenAccent;
  } else if (orderStatus == ORDER_STATUS_COMPLETE) {
    return Colors.green;
  } else if (orderStatus == ORDER_STATUS_READY) {
    return Colors.grey;
  } else if (orderStatus == ORDER_STATUS_CANCELLED) {
    return Colors.red;
  } else {
    return Colors.black;
  }
}