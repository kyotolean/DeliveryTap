import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_user/models/AddressModel.dart';
import 'package:deliverytap_user/models/OrderItemData.dart';
import 'package:deliverytap_user/models/OrderModel.dart';
import 'package:deliverytap_user/screens/MyAddressScreen.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'OrderSuccessFullyDialog.dart';

// ignore: must_be_immutable
class MyOrderBottomWidget extends StatefulWidget {
  static String tag = '/MyOrderBottomWidget';
  int? totalAmount;
  bool? isOrder;
  double? userLatitude;
  double? userLongitude;
  String? orderAddress;
  Function? onPlaceOrder;

  MyOrderBottomWidget({this.totalAmount, this.userLatitude, this.userLongitude, this.orderAddress, this.isOrder, this.onPlaceOrder});

  @override
  MyOrderBottomWidgetState createState() => MyOrderBottomWidgetState();
}

class MyOrderBottomWidgetState extends State<MyOrderBottomWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> order() async {
    if (appStore.addressModel == null) {
      toast("Select Address");
      await Future.delayed(Duration(milliseconds: 100));

      AddressModel? data = await MyAddressScreen(isOrder: widget.isOrder).launch(context);
      if (data != null && data is AddressModel) {
        appStore.setAddressModel(data);
        setState(() {});
      }
    } else {
      var id = DateTime.now().millisecondsSinceEpoch;

      List<OrderItemData> items = [];
      appStore.mCartList.forEach((element) {
        storeName = element!.storeName;
        storeId = element.storeId;

        items.add(
          OrderItemData(
              image: element.image,
              itemName: element.itemName,
              qty: element.qty,
              id: element.id,
              categoryId: element.categoryId,
              categoryName: element.categoryName,
              itemPrice: element.itemPrice,
              storeId: element.storeId,
              storeName: element.storeName),
        );
      });

      if (storeId!.isEmpty) return toast(errorMessage);

      OrderModel orderModel = OrderModel();

      orderModel.userId = appStore.userId;
      orderModel.orderStatus = ORDER_NEW;
      orderModel.createdAt = DateTime.now();
      orderModel.updatedAt = DateTime.now();
      orderModel.totalAmount = widget.totalAmount;
      orderModel.totalItem = appStore.mCartList.length;
      orderModel.orderId = id.toString();
      orderModel.listOfOrder = items;
      orderModel.storeName = storeName;
      orderModel.storeId = storeId;
      orderModel.userAddress = appStore.addressModel!.address;
      orderModel.paymentMethod = CASH_ON_DELIVERY;
      orderModel.deliveryCharge = getIntAsync(DELIVERY_CHARGES);

      orderModel.storeCity = "Lviv";
      orderModel.paymentStatus = PAYMENT_STATUS_PENDING;
      orderModel.userLocation = GeoPoint(appStore.addressModel!.userLocation!.latitude, appStore.addressModel!.userLocation!.longitude);

      myOrderDBService.addDocument(orderModel.toJson()).then((value) async {
        //TODO update with batch write
        await Future.forEach(appStore.mCartList, (dynamic element) async {
          await myCartDBService.removeDocument(element.id);
        });

        appStore.clearCart();
        widget.totalAmount = 0;

        widget.onPlaceOrder?.call();

        showInDialog(
          context,
          child: OrderSuccessFullyDialog(),
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(borderRadius: radius(12)),
        );
      }).catchError((e) {
        log(e);
      });
    }
  }

  void address() async {
    toast("Please select address");
    await Future.delayed(Duration(milliseconds: 100));

    AddressModel? data = await MyAddressScreen(isOrder: widget.isOrder).launch(context);
    if (data != null) {
      appStore.setAddressModel(data);
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: colorPrimary,
        borderRadius: radiusOnly(topRight: 16, topLeft: 16),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Item", style: secondaryTextStyle(color: Colors.white, size: 14)),
              Observer(builder: (_) => Text(appStore.mCartList.length.toString(), style: boldTextStyle(color: Colors.white))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delivery Charges", style: secondaryTextStyle(color: Colors.white)),
              Text(getAmount(getIntAsync(DELIVERY_CHARGES)), style: boldTextStyle(color: Colors.white)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total".toUpperCase(), style: primaryTextStyle(color: Colors.white)),
              Text(getAmount(widget.totalAmount.validate()), style: boldTextStyle(color: Colors.white, size: 20)),
            ],
          ),
          30.height,
          AppButton(
            width: context.width(),
            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Text("Place Order", style: boldTextStyle(color: colorPrimary)),
            color: Colors.white,
            onTap: () async {
              if (appStore.addressModel == null) {
                address();
              } else {
                showConfirmDialog(
                  context,
                  "Are you sure want to place order?",
                  negativeText: "No",
                  positiveText: "Yes",
                ).then((value) {
                  if (value ?? false) {
                    order();
                  }
                }).catchError((e) {
                  toast(e.toString());
                });
              }
            },
          )
        ],
      ),
    );
  }
}
