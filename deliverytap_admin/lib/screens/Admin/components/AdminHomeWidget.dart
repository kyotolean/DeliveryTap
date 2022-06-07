import 'package:flutter/material.dart';
import 'package:deliverytap_admin/components/AppWidgets.dart';
import 'package:deliverytap_admin/models/OrderModel.dart';
import 'package:deliverytap_admin/models/UserModel.dart';
import 'package:deliverytap_admin/screens/Admin/components/AdminCounterWidgets.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class AdminHomeWidget extends StatefulWidget {
  static String tag = '/AdminHomeWidget';

  @override
  AdminHomeWidgetState createState() => AdminHomeWidgetState();
}

class AdminHomeWidgetState extends State<AdminHomeWidget> {
  bool mUserCard = false;
  bool mOrderCard = false;
  bool mRestaurantCard = false;
  bool mCategoriesCard = false;
  bool mFoodCard = false;
  bool mDelBoyReviewCard = false;
  bool mReviewCard = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountWidgets(),
        16.height,
        LayoutBuilder(
          builder: (context, constrain) {
            double width = context.isPhone() || context.isTablet() ? constrain.maxWidth : constrain.maxWidth / 2 - 16;

            return Wrap(
              runSpacing: 16,
              spacing: 16,
              children: [
                Container(
                  width: width,
                  decoration: boxDecorationWithShadow(
                    borderRadius: radius(),
                    backgroundColor: context.cardColor,
                    shadowColor: shadowColorGlobal,
                    spreadRadius: defaultSpreadRadius,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Recent User", style: boldTextStyle()).paddingLeft(8),
                      Divider(),
                      StreamBuilder<List<UserModel>>(
                        stream: userService.getAllUsers(role: '', isDash: true),
                        builder: (_, snap) {
                          if (snap.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snap.data!.length,
                              itemBuilder: (_, i) {
                                UserModel data = snap.data![i];
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    cachedImage(data.photoUrl.validate(), height: 80, width: 80, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                                    8.width,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        4.height,
                                        Text(snap.data![i].name.validate(), style: boldTextStyle()),
                                        4.height,
                                        Text('${data.email.validate()}', style: secondaryTextStyle(), overflow: TextOverflow.ellipsis),
                                        4.height,
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('${getUserRoleText(data.role.validate())}', style: boldTextStyle()),
                                            4.width,
                                            Text(data.type != 1 ? "Pending" : "Approved", style: boldTextStyle(color: data.type != 1 ? Colors.amber : Colors.green))
                                                .visible(data.role == DELIVERY_BOY),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ).paddingAll(8);
                              },
                            );
                          } else {
                            return snapWidgetHelper(snap);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width,
                  decoration: boxDecorationWithShadow(
                    borderRadius: radius(),
                    backgroundColor: context.cardColor,
                    shadowColor: shadowColorGlobal,
                    spreadRadius: defaultSpreadRadius,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Recent Order", style: boldTextStyle()).paddingLeft(24),
                      Divider(),
                      StreamBuilder<List<OrderModel>>(
                        stream: orderService.getOrders(orderStatus: [NEW, PACKING, ASSIGNED, READY, DELIVERING, COMPLETED], isDash: true),
                        builder: (_, snap) {
                          if (snap.hasData) {
                            return Container(
                              width: context.width(),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: [
                                    DataColumn(label: Text(OrderTableKey.orderId, style: boldTextStyle())),
                                    DataColumn(label: Text(OrderTableKey.dateTime, style: boldTextStyle())),
                                    DataColumn(label: Text(OrderTableKey.amount, style: boldTextStyle())),
                                    DataColumn(label: Text(OrderTableKey.orderStatus, style: boldTextStyle())),
                                    DataColumn(label: Text(OrderTableKey.storeName, style: boldTextStyle())),
                                  ],
                                  rows: snap.data!.map((e) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(e.orderId.validate(), style: primaryTextStyle())),
                                        DataCell(Text('${DateFormat('dd-MM-yyyy hh:mm a').format(e.createdAt!)}', style: primaryTextStyle())),
                                        DataCell(Text('${e.totalPrice.toAmount()}', style: primaryTextStyle())),
                                        DataCell(Text(e.orderStatus.validate(), style: primaryTextStyle())),
                                        DataCell(Text(e.storeName.validate(), style: primaryTextStyle())),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ).visible(snap.hasData);
                          } else {
                            return snapWidgetHelper(snap);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
