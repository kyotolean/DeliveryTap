import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'Constants.dart';

Widget cachedImage(String? url, {double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius}) {
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
  return Image.asset('assets/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

bool isLoggedInWithApp() {
  return appStore.isLoggedIn && getStringAsync(LOGIN_TYPE) == LoginTypeApp;
}

Future<void> saveOneSignalPlayerId() async {
  await OneSignal.shared.getDeviceState().then((value) async {
    if (value!.userId.validate().isNotEmpty) await setValue(PLAYER_ID, value.userId.validate());
  });
}

Color getOrderStatusColor(String? orderStatus) {
  if (orderStatus == ORDER_NEW) {
    return Color(0xFF9A8500);
  } else if (orderStatus == ORDER_PACKING) {
    return Colors.blue;
  } else if (orderStatus == ORDER_ASSIGNED) {
    return Colors.orangeAccent;
  } else if (orderStatus == ORDER_DELIVERING) {
    return Colors.greenAccent;
  } else if (orderStatus == ORDER_COMPLETE) {
    return Colors.green;
  } else if (orderStatus == ORDER_READY) {
    return Colors.grey;
  } else if (orderStatus == ORDER_CANCELLED) {
    return Colors.red;
  } else {
    return Colors.black;
  }
}

String getOrderStatusText(String orderStatus) {
  if (orderStatus == ORDER_NEW) {
    return "Order is being approved";
  } else if (orderStatus == ORDER_PACKING || orderStatus == ORDER_ASSIGNED) {
    return "Order is packing";
  } else if (orderStatus == ORDER_READY) {
    return "Your order is ready to picked up";
  } else if (orderStatus == ORDER_DELIVERING) {
    return "Your order is on the way";
  } else if (orderStatus == ORDER_COMPLETE) {
    return "Order is delivered";
  } else if (orderStatus == ORDER_CANCELLED) {
    return "Cancelled";
  }
  return orderStatus;
}

String getAmount(int data) {
  String data2 = data.toString() + " UAH";

  return data2;
}

List<String> lowRateTags() {
  List<String> list = [];
  list.add('items quantity');
  list.add('packaging issue');
  return list;
}

List<String> highRateTags() {
  List<String> list = [];
  list.add('timely service');
  list.add('nice packaging');
  list.add('worth the money');
  return list;
}

List<String> lowDeliveryTags() {
  List<String> list = [];
  list.add('unclean packaging');
  list.add('bad quality item');
  list.add('value for money');
  list.add('bad delivery service');
  return list;
}

List<String> highDeliveryTags() {
  List<String> list = [];
  list.add('fast delivery with good quality');
  list.add('spill proof packaging');
  list.add('timely service');
  return list;
}