import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_admin/components/AppWidgets.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/SideDrawerModel.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/DataProvider.dart';
import 'package:nb_utils/nb_utils.dart';

class DrawerWidget extends StatefulWidget {
  static String tag = '/DrawerWidget';
  final Function(SideDrawerModel, Widget?, int)? onWidgetSelected;

  DrawerWidget({this.onWidgetSelected});

  @override
  DrawerWidgetState createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {
  List<SideDrawerModel> list = getDrawerList();

  int index = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(StreamUpdateDrawer);
    LiveStream().dispose(StreamSelectItem);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Observer(
        builder: (_) => Container(
          color: context.cardColor,
          height: context.height(),
          child: Column(
            children: [
              cachedImage('images/logo.png', width: 80, height: 80, fit: BoxFit.cover),
              Column(
                children: list.map((e) {
                  int cIndex = list.indexOf(e);
                  return Container(
                    decoration: BoxDecoration(color: index == cIndex ? colorPrimary : context.cardColor, borderRadius: BorderRadius.circular(8)),
                    child: Image.asset(
                      list[cIndex].img!,
                      color: appStore.isDarkMode
                          ? Colors.white
                          : index == cIndex
                          ? Colors.white
                          : black,
                      height: 24,
                    ).paddingAll(24),
                  ).onTap(() {
                    index = list.indexOf(e);
                    widget.onWidgetSelected?.call(e, e.widget, index);
                    setState(() {});
                  }).paddingSymmetric(vertical: 12);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
