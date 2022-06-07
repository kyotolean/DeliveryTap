import 'package:flutter/material.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/StoreModel.dart';
import 'package:deliverytap_admin/screens/Manager/AddStoreDetailScreen.dart';
import 'package:deliverytap_admin/services/StoreService.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import 'components/StoreWidget.dart';

class StoreFragment extends StatefulWidget {
  static String tag = '/StoreFragment';

  @override
  StoreFragmentState createState() => StoreFragmentState();
}

class StoreFragmentState extends State<StoreFragment> {
  StoreService storeService = StoreService();
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
      appBar: appBarWidget("Stores", showBack: false, elevation: 0),
      body: StreamBuilder<List<StoreModel>>(
        stream: storeService.getAllStores(),
        builder: (_, snap) {
          if (snap.hasData) {
            return SingleChildScrollView(
              controller: controller,
              padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 70),
              child: LayoutBuilder(builder: (context, constrain) {
                return Wrap(
                  children: snap.data!.map((e) {
                    return StoreWidget(data: e, width: constrain.maxWidth);
                  }).toList(),
                );
              }),
            );
          } else {
            return snapWidgetHelper(snap);
          }
        },
      ),
      floatingActionButton: Container(
        height: 50,
        width: 185,
        color: colorPrimary,
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: white),
            4.width,
            Text("Add Store", style: boldTextStyle(color: white)),
          ],
        ),
      ).cornerRadiusWithClipRRect(defaultRadius).onTap(() {
        AddStoreDetailScreen().launch(context);
      }),
    );
  }
}
