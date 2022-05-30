import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/services/FileStorageService.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';
import 'package:deliverytap_user/utils/Widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class EditProfileScreen extends StatefulWidget {
  static String tag = '/EditProfileScreen';

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();

  FocusNode emailFocus = FocusNode();

  PickedFile? image;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    fullNameController.text = appStore.userFullName!;
  }

  Future save() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      appStore.setLoading(true);
      setState(() {});

      Map<String, dynamic> req = {
        CommonKeys.updatedAt: DateTime.now(),
      };

      if (fullNameController.text != appStore.userFullName) {
        req.putIfAbsent(UserKeys.name, () => fullNameController.text.trim());
      }

      if (image != null) {
        await uploadFile(file: File(image!.path), prefix: 'userProfiles').then((path) async {
          req.putIfAbsent(UserKeys.photoUrl, () => path);

          await setValue(USER_PHOTO_URL, path);
          appStore.setUserProfile(path);
        }).catchError((e) {
          toast(e.toString());
        });
      }

      await userDBService.updateDocument(req, appStore.userId).then((value) async {
        appStore.setLoading(false);
        appStore.setFullName(fullNameController.text);
        setValue(USER_DISPLAY_NAME, fullNameController.text);

        finish(context);
      });
    }
  }

  Future getImage() async {
    image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 100);

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget profileImage() {
      if (image != null) {
        return Image.file(File(image!.path), height: 130, width: 130, fit: BoxFit.cover, alignment: Alignment.center);
      } else {
        if (getStringAsync(LOGIN_TYPE) == LoginTypeApp) {
          return cachedImage(appStore.userProfileImage, height: 130, width: 130, fit: BoxFit.cover, alignment: Alignment.center);
        } else {
          return Icon(Icons.person_outline_rounded).paddingAll(16);
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarWidget("Edit Profile", color: context.cardColor),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 16,
                              margin: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                              child: profileImage(),
                            ),
                            Text(
                              "Change Profile",
                              style: boldTextStyle(),
                            ).paddingTop(16),
                            4.height,
                            Text(appStore.userEmail.validate(), style: primaryTextStyle()),
                          ],
                        ).paddingOnly(top: 16, bottom: 16),
                      ).onTap(() {
                        getImage();
                      }).paddingTop(16),
                      16.height,
                      AppTextField(
                        controller: fullNameController,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(labelText: "Full Name"),
                        textStyle: isLoggedInWithApp() ? primaryTextStyle() : secondaryTextStyle(),
                        enabled: isLoggedInWithApp(),
                      ),
                      30.height,
                      AppButton(
                        text: "Save",
                        color: colorPrimary,
                        textStyle: boldTextStyle(color: white),
                        enabled: isLoggedInWithApp(),
                        onTap: () {
                          save();
                        },
                        width: context.width(),
                      ).visible(isLoggedInWithApp()),
                    ],
                  ),
                ),
              ),
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
