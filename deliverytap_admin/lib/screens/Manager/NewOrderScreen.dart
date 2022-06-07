import 'package:flutter/material.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/OrderModel.dart';
import 'package:deliverytap_admin/screens/Manager/components/OrderItemWidget.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

class NewOrderScreen extends StatefulWidget {
  static String tag = '/NewOrderScreen';

  @override
  NewOrderScreenState createState() => NewOrderScreenState();
}

class NewOrderScreenState extends State<NewOrderScreen> {
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
  void didUpdateWidget(covariant NewOrderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("New Order", showBack: false, elevation: 0),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.getOrders(id: getStringAsync(STORE_ID), orderStatus: [NEW]),
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.length == 0) {
              return Text("No New Order", style: primaryTextStyle()).center();
            }
            return SingleChildScrollView(
              controller: controller,
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snap.data!.length,
                itemBuilder: (_, index) {
                  OrderModel data = snap.data![index];

                  return OrderItemWidget(
                    orderModel: data,
                    buttonTitle: "Accept",
                    buttonOneColor: Colors.green,
                    onTap: () async {
                      bool? isAccept = await showInDialog(
                        context,
                        child: Text("Are you sure want to accept this order?", style: primaryTextStyle()),
                        actions: [
                          TextButton(
                            onPressed: () {
                              finish(context, false);
                            },
                            child: Text("Cancel", style: primaryTextStyle()),
                          ),
                          8.width,
                          TextButton(
                            onPressed: () {
                              finish(context, true);
                            },
                            child: Text("Accept", style: primaryTextStyle(color: Colors.green)),
                          ),
                          8.width,
                        ],
                      );
                      if (isAccept ?? false) {
                        await orderService.updateDocument({OrderKey.orderStatus: PACKING, TimeDataKey.updatedAt: DateTime.now()}, data.id).then((value) async {
                          sendNotification(data.userID, data.id, data.storeCity);
                        }).catchError((error) {
                          toast(error.toString());
                        });
                      }
                    },
                    isSecondBtn: true,
                    secondBtnTitle: "Reject",
                    buttonTwoColor: Colors.red,
                    secondBtnOnTap: () async {
                      bool isReject = await (showInDialog(
                        context,
                        child: Text("Are you sure want to Reject this order?", style: primaryTextStyle()),
                        actions: [
                          TextButton(
                            onPressed: () {
                              finish(context, false);
                            },
                            child: Text("Cancel", style: primaryTextStyle()),
                          ),
                          8.width,
                          TextButton(
                            onPressed: () {
                              finish(context, true);
                            },
                            child: Text("Reject", style: primaryTextStyle(color: Colors.red)),
                          ),
                          8.width,
                        ],
                      ));
                      if (isReject) {
                        orderService.updateDocument({
                          OrderKey.orderStatus: CANCELED,
                          TimeDataKey.updatedAt: DateTime.now(),
                        }, data.id).then((value) {
                          //
                        }).catchError((error) {
                          // toast(error.toString());
                        });
                      }
                    },
                  ).paddingAll(8);
                },
              ),
            );
          }
          return snapWidgetHelper(snap);
        },
      ),
    );
  }

  Future<void> sendNotification(String? userID, String? orderId, String? restaurantCity) async {
    await userService.getDeliveryBoys(role: DELIVERY_BOY, city: restaurantCity ?? getStringAsync(STORE_CITY)).then((value) {
      List<String> deliveryBoyPlayerIdList = [];

      value.forEach((element) {
        deliveryBoyPlayerIdList.add(element.oneSignalPlayerId.validate());
      });

      if (deliveryBoyPlayerIdList.validate().isNotEmpty) {
        userService.getUserById(userId: userID).then((userModel) {
          sendPushNotifications(
            listUser: deliveryBoyPlayerIdList,
            title: "New Order",
            content: 'New order received from ${userModel.name}',
            orderId: orderId,
          );
        });
      }
    }).catchError((error) {
      log(error.toString());
      // toast(error.toString());
    });
  }
}
