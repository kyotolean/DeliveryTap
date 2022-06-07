import 'package:flutter/material.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/UserModel.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

class AddUserDialog extends StatefulWidget {
  static String tag = '/AddUserDialog';

  final UserModel? userData;

  AddUserDialog({this.userData});

  @override
  AddUserDialogState createState() => AddUserDialogState();
}

class AddUserDialogState extends State<AddUserDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController userNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController roleCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confirmPwdCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode roleFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode cPasswordFocus = FocusNode();

  List<String> roleList = [USER, MANAGER, DELIVERY_BOY];

  String? roleVal = USER;
  bool isUpdate = false;
  final dropdownState = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.userData != null;

    if (isUpdate) {
      userNameCont.text = widget.userData!.name!;
      emailCont.text = widget.userData!.email!;
      roleVal = widget.userData!.role;
    }
  }

  Future<void> addUser() async {
    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);

      if (!isUpdate) {
        await service.signUpWithEmailPassword(email: emailCont.text.trim(), password: passwordCont.text.trim(), displayName: userNameCont.text.trim(), role: roleVal).then((value) async {
          finish(context, true);
        }).catchError((error) {
          toast(error.toString());
        });
      } else {
        Map<String, dynamic> data = {
          UserKeys.role: roleVal,
          UserKeys.email: emailCont.text,
          UserKeys.name: userNameCont.text,
          TimeDataKey.updatedAt: DateTime.now(),
        };
        await userService.updateDocument(data, widget.userData!.uid.validate()).then((value) {
          toast("Successfully update the User");
          finish(context);
        }).catchError((e) {
          toast(e.toString());
          log(e.toString());
        });
      }
      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isUpdate ? "Edit User" : "Add User", style: boldTextStyle()),
            16.height,
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Row(
                    children: [
                      AppTextField(
                        controller: userNameCont,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(hintText: "Enter your Username", labelText: "Username"),
                        nextFocus: emailFocus,
                        errorThisFieldRequired: "This field is required",
                      ).expand(),
                      8.width,
                      AppTextField(
                        controller: emailCont,
                        textFieldType: TextFieldType.EMAIL,
                        decoration: inputDecoration(hintText: "Enter Email Address", labelText: "Email Address"),
                        nextFocus: roleFocus,
                        enabled: isUpdate ? false : true,
                        errorThisFieldRequired:  "This field is required",
                        errorInvalidEmail: emailError,
                      ).expand(),
                    ],
                  ),
                  16.height,
                  Row(
                    children: [
                      AppTextField(
                        controller: passwordCont,
                        textFieldType: TextFieldType.PASSWORD,
                        focus: cPasswordFocus,
                        errorThisFieldRequired:  "This field is required",
                        decoration: inputDecoration(hintText: "Enter your Password", labelText: "Password"),
                      ).expand(),
                      8.width,
                      AppTextField(
                        controller: confirmPwdCont,
                        textFieldType: TextFieldType.PASSWORD,
                        decoration: inputDecoration(hintText: "Enter your confirm Password", labelText: "Confirm Password"),
                        validator: (value) {
                          if (value!.trim().isEmpty) return "This field is required";
                          if (value.trim().length < passwordLengthGlobal) return 'Password length should be more than $passwordLengthGlobal';
                          return passwordCont.text == value.trim() ? null : "Password does not match";
                        },
                      ).expand(),
                    ],
                  ).visible(!isUpdate),
                  16.height,
                  Container(
                    alignment: Alignment.center,
                    width: context.width(),
                    child: DropdownButtonFormField(
                      dropdownColor: context.cardColor,
                      key: dropdownState,
                      value: roleVal,
                      decoration: inputDecoration(hintText: "Select your role"),
                      focusNode: roleFocus,
                      items: roleList.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(getUserRoleText(value), style: primaryTextStyle()),
                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        roleVal = value;
                        setState(() {});
                      },
                    ),
                  ),
                  16.height,
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            finish(context);
                          },
                          child: Text("Cancel", style: secondaryTextStyle()),
                        ),
                        8.width,
                        AppButton(
                          height: 50,
                          text: isUpdate ? "Update User" : "Add User",
                          textStyle: primaryTextStyle(color: white),
                          color: scaffoldSecondaryDark,
                          onTap: () {
                            if (getBoolAsync(IS_TESTER)) {
                              finish(context);
                              return toast("Tester role not allowed to perform this action");
                            } else {
                              addUser();
                            }
                          },
                        ),
                      ],
                    ),
                  ).cornerRadiusWithClipRRect(defaultRadius),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
