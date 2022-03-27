import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_user/services/AuthService.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/Widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'RegisterScreen.dart';
import 'DashboardScreen.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.light);

    if (getStringAsync(PLAYER_ID).isEmpty) saveOneSignalPlayerId();
  }

  Future<void> loginWithEmail() async {
    if (isMobile && getStringAsync(PLAYER_ID).isEmpty) {
      await saveOneSignalPlayerId();
      //if (getStringAsync(PLAYER_ID).isEmpty) return toast(errorMessage);
    }
    hideKeyboard(context);
    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);

      await signInWithEmail(email: emailController.text, password: passwordController.text).then((value) {
        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        toast(e.toString());
      });

      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:scaffoldColorDark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  80.height,
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Sign In", style: boldTextStyle(color: colorPrimary, size: 32)),
                  ).paddingLeft(16),
                  30.height,
                  AppTextField(
                    controller: emailController,
                    textFieldType: TextFieldType.EMAIL,
                    errorThisFieldRequired: "This field is required",
                    decoration: inputDecoration(labelText: "Email"),
                    nextFocus: passFocus,
                    textStyle: primaryTextStyle(),
                    suffixIconColor: colorPrimary,
                  ).paddingOnly(left: 16, right: 16),
                  16.height,
                  AppTextField(
                    controller: passwordController,
                    textFieldType: TextFieldType.PASSWORD,
                    focus: passFocus,
                    errorThisFieldRequired: "This field is required",
                    errorMinimumPasswordLength: "Minimum password length should be 6",
                    decoration: inputDecoration(labelText: "Password"),
                    autoFillHints: [AutofillHints.password],
                    textStyle: primaryTextStyle(),
                    onFieldSubmitted: (s) {
                      loginWithEmail();
                    },
                  ).paddingOnly(left: 16, right: 16),
                  16.height,
                  Align(
                    alignment: Alignment.topRight,
                    child: Text('${"Forgot Password"} ?', style: secondaryTextStyle(color: colorPrimary)),
                  ).onTap(() {
                  }).paddingOnly(right: 16, bottom: 16),
                  30.height,
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(left: 30, top: 16, bottom: 16),
                      width: context.width() * 0.5,
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radiusOnly(topLeft: 30, bottomLeft: 30),
                        backgroundColor: colorPrimary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sign In".toUpperCase(), style: primaryTextStyle(color: Colors.white)),
                          Icon(Icons.navigate_next, color: Colors.white),
                        ],
                      ),
                    ).onTap(() {
                      loginWithEmail();
                    }),
                  ),
                ],
              ),
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoading)),
        ],
      ),
      bottomSheet: Container(
        color: scaffoldColorDark,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: createRichText(
                list: [
                  TextSpan(text: "Don't have an account? ", style: primaryTextStyle()),
                  TextSpan(text: "Sign Up", style: primaryTextStyle(color: colorPrimary)),
                ],
              ).onTap(() {
                RegisterScreen().launch(context);
              }),
            ),
            30.height,
          ],
        ).paddingBottom(16),
      ),
    );
  }
}