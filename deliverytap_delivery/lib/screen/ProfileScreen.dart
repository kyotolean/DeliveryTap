import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:deliverytap_delivery/components/ChangeAvailableStatusBottomSheet.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/screen/DeliveryIncomeScreen.dart';
import 'package:deliverytap_delivery/screen/EditProfileScreen.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Common.dart';
import 'package:deliverytap_delivery/utils/Constants.dart';
import 'package:deliverytap_delivery/utils/ModelKey.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
      appStore.isDarkMode ? scaffoldColorDark : white,
      statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
    );
  }

  @override
  void dispose() {
    setStatusBarColor(
      appStore.isDarkMode ? scaffoldColorDark : white,
      statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
    );
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget("Profile", showBack: false),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  16.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonCachedNetworkImage(
                        getStringAsync(USER_PHOTO_URL),
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                      ).cornerRadiusWithClipRRect(45).visible(getStringAsync(USER_PHOTO_URL).isNotEmpty),
                      Icon(Icons.person, size: 60).visible(getStringAsync(USER_PHOTO_URL).isEmpty),
                      8.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getStringAsync(USER_DISPLAY_NAME), style: boldTextStyle(size: 14)),
                                  Text(getStringAsync(USER_EMAIL), style: secondaryTextStyle(size: 12)),
                                ],
                              ),
                            ],
                          ),
                          2.height,
                          InkWell(
                            borderRadius: radius(),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                context: context,
                                builder: (builder) {
                                  return ChangeAvailableStatusBottomSheet();
                                },
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(4),
                              margin: EdgeInsets.only(top: 4, bottom: 4),
                              decoration: boxDecorationDefault(
                                borderRadius: radius(),
                                color: getBoolAsync(AVAILABLE, defaultValue: true) ? Colors.green.shade50 : Colors.red.shade50,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  4.width,
                                  Icon(getBoolAsync(AVAILABLE, defaultValue: true) ? Icons.check : Icons.close,
                                      size: 14, color: getBoolAsync(AVAILABLE, defaultValue: true) ? primaryColor : colorPrimary),
                                  8.width,
                                  Text(
                                    getBoolAsync(AVAILABLE, defaultValue: true) ? "Available" : "Not Available",
                                    style: boldTextStyle(color: getBoolAsync(AVAILABLE, defaultValue: true) ? primaryColor : colorPrimary, size: 14),
                                  ),
                                  4.width,
                                ],
                              ),
                            ),
                          )
                        ],
                      ).expand(),
                      IconButton(
                        onPressed: () {
                          EditProfileScreen().launch(context);
                        },
                        icon: Icon(Icons.edit, color: blueButtonColor),
                      ),
                    ],
                  ).paddingOnly(left: 16, right: 16),
                  Divider(thickness: 1, height: 20),
                  SettingItemWidget(
                    leading: Icon(Icons.account_balance_wallet_outlined),
                    title: "My Income",
                    titleTextStyle: primaryTextStyle(),
                    onTap: () {
                      DeliveryIncomeScreen().launch(context);
                    },
                  ),
                  SettingItemWidget(
                    leading: Icon(Icons.exit_to_app_rounded),
                    title: "Logout",
                    titleTextStyle: primaryTextStyle(),
                    onTap: () async {
                      bool? res =
                      await showConfirmDialog(context, "Do you want to logout from the app?", positiveText: "Yes", negativeText: "No");
                      if (res ?? false) {
                        authService.logout(context);
                      }
                    },
                  ),
                  20.height,
                ],
              ),
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
