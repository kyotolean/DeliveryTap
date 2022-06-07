import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/components/DeliveryIncomeWidget.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/model/OrderModel.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Common.dart';
import 'package:deliverytap_delivery/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class DeliveryIncomeScreen extends StatefulWidget {
  @override
  DeliveryIncomeScreenState createState() => DeliveryIncomeScreenState();
}

class DeliveryIncomeScreenState extends State<DeliveryIncomeScreen> {
  int? total = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    orderServices.deliveryOrderCharges().listen((event) {
      event.forEach((element) {
        element.deliveryCharge != null ? total = total.validate() + element.deliveryCharge!.validate() : SizedBox();
      });
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("My Income"),
      body: Stack(
        children: [
          PaginateFirestore(
            itemBuilderType: PaginateBuilderType.listView,
            itemBuilder: (context, documentSnapshot, index) {
              OrderModel orderData = OrderModel.fromJson(documentSnapshot[index].data() as Map<String, dynamic>);
              return DeliveryIncomeWidget(orderData: orderData);
            },
            query: orderServices.orderQuery1(),
            isLive: true,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            itemsPerPage: DocLimit,
            bottomLoader: Loader(),
            initialLoader: Loader(),
            onEmpty: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Order not found", style: boldTextStyle()),
              ],
            ).center(),
            onError: (e) => Text(e.toString(), style: primaryTextStyle()).center(),
          ).paddingOnly(top: 60),
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationRoundedWithShadow(12, backgroundColor: primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Income", style: primaryTextStyle(color: white)),
                Text(total.toCurrencyAmount().toString().validate(), style: boldTextStyle(color: white), textAlign: TextAlign.end).expand()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
