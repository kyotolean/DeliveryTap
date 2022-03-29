import 'package:flutter/material.dart';
import 'package:deliverytap_admin/models/OrderModel.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class CompletedOrderScreen extends StatefulWidget {
  static String tag = '/CompletedOrderScreen';

  @override
  CompletedOrderScreenState createState() => CompletedOrderScreenState();
}

class CompletedOrderScreenState extends State<CompletedOrderScreen> {
  ScrollController controller = ScrollController();

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
    return Scaffold(
      appBar: appBarWidget("Completed Order", showBack: false, elevation: 0),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.getOrders(id: getStringAsync(STORE_ID), orderStatus: [COMPLETED]),
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.isEmpty) {
              if (snap.data!.length == 0) {
                return Text("No data found", style: primaryTextStyle()).center();
              }
            }
            List<OrderModel> orderModel = snap.data!;
            return Container(
              width: context.width(),
              child: SingleChildScrollView(
                controller: controller,
                scrollDirection: Axis.vertical,
                child: Container(
                  width: context.width(),
                  child: SingleChildScrollView(
                    scrollDirection: context.isDesktop() ? Axis.vertical : Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text(OrderTableKey.orderId, style:  boldTextStyle(size: 17))),
                        DataColumn(label: Text(OrderTableKey.dateTime, style: boldTextStyle(size: 17))),
                        DataColumn(label: Text(OrderTableKey.amount, style: boldTextStyle(size: 17))),
                        DataColumn(label: Text(OrderTableKey.paymentStatus, style: boldTextStyle(size: 17))),
                        DataColumn(label: Text(OrderTableKey.paymentMethod, style: boldTextStyle(size: 17))),
                      ],
                      rows: orderModel.map((e) {
                        return DataRow(cells: [
                          DataCell(Text(e.orderId.validate(), style: primaryTextStyle())),
                          DataCell(Text('${DateFormat('dd-MM-yyyy hh:mm a').format(e.createdAt!)}', style: primaryTextStyle())),
                          DataCell(Text('${e.totalPrice.validate().toAmount()}', style: primaryTextStyle())),
                          DataCell(Text(e.paymentStatus.validate(), style: primaryTextStyle())),
                          DataCell(Text(e.paymentMethod.validate(), style: primaryTextStyle())),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          }
          return snapWidgetHelper(snap);
        },
      ),
    );
  }
}
