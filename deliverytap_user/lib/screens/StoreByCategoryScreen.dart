import 'package:flutter/material.dart';
import 'package:deliverytap_user/components/StoreItemComponent.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/models/StoreModel.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/Widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class StoreByCategoryScreen extends StatefulWidget {
  static String tag = '/StoreByCategoryScreen';
  final String? catName;

  StoreByCategoryScreen({this.catName});

  @override
  StoreByCategoryScreenState createState() => StoreByCategoryScreenState();
}

class StoreByCategoryScreenState extends State<StoreByCategoryScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(
      white,
      statusBarIconBrightness: Brightness.dark,
    );
  }

  @override
  void dispose() {
    setStatusBarColor(
      white,
      statusBarIconBrightness: Brightness.dark,
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
        appBar: appBarWidget('${widget.catName.validate()} Store', color: context.cardColor),
        body: StreamBuilder<List<StoreModel>>(
            stream: storeDBService.storeByCategory(widget.catName, cityName: getStringAsync(USER_CITY_NAME)),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text(snapshot.error.toString()).center();
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return noDataWidget(errorMessage: "No Store Found");
                } else {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return StoreItemComponent(store: snapshot.data![index]);
                    },
                    padding: EdgeInsets.all(8),
                    itemCount: snapshot.data!.length,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                  );
                }
              }
              return Loader().center();
            }),
      ),
    );
  }
}
