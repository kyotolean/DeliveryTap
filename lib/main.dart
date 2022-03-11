import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_delivery/screen/SplashScreen.dart';
import 'package:deliverytap_delivery/services/AuthService.dart';
import 'package:deliverytap_delivery/services/UserService.dart';
import 'package:deliverytap_delivery/store/AppStore.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Common.dart';
import 'package:deliverytap_delivery/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:deliverytap_delivery/AppTheme.dart';

AppStore appStore = AppStore();

FirebaseFirestore db = FirebaseFirestore.instance;

UserService userService = UserService();
AuthService authService = AuthService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  defaultLoaderAccentColorGlobal = primaryColor;
  defaultCurrencySymbol = currencySymbol;


  await OneSignal.shared.setAppId(mOneSignalAppId);

  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    event.complete(event.notification);
  });

  saveOneSignalPlayerId();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setOrientationPortrait();

    return Observer(
      builder: (_) => MaterialApp(
        title: mAppName,
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        builder: scrollBehaviour(),
      ),
    );
  }
}
