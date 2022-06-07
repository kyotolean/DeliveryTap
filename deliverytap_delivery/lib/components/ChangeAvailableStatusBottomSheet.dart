import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Constants.dart';
import 'package:deliverytap_delivery/utils/ModelKey.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangeAvailableStatusBottomSheet extends StatefulWidget {
  @override
  ChangeAvailableStatusBottomSheetState createState() => ChangeAvailableStatusBottomSheetState();
}

class ChangeAvailableStatusBottomSheetState extends State<ChangeAvailableStatusBottomSheet> {
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
    return Container(
      height: context.height() * 0.5,
      child: Stack(
        children: [
          SettingSection(
            headingDecoration: BoxDecoration(color: context.cardColor),
            title: Text("Availability Status", style: boldTextStyle(size: 24)),
            subTitle: Text("Set your current Availability Status", style: secondaryTextStyle()),
            items: [
              SettingItemWidget(
                title: "Available",
                titleTextStyle: boldTextStyle(color: primaryColor),
                subTitle: "You will receive new order notification",
                decoration: BoxDecoration(borderRadius: radius()),
                leading: Icon(Icons.check, color: primaryColor),
                onTap: () async {
                  appStore.setLoading(true);
                  await userService.updateDocument(getStringAsync(USER_ID), {UserKey.availabilityStatus: true}).then((value) async {
                    await setValue(AVAILABLE, true);
                    finish(context);
                  }).catchError((error) {
                    toast(error.toString());
                  });

                  appStore.setLoading(false);
                },
              ),
              SettingItemWidget(
                title: "Not Available",
                titleTextStyle: boldTextStyle(color: colorPrimary),
                subTitle: "You will not receive new orders",
                decoration: BoxDecoration(borderRadius: radius()),
                leading: Icon(Icons.close, color: colorPrimary),
                onTap: () async {
                  appStore.setLoading(true);
                  await userService.updateDocument(getStringAsync(USER_ID), {UserKey.availabilityStatus: false}).then((value) async {
                    await setValue(AVAILABLE, false);
                    finish(context);
                  }).catchError((error) {
                    toast(error.toString());
                  });

                  appStore.setLoading(false);
                },
              ),
            ],
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
