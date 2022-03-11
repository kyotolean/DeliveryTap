import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '/screen/SignUpScreen.dart';
import '/utils/Colors.dart';
import '/utils/Common.dart';
import '/utils/Constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (getStringAsync(PLAYER_ID).isNotEmpty) saveOneSignalPlayerId();

    Geolocator.requestPermission();
  }

  Future<void> signIn() async {

      if (getStringAsync(PLAYER_ID).isEmpty) {
        await saveOneSignalPlayerId().then((value) {
          if (getStringAsync(PLAYER_ID).isEmpty) return toast(errorMessage);
        });
      }
      if (formKey.currentState!.validate()) {
        appStore.setLoading(true);

        await authService
            .signInWithEmailPassword(
                email: emailController.text.trim(),
                password: passController.text.trim())
            .then((value) async {
          appStore.setLoading(false);

          if (getIntAsync(USER_CHECK) == 0 &&
              getStringAsync(USER_ROLE) == DELIVERY_BOY) {
            toast(
                'You profile is under review. Wait some time or contact your administrator.');
            appStore.setLoggedIn(false);
          } else {
            appStore.setLoggedIn(true);
          }
        }).catchError((error) {
          appStore.setLoading(false);

          toast(error.toString());
        });
      }
   
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    32.height,
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sign in',
                            style: boldTextStyle(size: 25)),
                        16.height,
                        AppTextField(
                          focus: emailFocus,
                          nextFocus: passwordFocus,
                          controller: emailController,
                          textFieldType: TextFieldType.EMAIL,
                          errorThisFieldRequired:
                              'This field is required',
                          decoration:
                              buildInputDecoration('Email'),
                        ),
                        16.height,
                        AppTextField(
                          controller: passController,
                          focus: passwordFocus,
                          textFieldType: TextFieldType.PASSWORD,
                          errorThisFieldRequired:
                              'This field is required',
                          errorMinimumPasswordLength:
                              'Minimum password length should be 6',
                          decoration: buildInputDecoration(
                              'Password'),
                          onFieldSubmitted: (val) {
                            signIn();
                          },
                        ),
                        16.height,
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('Forgot password?',
                                  style: primaryTextStyle(color: errorColor),
                                  textAlign: TextAlign.start)
                              
                        ),
                        16.height,
                        AppButton(
                          shapeBorder:
                              RoundedRectangleBorder(borderRadius: radius(50)),
                          color: primaryColor,
                          width: context.width(),
                          onTap: () {
                            signIn();
                          },
                          text: 'Sign in',
                          textStyle: boldTextStyle(color: white),
                        ),
                        16.height,
                        30.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\"t have an account ?',
                                style: primaryTextStyle()),
                            8.width,
                            Text('Sign Up',
                                    style: boldTextStyle(color: errorColor))
                                .onTap(() {
                              SignUpScreen().launch(context);
                            })
                          ],
                        )
                      ],
                    ).paddingOnly(left: 16, right: 16, bottom: 32)
                  ],
                ),
              ),
            ),
            Observer(
                builder: (_) => Loader().center().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }
}
