import 'package:flutter/material.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/OrderModel.dart';
import 'package:deliverytap_admin/screens/Manager/components/OrderItemWidget.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

class PackingOrderScreen extends StatefulWidget {
  static String tag = '/PackingOrderScreen';

  @override
  PackingOrderScreenState createState() => PackingOrderScreenState();
}

class PackingOrderScreenState extends State<PackingOrderScreen> {
  ScrollController controller = ScrollController();
  String deliveryBoyPlayerId = '';

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
      appBar: appBarWidget("Packing Order", showBack: false, elevation: 0),
      body: StreamBuilder<List<OrderModel>>(
        stream: orderService.getOrders(id: getStringAsync(STORE_ID), orderStatus: [PACKING, ASSIGNED]),
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.length == 0) {
              return Text("No data found", style: primaryTextStyle()).center();
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
                    buttonTitle: "Ready Order",
                    buttonOneColor: Colors.green,
                    onTap: () {
                      if (data.deliveryBoyId != null) {
                        orderService.updateDocument({
                          OrderKey.orderStatus: READY,
                          TimeDataKey.updatedAt: DateTime.now(),
                        }, data.id).then((value) {
                          sendNotification(data.id, data.deliveryBoyId, data.storeName);
                        }).catchError((error) {
                          toast(error.toString());
                        });
                      } else {
                        toast("This order has not accepted by any Delivery Boy yet");
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

  Future<void> sendNotification(String? orderId, String? deliveryBoyId, String? storeName) async {
    await userService.getUserById(userId: deliveryBoyId).then((userModel) {
      if (userModel.oneSignalPlayerId!.validate().isNotEmpty) {
        sendPushNotifications(
          listUser: [userModel.oneSignalPlayerId!],
          title: "Your order is Ready",
          content: 'Collect from $storeName',
          orderId: orderId,
        );
        log(userModel.oneSignalPlayerId!);
      }
    }).catchError((error){
      log(error);
    });
  }
}
