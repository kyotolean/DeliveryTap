import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_user/services/UserDBService.dart';
import 'package:deliverytap_user/services/CategoryDBService.dart';
import 'package:deliverytap_user/services/StoreDBService.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/store/AppStore.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'screens/SplashScreen.dart';
import 'utils/Common.dart';
import 'AppTheme.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

UserDBService userDBService = UserDBService();
CategoryDBService categoryDBService = CategoryDBService();
StoreDBService storeDBService = StoreDBService();

AppStore appStore = AppStore();

String? storeName = '';
String? storeId = '';

String userAddressGlobal = '';
String? userCityNameGlobal = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initMethod();

  runApp(MyApp());
}

Future<void> initMethod() async {
  defaultLoaderAccentColorGlobal = colorPrimary;

  if (isMobile) {
    await Firebase.initializeApp();
    await initialize();

    await OneSignal.shared.setAppId(mOneSignalAppId);

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });

    saveOneSignalPlayerId();

    appStore.setNotification(getBoolAsync(IS_NOTIFICATION_ON, defaultValue: true));

    appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN));
    if (appStore.isLoggedIn) {
      appStore.setUserId(getStringAsync(USER_ID));
      appStore.setAdmin(getBoolAsync(ADMIN));
      appStore.setFullName(getStringAsync(USER_DISPLAY_NAME));
      appStore.setUserEmail(getStringAsync(USER_EMAIL));
      appStore.setUserProfile(getStringAsync(USER_PHOTO_URL));
    }

  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setOrientationPortrait();

    return Observer(
      builder: (_) => MaterialApp(
        title: mAppName,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: AppTheme.theme,
        home: SplashScreen(),
        builder: scrollBehaviour(),
      ),
    );
  }
}