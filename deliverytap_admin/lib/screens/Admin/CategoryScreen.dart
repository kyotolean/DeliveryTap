import 'package:deliverytap_admin/screens/Admin/components/NewCategoryDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:deliverytap_admin/components/AppWidgets.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/CategoryModel.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';



class CategoryScreen extends StatefulWidget {
  static String tag = '/CategoryScreen';

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future categoryDelete(String id, bool? isDelete) async {
    appStore.setLoading(true);
    Map<String, dynamic> data = {
      CategoryKey.isDeleted: isDelete,
      TimeDataKey.updatedAt: DateTime.now(),
    };
    await categoryService.updateDocument(data, id).then((value) {
      //
    }).catchError((e) {
      toast(e.toString());
      log(e.toString());
    });
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Categories", showBack: false, elevation: 0),
      body: StreamBuilder<List<CategoryModel>>(
        stream: categoryService.getCategory(),
        builder: (_, snap) {
          if (snap.hasData) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 70),
              child: LayoutBuilder(
                builder: (context, constrain) {
                  return Wrap(
                    children: snap.data!.map((e) {
                      return Container(
                        width: context.isPhone()
                            ? constrain.maxWidth / 3 - 16
                            : context.isTablet()
                            ? constrain.maxWidth / 4 - 16
                            : constrain.maxWidth / 6 - 16,
                        padding: EdgeInsets.all(8),
                        decoration: boxDecorationWithShadow(
                          borderRadius: radius(),
                          backgroundColor: context.cardColor,
                          shadowColor: shadowColorGlobal,
                          spreadRadius: defaultSpreadRadius,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cachedImage(e.image, height: 120, width: 120, fit: BoxFit.cover).center().paddingAll(16),
                            8.height,
                            Text(e.categoryName.validate(), style: boldTextStyle()).paddingAll(8),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.edit, size: 18, color: grey),
                                    4.width,
                                    Text(
                                        "Update", style: primaryTextStyle()
                                    ).onTap(() async {
                                        showInDialog(context, child: NewCategoryDialog(data: e));
                                    }),
                                  ],
                                ),
                                8.width,
                                Text(!e.isDeleted! ? "Active" : "Inactive", style: primaryTextStyle(color: e.isDeleted! ? Colors.red : Colors.green), overflow: TextOverflow.ellipsis).onTap(() async {
                                  bool? res = await showConfirmDialog(
                                    context,
                                    e.isDeleted! ? "Are you sure want to active the this category?" : "Are you sure want to Inactive the this category?",
                                    positiveText: "Yes",
                                    negativeText: "No",
                                  );

                                  e.isDeleted = !e.isDeleted!;
                                  if (getBoolAsync(IS_TESTER)) {
                                    return toast("Tester role not allowed to perform this action");
                                  } else {
                                    if (res ?? false) {
                                      categoryDelete(e.id.validate(), e.isDeleted);
                                    }
                                  }
                                }).expand(),
                              ],
                            ).paddingAll(8),
                          ],
                        ),
                      ).paddingAll(8);
                    }).toList(),
                  );
                },
              ),
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
            Text("Add Category", style: boldTextStyle(color: white)),
          ],
        ),
      ).cornerRadiusWithClipRRect(defaultRadius).onTap(() {
        showInDialog(context, child: NewCategoryDialog());
      }),
    );
  }
}
