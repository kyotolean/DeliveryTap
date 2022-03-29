import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/UserModel.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/AppWidgets.dart';
import 'AddUserDialog.dart';

class UserWidget extends StatefulWidget {
  static String tag = '/UserWidget';
  final UserModel? data;
  final double? width;

  UserWidget({this.data, this.width});

  @override
  UserWidgetState createState() => UserWidgetState();
}

class UserWidgetState extends State<UserWidget> {
  int isAccept = 0;
  bool isDeleteFlow = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future updateDeliveryAccept() async {
    appStore.setLoading(true);
    Map<String, dynamic> data = {
      UserKeys.type: isAccept,
      TimeDataKey.updatedAt: DateTime.now(),
    };
    updateUser(data);
  }

  Future userDelete({bool? isDelete}) async {
    appStore.setLoading(true);
    Map<String, dynamic> data = {
      '${CategoryKey.isDeleted}': isDelete,
      TimeDataKey.updatedAt: DateTime.now(),
    };
    updateUser(data);
  }

  Future updateUser(data) async {
    await userService.updateDocument(data, widget.data!.uid.validate()).then((value) {
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
    return Container(
      padding: EdgeInsets.all(8),
      width: context.isPhone()
          ? widget.width! / 1 - 16
          : context.isTablet()
          ? widget.width! / 3 - 16
          : widget.width! / 5 - 16,
      decoration: boxDecorationWithShadow(
        borderRadius: radius(),
        backgroundColor: context.cardColor,
        shadowColor: shadowColorGlobal,
        spreadRadius: defaultSpreadRadius,
      ),
      child: Column(
        children: [
          24.height,
          cachedImage(
            widget.data!.photoUrl.validate(),
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(60),
          16.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              4.height,
              Text('${widget.data!.name.validate()}', style: boldTextStyle(size: 18)),
              4.height,
              Text('${widget.data!.email.validate()}', style: secondaryTextStyle(), overflow: TextOverflow.ellipsis),
              8.height,
              Row(
                children: [
                  Text('${getUserRoleText(widget.data!.role.validate())}', style: boldTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                  8.width,
                  Text(widget.data!.type == 1 ? "Approved" : "Pending",
                      style: boldTextStyle(color: widget.data!.type == 1 ? Colors.green : Colors.amber, size: 14))
                      .visible(widget.data!.role == DELIVERY_BOY),
                ],
              ),
              8.height,
              Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit, size: 18, color: grey),
                      4.width,
                      Text("Update", style: primaryTextStyle()),
                    ],
                  ).onTap(() async {
                    showInDialog(context, child: AddUserDialog(userData: widget.data));
                  }),
                  8.width,
                  Text(
                    !widget.data!.isDeleted.validate() ? "Active" : "Inactive",
                    style: primaryTextStyle(color: !widget.data!.isDeleted.validate() ? Colors.green : Colors.red),
                  ).onTap(() async {
                    bool? res = await showConfirmDialog(
                      context,
                      widget.data!.isDeleted.validate() ? "Are you sure want to active the this user?" : "Are you sure want to Inactive the this user?",
                      positiveText: "Yes",
                      negativeText: "No",
                    );

                    if (getBoolAsync(IS_TESTER)) {
                      return toast("Tester role not allowed to perform this action");
                    } else {
                      widget.data!.isDeleted = !widget.data!.isDeleted.validate();
                      if (res ?? false) {
                        userDelete(isDelete: widget.data!.isDeleted);
                      }
                    }
                  }),
                ],
              ).visible(widget.data!.role.validate() != ADMIN.capitalizeFirstLetter()).visible(!widget.data!.isTester!),
              8.height,
              Visibility(
                visible: widget.data!.role == DELIVERY_BOY || widget.data!.type == 0,
                maintainSize: true,
                maintainAnimation: true,
                maintainInteractivity: true,
                maintainState: true,
                child: Row(
                  children: [
                    Text("Accept", style: primaryTextStyle(color: Colors.green)).onTap(() {
                      if (getBoolAsync(IS_TESTER)) {
                        return toast("Tester role not allowed to perform this action");
                      } else {
                        isAccept = 1;
                        updateDeliveryAccept();
                        setState(() {});
                      }
                    }),
                    8.width,
                    Text("Reject", style: primaryTextStyle(color: Colors.redAccent)).onTap(() {
                      if (getBoolAsync(IS_TESTER)) {
                        return toast("Tester role not allowed to perform this action");
                      } else {
                        isAccept = 0;
                        updateDeliveryAccept();
                        setState(() {});
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
          8.height,
        ],
      ),
    ).paddingAll(8);
  }
}
