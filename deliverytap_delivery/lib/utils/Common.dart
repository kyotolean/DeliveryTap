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


Widget commonCachedNetworkImage(String? url, {double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset('images/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

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
  } else if (orderStatus == ORDER_STATUS_PACKING || orderStatus == ORDER_STATUS_ASSIGNED) {
    return 'Order is packing';
  } else if (orderStatus == ORDER_STATUS_READY) {
    return 'Order is ready to picked up. You are travelling to Store';
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
  } else if (orderStatus == ORDER_STATUS_PACKING) {
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