import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:deliverytap_user/components/StoreItemsTabWidget.dart';
import 'package:deliverytap_user/components/StoreItemsTopWidget.dart';
import 'package:deliverytap_user/components/ReviewTabComponent.dart';
import 'package:deliverytap_user/models/StoreModel.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

// ignore: must_be_immutable
class StoreItemsScreen extends StatefulWidget {
  static String tag = '/StoreItemsScreen';

  StoreModel? store;
  final String? restId;

  StoreItemsScreen({this.store, this.restId});

  @override
  StoreItemsScreenState createState() => StoreItemsScreenState();
}

class StoreItemsScreenState extends State<StoreItemsScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _tabController = TabController(length: 2, vsync: this);

    setStatusBarColor(colorPrimary, statusBarIconBrightness: Brightness.light);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.white);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(
          widget.store!.storeName.validate(),
          color: colorPrimary,
          textColor: whiteColor,
          actions: [
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 240,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  bottom: TabBar(
                    controller: _tabController,
                    labelStyle: boldTextStyle(),
                    unselectedLabelStyle: primaryTextStyle(),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.all(8),
                    indicatorColor: colorPrimary,
                    unselectedLabelColor: grey,
                    tabs: <Widget>[
                      Text("Items"),
                      Text("Review"),
                    ],
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: widget.store != null ? StoreItemsTopWidget(storeData: widget.store) : SizedBox(),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                StoreItemsTabWidget(storeData: widget.store),
                ReviewTabComponent(storeData: widget.store),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
