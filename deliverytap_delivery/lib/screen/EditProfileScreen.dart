import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Common.dart';
import 'package:deliverytap_delivery/utils/Constants.dart';
import 'package:deliverytap_delivery/utils/ModelKey.dart';
import 'package:nb_utils/nb_utils.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(text: getStringAsync(USER_DISPLAY_NAME));
  TextEditingController emailController = TextEditingController(text: getStringAsync(USER_EMAIL));
  TextEditingController numberController = TextEditingController(text: getStringAsync(PHONE_NUMBER));

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
      bottomNavigationBar:  AppButton(
        shapeBorder: RoundedRectangleBorder(borderRadius: radius(50)),
        color: primaryColor,
        width: context.width(),
        onTap: () async {
          appStore.setLoading(true);
          await userService.updateDocument(getStringAsync(USER_ID), {
            UserKey.number: numberController.text.trim(),
          }).then((value) async {
            await setStringAsync(PHONE_NUMBER, numberController.text.trim());
            toast("Update successful");
            finish(context);
          }).catchError((e) {
            toast(e.toString());
          });
          appStore.setLoading(false);
        },
        text: "Save",
        textStyle: boldTextStyle(color: white),
      ).paddingAll(16),
      appBar: appBarWidget("Edit Profile"),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  20.height,
                  AppTextField(
                    readOnly: true,
                    controller: nameController,
                    textFieldType: TextFieldType.NAME,
                    decoration: buildInputDecoration('Name'),
                  ),
                  16.height,
                  AppTextField(
                    controller: emailController,
                    textFieldType: TextFieldType.EMAIL,
                    decoration: buildInputDecoration('Email'),
                    readOnly: true,
                  ),
                  16.height,
                  AppTextField(
                    controller: numberController,
                    textFieldType: TextFieldType.PHONE,
                    decoration: buildInputDecoration("Phone Number"),
                  ),
                ],
              ).paddingAll(16),
            ),
          ),
          Observer(builder: (_)=>Loader().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
