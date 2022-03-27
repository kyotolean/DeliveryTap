import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:deliverytap_user/components/DeliveryBoyReviewDialog.dart';
import 'package:deliverytap_user/components/OrderDetailsComponent.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/models/OrderItemData.dart';
import 'package:deliverytap_user/models/OrderModel.dart';
import 'package:deliverytap_user/services/DeliveryBoyReviewsDBService.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class OrderDetailsScreen extends StatefulWidget {
  static String tag = '/OrderDetailsScreen';
  List<OrderItemData>? listOfOrder;
  OrderModel? orderData;

  OrderDetailsScreen({this.listOfOrder, this.orderData});

  @override
  OrderDetailsScreenState createState() => OrderDetailsScreenState();
}

class OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late DeliveryBoyReviewsDBService deliveryBoyReviewsDBService;
  bool isReview = false;
  String orderStatus = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(
      scaffoldColorDark,
      statusBarIconBrightness: Brightness.light,
    );
    review();

    myOrderDBService.orderById(id: widget.orderData!.id).listen((event) async {
      widget.orderData = event;
      setState(() {});
    });
  }

  review() async {
    deliveryBoyReviewsDBService = DeliveryBoyReviewsDBService(restId: widget.orderData!.id);

    deliveryBoyReviewsDBService.deliveryBoyReviews(orderID: widget.orderData!.id).listen((event) async {
      isReview = event;
      setState(() {});
    });
  }

  void cancelOrder() async {
    Map<String, dynamic> data = {
      OrderKeys.orderStatus: ORDER_CANCELLED,
      CommonKeys.updatedAt: DateTime.now(),
    };

    myOrderDBService.updateDocument(data, widget.orderData!.id).then((res) async {
      toast("Order Cancelled");

      widget.orderData!.orderStatus = ORDER_CANCELLED;

      setState(() {});
    }).catchError((error) {
      toast(error.toString());
      setState(() {});
    });
  }

  @override
  void dispose() {
    setStatusBarColor(scaffoldColorDark);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('#${widget.orderData!.orderId}', color: context.cardColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Id", style: boldTextStyle()).paddingOnly(left: 16, top: 16),
            Text('${widget.orderData!.orderId.validate()}', style: boldTextStyle(size: 12)).paddingLeft(16),
            8.height,
            Text("Date", style: boldTextStyle()).paddingOnly(left: 16, top: 16),
            Text(
              'Delivery By ${DateFormat('EEE d, MMM yyyy HH:mm:ss').format(widget.orderData!.createdAt!)}',
              style: boldTextStyle(size: 12),
            ).paddingLeft(16),
            8.height,
            Text("Deliver to", style: boldTextStyle()).paddingOnly(left: 16, top: 16),
            Text(widget.orderData!.userAddress.validate(), style: boldTextStyle(size: 12)).paddingOnly(left: 16, right: 16),
            16.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit, color: Colors.orangeAccent),
                    4.width,
                    Text("Add Review", style: secondaryTextStyle(color: Colors.orangeAccent, size: 14)),
                  ],
                ).onTap(() async {
                  bool? res = await showInDialog(
                    context,
                    barrierDismissible: true,
                    child: DeliveryBoyReviewDialog(order: widget.orderData),
                    contentPadding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(borderRadius: radius(16)),
                  );
                  if (res ?? false) {
                    review();
                  }
                }).paddingLeft(16),
                16.height,
              ],
            ).visible(!isReview && widget.orderData!.orderStatus == ORDER_COMPLETE),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: Colors.red),
                  child: Text("Cancel Order", style: secondaryTextStyle(color: Colors.white, size: 12)),
                ).onTap(() async {
                  bool? res = await showConfirmDialog(context, "Do you want to cancel this order?", negativeText: "No", positiveText: "Yes");
                  if (res ?? false) {
                    cancelOrder();
                  }
                }).paddingOnly(left: 16),
                16.height,
              ],
            ).visible((widget.orderData!.orderStatus == ORDER_ASSIGNED) || widget.orderData!.orderStatus == ORDER_PACKING),
            AppButton(
              padding: EdgeInsets.all(8),
              color: Colors.green,
              child: Text("Track Order", style: boldTextStyle(color: Colors.white, size: 14)),
            ).paddingLeft(16).visible(widget.orderData!.orderStatus == ORDER_DELIVERING),
            8.height,
            Divider(thickness: 3),
            16.height,
            Text("Order Items", style: boldTextStyle()).paddingLeft(16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              itemCount: widget.listOfOrder!.length,
              itemBuilder: (context, index) {
                return OrderDetailsComponent(orderDetailsData: widget.listOfOrder![index]);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 16),
        color: scaffoldColorDark,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total", style: primaryTextStyle(size: 18)),
                Text(getAmount(widget.orderData!.totalAmount.validate()), style: boldTextStyle(size: 22)),
              ],
            ).paddingOnly(left: 16, right: 16),
          ],
        ),
      ),
    );
  }
}
