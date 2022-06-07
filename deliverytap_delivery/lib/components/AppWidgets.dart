import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

Widget orderStatusWidget(String? status) {
  return Container(
    padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: getOrderStatusColor(status).withOpacity(0.2)),
    child: Text(getOrderStatusText(status)!, style: boldTextStyle(color: getOrderStatusColor(status), size: 12)),
  );
}
