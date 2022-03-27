import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/models/AddressModel.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class MyOrderUserInfoComponent extends StatefulWidget {
  static String tag = '/MyOrderUserInfoComponent';

  bool? isOrder;

  MyOrderUserInfoComponent({this.isOrder});

  @override
  MyOrderUserInfoComponentState createState() => MyOrderUserInfoComponentState();
}

class MyOrderUserInfoComponentState extends State<MyOrderUserInfoComponent> {
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
  void didUpdateWidget(covariant MyOrderUserInfoComponent oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Deliver to", style: primaryTextStyle()),
                8.width,
                Text(appStore.userFullName.validate(), style: boldTextStyle(),maxLines: 2,overflow: TextOverflow.ellipsis).expand(),
              ],
            ),
            Observer(
              builder: (_) => Text(
                appStore.addressModel != null ? appStore.addressModel!.address.validate() : "Please select shipping address",
                style: secondaryTextStyle(),
                maxLines: 2,
              ),
            ),
          ],
        ).expand(),
        4.width,
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: viewLineColor)),
          child: Text(
            appStore.addressModel == null ? "Select Address" : "Change Address",
            style: secondaryTextStyle(color: colorPrimary),
          ),
        ),
      ],
    ).paddingOnly(left: 16, right: 16, top: 16);
  }
}
