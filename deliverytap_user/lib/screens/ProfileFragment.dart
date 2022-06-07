import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:deliverytap_user/screens/MyAddressScreen.dart';
import 'package:deliverytap_user/services/AuthService.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

import '../main.dart';
import 'EditProfileScreen.dart';
import 'LoginScreen.dart';

class ProfileFragment extends StatefulWidget {
  static String tag = '/ProfileFragment';

  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
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
      body: Observer(
        builder: (_) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Row(
                children: [
                  appStore.userProfileImage.validate().isEmpty
                      ? Icon(Icons.person_outline, size: 60)
                      : cachedImage(
                    appStore.userProfileImage.validate(),
                    usePlaceholderIfUrlEmpty: true,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(defaultRadius),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(appStore.userFullName.validate(), style: boldTextStyle()),
                      Text(appStore.userEmail.validate(), style: secondaryTextStyle()),
                    ],
                  ),
                ],
              ).paddingOnly(left: 16, right: 16).onTap(() {
                EditProfileScreen().launch(context);
              }).visible(appStore.isLoggedIn),
              16.height,
              Divider(height: 0),
              SettingItemWidget(
                title: "My Address",
                leading: Icon(Icons.book_outlined),
                onTap: () {
                  if (appStore.isLoggedIn) {
                    MyAddressScreen().launch(context);
                  } else {
                    LoginScreen().launch(context);
                  }
                },
              ),
              Divider(height: 0),
              SettingItemWidget(
                title: "Logout",
                leading: Icon(Icons.logout),
                onTap: () async {
                  bool? res = await showConfirmDialog(
                    context,
                    "Do you want to logout?",
                    negativeText: "No",
                    positiveText: "Yes",
                  );

                  if (res ?? false) {
                    logout().then((value) {
                      LoginScreen().launch(context, isNewTask: true);
                    });
                  }
                },
              ).visible(appStore.isLoggedIn),
            ],
          ),
        ),
      ),
    );
  }
}
