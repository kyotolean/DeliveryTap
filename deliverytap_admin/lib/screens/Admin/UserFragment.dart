import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/UserModel.dart';
import 'package:deliverytap_admin/screens/Admin/components/UserWidget.dart';
import 'package:deliverytap_admin/services/UserService.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import 'components/AddUserDialog.dart';

class UserFragment extends StatefulWidget {
  static String tag = '/UserFragment';
  final String? role;

  UserFragment({this.role});

  @override
  UserFragmentState createState() => UserFragmentState();
}

class UserFragmentState extends State<UserFragment> {
  UserService userService = UserService();
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
      appBar: appBarWidget(widget.role.validate() == '' ? "All User" : widget.role.validate(), showBack: false, elevation: 0),
      body: StreamBuilder<List<UserModel>>(
        stream: userService.getAllUsers(role: widget.role.validate()),
        builder: (_, snap) {
          if (snap.hasData) {
            return SingleChildScrollView(
              controller: controller,
              padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 70),
              child: LayoutBuilder(builder: (context, constrain) {
                return Wrap(
                  children: snap.data!.map((e) => UserWidget(data: e, width: constrain.maxWidth)).toList(),
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
            Text("Add User", style: boldTextStyle(color: white)),
          ],
        ),
      ).cornerRadiusWithClipRRect(defaultRadius).onTap(() {
        // AddUserDialog
        showInDialog(context, child: AddUserDialog());
        // AddEditUserScreen().launch(context);
      }),
    );
  }
}
