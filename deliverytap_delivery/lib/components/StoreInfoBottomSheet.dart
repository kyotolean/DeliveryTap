import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/model/OrderModel.dart';
import 'package:deliverytap_delivery/model/StoreModel.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreInfoBottomSheet extends StatefulWidget {
  final OrderModel? oderData;

  StoreInfoBottomSheet(this.oderData);

  @override
  StoreInfoBottomSheetState createState() => StoreInfoBottomSheetState();
}

class StoreInfoBottomSheetState extends State<StoreInfoBottomSheet> {
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
    return FutureBuilder<StoreModel>(
      future: storeService.getStoreById(storeId: widget.oderData!.storeId),
      builder: (_, snap) {
        StoreModel? data = snap.data;

        if (snap.hasData) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonCachedNetworkImage(data!.photoUrl, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                        8.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: primaryTextStyle(size: 15),
                                children: <TextSpan>[
                                  TextSpan(text: '${data.storeName}', style: boldTextStyle(size: 20)),
                                ],
                              ),
                            ),
                          ],
                        ).expand(),
                      ],
                    ).paddingAll(8),
                    Row(
                      children: [
                        Icon(Icons.call, color: blueButtonColor).onTap(() {
                          launch('tel://${data.storeContact}');
                        }),
                        8.width,
                        Text(data.storeContact!, style: primaryTextStyle(size: 15)).onTap(() {
                          launch('tel://${data.storeContact}');
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.home, color: blueButtonColor),
                        8.width,
                        Text('${data.storeAddress}', style: secondaryTextStyle(size: 14), maxLines: 2).expand(),
                      ],
                    ),
                    16.height,
                    Text('Order Items', style: boldTextStyle()).paddingOnly(left: 8, right: 8),
                    8.height,
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.oderData!.orderItems!.length,
                      itemBuilder: (_, index) {
                        OrderItems data = widget.oderData!.orderItems![index];
                        return Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(8),
                          decoration: boxDecorationWithShadow(borderRadius: radius(), backgroundColor: context.cardColor),
                          child: Row(
                            children: [
                              commonCachedNetworkImage(
                                data.image,
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              ).cornerRadiusWithClipRRect(25),
                              8.width,
                              Text('${data.itemName}', style: boldTextStyle()).expand(),
                              Text('${data.itemPrice.toCurrencyAmount()} x ${data.qty}', style: primaryTextStyle())
                            ],
                          ),
                        );
                      },
                    ),
                    8.height,
                    Container(
                        decoration: boxDecorationWithShadow(borderRadius: radius(), backgroundColor: appStore.isDarkMode ? context.cardColor : primaryColor),
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total", style: boldTextStyle(color: white)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(widget.oderData!.totalAmount.toCurrencyAmount().toString().validate(), style: secondaryTextStyle(color: white)),
                                4.height,
                                Text("Delivery Charges Include", style: secondaryTextStyle(size: 10, color: white)),
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              ],
            ).paddingAll(8),
          );
        } else {
          return snapWidgetHelper(snap);
        }
      },
    );
  }
}
