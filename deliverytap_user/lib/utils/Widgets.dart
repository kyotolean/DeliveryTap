import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

InputDecoration inputDecoration({String? labelText}) {
  return InputDecoration(
    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: radius() as BorderRadius),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: radius() as BorderRadius),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorPrimary), borderRadius: radius() as BorderRadius),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: radius() as BorderRadius),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: radius() as BorderRadius),
    labelText: labelText,
    labelStyle: primaryTextStyle(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    alignLabelWithHint: true,
  );
}

Widget noDataWidget({String? errorMessage}) {
  return Container(alignment: Alignment.center, child: Text(errorMessage.validate(value: "No Data Found"), style: boldTextStyle()).center());
}

Widget viewCartWidget({required BuildContext context, String? totalItemLength, Function? onTap}) {
  return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 60,
        width: context.width(),
        decoration: boxDecorationWithRoundedCorners(backgroundColor: colorPrimary),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Item : $totalItemLength', style: primaryTextStyle(color: white)),
            Row(
              children: [
                Text("Checkout", style: primaryTextStyle(color: white)).center(),
                Icon(Icons.arrow_right, color: white, size: 20),
              ],
            )
          ],
        ),
      ).onTap(onTap, highlightColor: scaffoldColorDark));
}