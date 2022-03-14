import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_admin/screens/DashboardScreen.dart';
import 'package:deliverytap_admin/screens/SignUpScreen.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class SignInScreen extends StatefulWidget {
  static String tag = '/SignInScreen';

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailTextCont = TextEditingController(text: 'tester@gmail.com');
  TextEditingController passWordCont = TextEditingController(text: '123456');

  FocusNode passFocus = FocusNode();

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
        height: 500,
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
                        Text('Food', style: boldTextStyle(color: colorPrimary, size: 24)),
                        2.width,
                        Text('Admin', style: boldTextStyle(size: 24)),
                      ],
                    ),
                    16.height,
                    AppTextField(
                      controller: emailTextCont,
                      textFieldType: TextFieldType.EMAIL,
                      decoration: inputDecoration(hintText: "Enter Email Address", labelText: "Email Address"),
                      nextFocus: passFocus,
                      autoFocus: true,
                      errorInvalidEmail: 'Invalid email address',
                      errorThisFieldRequired: "This field is required",
                    ),
                    16.height,
                    AppTextField(
                      controller: passWordCont,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: passFocus,
                      decoration: inputDecoration(hintText: "Enter your Password", labelText: "Password"),
                      errorMinimumPasswordLength: "Minimum password length should be 6",
                      errorThisFieldRequired: "This field is required",
                      onFieldSubmitted: (s) {
                        signIn();
                      },
                    ),
                    16.height,
                    Container(
                      child: AppButton(
                        height: 50,
                        text: "Sign In",
                        textStyle: primaryTextStyle(color: white),
                        color: colorPrimary,
                        onTap: () {
                          signIn();
                        },
                        width: context.width(),
                      ),
                    ).cornerRadiusWithClipRRect(defaultRadius),
                    16.height,
                    Text("Don't have an account? Sign up", style: primaryTextStyle()).onTap(() {
                      SignUpScreen().launch(context);
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

  void signIn() {
    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);

      service.signInWithEmailPassword(email: emailTextCont.text.trim(), password: passWordCont.text.trim()).then((value) async {
        await setValue(IS_LOGGED_IN, true);

        if (!getBoolAsync(IS_ADMIN)) {
          storeService.getStoreDetails(ownerId: getStringAsync(USER_ID), isDeleted: false).then((value) async {
            await setValue(STORE_ID, value.id);
            await setValue(STORE_NAME, value.storeName);
            await setValue(STORE_CITY, value.storeCity);

            DashboardScreen().launch(context, isNewTask: true);
          }).catchError((error) {
            toast(error.toString());
          });
        } else {
          DashboardScreen().launch(context, isNewTask: true);
        }
        appStore.setLoading(false);
      }).catchError((error) {
        appStore.setLoading(false);

        toast(error.toString());
      });
    }
  }
}
