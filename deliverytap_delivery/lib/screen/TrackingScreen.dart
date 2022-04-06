import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../model/OrderModel.dart';
import '../model/UserModel.dart';
import '../utils/Colors.dart';
import '../utils/Constants.dart';
import '../utils/ModelKey.dart';

class TrackingScreen extends StatefulWidget {
  OrderModel? orderModel;

  String? orderId;

  TrackingScreen({this.orderModel, this.orderId});

  @override
  TrackingScreenState createState() => TrackingScreenState();
}

class TrackingScreenState extends State<TrackingScreen> {
  UserModel? userData;
  bool isError = false;
  bool isReached = false;
  String? userPlayerId = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await loadBasicDetails();

    if (isError) {
      init();
      return toast(errorMessage);
    }

    orderServices.getOrderById(widget.orderModel!.id).listen((order) {
      widget.orderModel = order;

      setState(() {});
    }).onError((error) {
      toast(error.toString());
    });

    if (appStore.isDarkMode) {
      setStatusBarColor(scaffoldColorDark);
    } else {
      setStatusBarColor(Colors.white);
    }

    setState(() {});
  }

  Future<void> loadBasicDetails() async {
    isError = false;

    if (widget.orderModel != null) {
      widget.orderId = widget.orderModel!.id;
    }
    if (widget.orderId != null) {
      await orderServices.getOrderByIdFuture(widget.orderId).then((value) {
        widget.orderModel = value;

        isReached = widget.orderModel!.orderStatus == ORDER_STATUS_DELIVERING || widget.orderModel!.orderStatus == ORDER_STATUS_COMPLETE;
      }).catchError((e) {
        isError = true;
      });
      await userService.getUserById(userId: widget.orderModel!.userId).then((user) {
        userData = user;

        userPlayerId = userData!.oneSignalPlayerId;
      }).catchError((e) {
        isError = true;
      });
    }
  }

  Future<void> completeDelivery() async {
    /// Update document
    orderServices.updateDocument(widget.orderModel!.id, {
      OrderKey.orderStatus: ORDER_STATUS_COMPLETE,
      OrderKey.paymentStatus: ORDER_PAYMENT_RECEIVED,
      CommonKey.updatedAt: DateTime.now(),
    }).then((value) {
      finish(context);
    }).catchError((error) {
      toast(error.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: appBarWidget('#${widget.orderModel?.orderId?.validate()}'),
          body: Container(
            child: Row(
              children: [
                AppButton(
                  text: "Sstart",
                  textStyle: primaryTextStyle(color: white),
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  onTap: () async {
                    showConfirmDialog(context, "Did you picked up the parcel?", positiveText: "Yes", negativeText: "No")
                        .then((value) async {
                      if (value ?? false) {
                        isReached = true;

                        await orderServices.updateDocument(widget.orderModel!.id, {
                          OrderKey.orderStatus: ORDER_STATUS_DELIVERING,
                          CommonKey.updatedAt: DateTime.now(),
                        }).then((value) {
                          //
                        }).catchError((error) {
                          toast(error.toString());
                        });
                        setState(() {});
                      }
                    });
                  },
                ).visible(widget.orderModel!.orderStatus == ORDER_STATUS_READY),
                8.width,
                if (widget.orderModel != null)
                  AppButton(
                    text: "Complete",
                    textStyle: primaryTextStyle(color: white),
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    onTap: () {
                      showConfirmDialog(context, "Did you reached the destination and got payment?",
                          positiveText: "Yes", negativeText: "No")
                          .then((value) {
                        if (value ?? false) {
                          completeDelivery();
                        }
                      });
                    },
                  ).visible(
                    widget.orderModel!.orderStatus == ORDER_STATUS_DELIVERING,
                  ),
              ],
            ),
          ).center(),
        ));
  }
}
