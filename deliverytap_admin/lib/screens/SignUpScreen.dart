import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:deliverytap_admin/screens/SignInScreen.dart';
import 'package:deliverytap_admin/screens/Manager/AddStoreDetailScreen.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailTextCont = TextEditingController();
  TextEditingController nameTextCont = TextEditingController();
  TextEditingController passWordCont = TextEditingController();
  TextEditingController confirmPassWordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode confPassFocus = FocusNode();

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
      body: Container(
        alignment: Alignment.center,
        width: 500,
        height: 600,
        decoration: boxDecorationWithShadow(
          borderRadius: radius(),
          backgroundColor: context.cardColor,
          shadowColor: shadowColorGlobal,
          spreadRadius: defaultSpreadRadius,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Delivery Tap', style: boldTextStyle(color: colorPrimary, size: 24)),
                        2.width,
                        Text('Admin', style: boldTextStyle(size: 24)),
                      ],
                    ),
                    16.height,
                    AppTextField(
                      controller: nameTextCont,
                      textFieldType: TextFieldType.NAME,
                      keyboardType: TextInputType.name,
                      decoration: inputDecoration(hintText: "Enter your Username", labelText: "Username"),
                      nextFocus: emailFocus,
                      autoFocus: true,
                      errorThisFieldRequired: "This field is required",
                    ),
                    16.height,
                    AppTextField(
                      controller: emailTextCont,
                      textFieldType: TextFieldType.EMAIL,
                      focus: passFocus,
                      decoration: inputDecoration(hintText: "Enter Email Address", labelText: "Email Address"),
                      errorInvalidEmail: emailError,
                      errorThisFieldRequired: "This field is required",
                      onFieldSubmitted: (s) {
                        //
                      },
                    ),
                    16.height,
                    AppTextField(
                      controller: passWordCont,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: confPassFocus,
                      decoration: inputDecoration(hintText: "Enter your Password", labelText: "Password"),
                      errorThisFieldRequired: "This field is required",
                      onFieldSubmitted: (s) {
                        //
                      },
                    ),
                    16.height,
                    AppTextField(
                      controller: confirmPassWordCont,
                      textFieldType: TextFieldType.PASSWORD,
                      decoration: inputDecoration(hintText: "Enter your confirm Password", labelText: "Confirm Password"),
                      onFieldSubmitted: (s) {
                        signUp();
                      },
                      validator: (value) {
                        if (value!.trim().isEmpty) return "This field is required";
                        if (value.trim().length < passwordLengthGlobal) return "Password length should be more than $passwordLengthGlobal";
                        return passWordCont.text == value.trim() ? null : "Password does not match";
                      },
                    ),
                    16.height,
                    Container(
                      child: AppButton(
                        height: 50,
                        text: "Sign Up",
                        textStyle: primaryTextStyle(color: white),
                        color: colorPrimary,
                        onTap: () {
                          signUp();
                        },
                        width: context.width(),
                      ),
                    ).cornerRadiusWithClipRRect(defaultRadius),
                    16.height,
                    Text("Already have an account? Sign in", style: primaryTextStyle()).onTap(() {
                      SignInScreen().launch(context);
                    })
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ).center(),
    );
  }

  void signUp() {
    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);
      service.signUpWithEmailPassword(email: emailTextCont.text.trim(), password: passWordCont.text.trim(), displayName: nameTextCont.text.trim(), role: MANAGER).then((value) async {
        await setValue(IS_LOGGED_IN, true);

        if (getBoolAsync(IS_ADMIN) || getBoolAsync(IS_TESTER)) {
          SignInScreen().launch(context);
        } else {
          AddStoreDetailScreen().launch(context, isNewTask: true);
        }


        appStore.setLoading(false);
      }).catchError((error) {
        appStore.setLoading(false);

        toast(error.toString());
      });
    }
  }
}
