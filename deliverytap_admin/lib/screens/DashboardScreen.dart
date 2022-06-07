import 'package:deliverytap_admin/screens/HomeFragment.dart';
import 'package:flutter/material.dart';
import 'package:deliverytap_admin/components/AppWidgets.dart';
import 'package:deliverytap_admin/components/DrawerWidget.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/SideDrawerModel.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/DataProvider.dart';
import 'package:nb_utils/nb_utils.dart';

import 'Admin/CategoryScreen.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> with AfterLayoutMixin<DashboardScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isTap = false;
  int index = 0;
  String? title;
  List<SideDrawerModel> drawerList = getDrawerList();

  Widget? currentWidget = HomeFragment();
  SideDrawerModel model = SideDrawerModel();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void afterFirstLayout(BuildContext context) {

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: !context.isDesktop()
          ? appBarWidget(
        title.validate(value: "Dashboard"),
        backWidget: IconButton(
          icon: Icon(Icons.menu),
          color: colorPrimary,
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      )
          : null,
      drawer: context.isDesktop()
          ? null
          : Drawer(
        child: Container(
          color: context.cardColor,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(getStringAsync(USER_NAME), style: boldTextStyle(), overflow: TextOverflow.ellipsis),
                accountEmail: Text(getStringAsync(USER_EMAIL), style: secondaryTextStyle(size: 12), overflow: TextOverflow.ellipsis),
                currentAccountPicture: cachedImage(getStringAsync(USER_IMAGE), fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: scaffoldSecondaryDark))),
              ),
              SingleChildScrollView(
                child: Container(
                  height: context.height(),
                  color: context.cardColor,
                  child: Column(
                    children: [
                      Column(
                        children: drawerList.map((e) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(e.title!, style: boldTextStyle()),
                                trailing: e.items != null
                                    ? Icon(e.isExpand ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: white)
                                    : SizedBox(),
                                onTap: () {
                                  if (e.items != null) {
                                    e.isExpand = !e.isExpand;
                                  } else {
                                    title = e.title;
                                    finish(context);
                                    currentWidget = e.widget;
                                  }
                                  setState(() {});
                                },
                              ),
                              e.items != null
                                  ? Column(
                                children: e.items!.map((i) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                                    width: context.width(),
                                    child: Row(
                                      children: [
                                        Text('${e.items!.indexOf(i) + 1}.', style: primaryTextStyle(size: 14)),
                                        8.width,
                                        Text(i.title.validate(), style: primaryTextStyle(size: 14)),
                                        Divider(),
                                      ],
                                    ),
                                  ).onTap(() {
                                    title = e.title;
                                    currentWidget = i.widget;
                                    e.isExpand = !e.isExpand;
                                    finish(context);
                                    setState(() {});
                                  });
                                }).toList(),
                              ).visible(e.isExpand)
                                  : SizedBox(),
                            ],
                          );
                        }).toList(),
                      ),
                      ListTile(
                        title: Text("Logout", style: boldTextStyle()),
                        onTap: () {
                          finish(context);
                        },
                      ),
                    ],
                  ),
                ),
              ).expand()
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                decoration: boxDecorationWithShadow(backgroundColor: ThemeData().scaffoldBackgroundColor),
                height: context.height(),
                child: DrawerWidget(
                  onWidgetSelected: (e, w, i) {
                    currentWidget = w;
                    isTap = true;
                    index = 0;
                    model = e;

                    setState(() {});
                  },
                ),
              ),
              if (model.items != null)
                Container(
                  width: isTap ? 280 : 0,
                  color: context.cardColor,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        child: Row(
                          children: [
                            Text(model.title.validate(), style: boldTextStyle(size: 28)).expand(),
                            Icon(Icons.close).onTap(() {
                              isTap = false;
                              setState(() {});
                            }, splashColor: Colors.transparent),
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey, thickness: 0.2),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: model.items!.map((e) {
                          return Row(
                            children: [
                              index == model.items!.indexOf(e)
                                  ? Container(
                                width: 5,
                                height: 50,
                                color: colorPrimary,
                              ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), bottomRight: defaultRadius.toInt())
                                  : SizedBox(),
                              Row(
                                children: [
                                  Text(e.title.validate(), style: primaryTextStyle()).expand(),
                                  Icon(Icons.arrow_forward_ios_rounded, size: 12),
                                ],
                              ).paddingAll(16).expand(),
                            ],
                          ).onTap(() {
                            index = model.items!.indexOf(e);
                            currentWidget = e.widget;
                            setState(() {});
                          });
                        }).toList(),
                      ),
                    ],
                  ),
                ),
            ],
          ).visible(context.isDesktop()),
          currentWidget.expand(),
        ],
      ),
    );
  }
}
