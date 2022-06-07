import 'package:flutter/material.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/OrderModel.dart';
import 'package:deliverytap_admin/models/UserModel.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import 'StatisticItemWidget.dart';

class OrderItemWidget extends StatefulWidget {
  static String tag = '/OrderItemWidget';

  final OrderModel? orderModel;
  final String? buttonTitle;
  final String? secondBtnTitle;
  final VoidCallback? onTap;
  final VoidCallback? secondBtnOnTap;
  final bool isSecondBtn;
  final bool? showDevBoyDetails;
  final Color? buttonOneColor;
  final Color? buttonTwoColor;

  OrderItemWidget({
    this.buttonTitle,
    this.orderModel,
    this.onTap,
    this.isSecondBtn = false,
    this.secondBtnTitle,
    this.secondBtnOnTap,
    this.showDevBoyDetails,
    this.buttonOneColor,
    this.buttonTwoColor,
  });

  @override
  OrderItemWidgetState createState() => OrderItemWidgetState();
}

class OrderItemWidgetState extends State<OrderItemWidget> {
  UserModel deliveryBoyData = UserModel();
  UserModel userData = UserModel();

  bool isShowDeliveryBoyDetail = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isShowDeliveryBoyDetail = widget.orderModel!.orderStatus == READY || widget.orderModel!.orderStatus == DELIVERING || widget.orderModel!.orderStatus == COMPLETED;

    if (isShowDeliveryBoyDetail) {
      if (widget.orderModel!.deliveryBoyId.validate().isNotEmpty) {
        userService.getDeliveryBoyDetails(deliveryBoydId: widget.orderModel!.deliveryBoyId).then((value) {
          deliveryBoyData = value;
          setState(() {});
        }).catchError((error) {
          //toast(error.toString());
        });
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: context.width(),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderItemWidgetPhone(orderModel: widget.orderModel),
          Divider(),
          orderItemList(ORDER_ITEM, widget.orderModel!.listOfOrder.validate()),
          Divider().visible(isShowDeliveryBoyDetail.validate()),
          isShowDeliveryBoyDetail.validate()
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Delivery Boy details", style: primaryTextStyle(), overflow: TextOverflow.ellipsis),
              16.height,
              Row(
                children: [
                  orderItemDetail(DeliverTableKey.name.validate(), deliveryBoyData.name.validate()),
                  Container(height: 60, width: 1, color: Theme.of(context).dividerColor).paddingSymmetric(horizontal: 24),
                  orderItemDetail(DeliverTableKey.email.validate(), deliveryBoyData.email.validate()),
                  Container(height: 60, width: 1, color: Theme.of(context).dividerColor).paddingSymmetric(horizontal: 24),
                  orderItemDetail(DeliverTableKey.deliveryStatus.validate(), widget.orderModel!.orderStatus.validate()),
                ],
              ),
            ],
          ).paddingSymmetric(vertical: 8)
              : SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                onTap: widget.onTap,
                color: widget.buttonOneColor,
                child: Text(widget.buttonTitle.validate(), style: primaryTextStyle(color: Colors.white), overflow: TextOverflow.ellipsis),
              ),
              16.width,
              AppButton(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                onTap: widget.secondBtnOnTap,
                color: widget.buttonTwoColor,
                child: Text(widget.secondBtnTitle.validate(), style: primaryTextStyle(color: Colors.white), overflow: TextOverflow.ellipsis),
              ).visible(widget.isSecondBtn),
            ],
          ).visible(!isShowDeliveryBoyDetail),
        ],
      ),
    );
  }

  Widget orderItemList(String title, List<OrderItem> itemList) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title : ', style: secondaryTextStyle(), overflow: TextOverflow.ellipsis),
        8.width,
        Wrap(
          runSpacing: 8,
          spacing: 8,
          children: itemList.map((e) {
            return Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
              child: Text('${e.itemName.validate()} X ${e.qty}', style: primaryTextStyle(size: 14), overflow: TextOverflow.ellipsis),
            ).paddingSymmetric(horizontal: 4);
          }).toList(),
        ).expand(),
      ],
    ).paddingSymmetric(vertical: 4);
  }
}
