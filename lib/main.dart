// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpoo/service_request/core/network/local/cache_helper.dart';
import 'package:helpoo/service_request/core/util/bloc_observer.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upgrader/upgrader.dart';
import 'bloc_observer.dart';
import 'dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import 'dataLayer/bloc/app/app_bloc.dart';
import 'dataLayer/bloc/driver/driver_cubit.dart';
import 'dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import 'dataLayer/constants/variables.dart';
import 'dataLayer/models/currentUser.dart';
import 'dataLayer/models/vehicle.dart';
import 'dataLayer/pluginsController/NotificationClick.dart';
import 'firebase_options.dart';
import 'presitationLayer/pages/connectionError.dart';
import 'presitationLayer/pages/splashScreen.dart';
import 'translateApp/translation.dart';
import 'package:helpoo/service_request/core/di/injection.dart' as di;

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

const String devRoute = 'apidev';
const String stagingRoute = 'apistaging';
const String productionRoute = 'api';
const String mainBaseUrl = productionRoute;


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('notification => ${message.notification?.body}');
  if (CurrentUser.isDriver) {
    driverCubit.getRequests();
  }
  if (message.notification?.body == 'تم استقبال طلب جديد') {
    AudioPlayer().play(AssetSource('audio/Notification.mp3'));

    flutterLocalNotificationsPlugin.show(
      message.notification?.hashCode ?? 0,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          icon: 'launch_background',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  if (message.notification?.body == 'لقد تم الغاء الطلب') {
    AudioPlayer().play(AssetSource('audio/Notification.mp3'));

    flutterLocalNotificationsPlugin.show(
      message.notification?.hashCode ?? 0,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          icon: 'launch_background',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  debugPrint("Handling a background message: ${message.messageId}");
}

void onDidReceiveLocalNotification(
    int? id, String? title, String? body, String? payload) async {
  if (payload != null) {
    ClickActionHandler.handle(payload);
  }
}

String? selectNotification(String? payload) {
  if (payload != null) {
    ClickActionHandler.handle(payload);
  }
  return payload;
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  GetStorage.init();
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  Bloc.observer = PrimaryBlocObserver();

  if (CurrentUser.isCorporate) {
    await di.sl<CacheHelper>().get(Keys.availablePaymentMethods).then(
      (value) {
        if (value != null) {
          debugPrint('availablePaymentMethods => $value');

          availablePayments = value.cast<String, bool>();
        } else {
          availablePayments = {};
        }
      },
    );
  }

  await di.sl<CacheHelper>().get(Keys.token).then(
    (value) {
      if (value != null) {
        debugPrint('token => $value');

        CurrentUser.token = value;
      } else {
        CurrentUser.token = null;
      }
    },
  );

  await di.sl<CacheHelper>().get(Keys.isLogin).then(
    (value) {
      if (value != null) {
        debugPrint('isLogin => $value');

        CurrentUser.isLoggedIn = value;
      } else {
        CurrentUser.isLoggedIn = false;
      }
    },
  );

  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'helpo', // id
        'helpo', // title
        importance: Importance.high,
      );

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  } on SocketException catch (_) {
    HelpooInAppNotification.showErrorMessage(message: "Network Error".tr);
    // Get.snackbar("Error".tr, "Network Error".tr);
  } catch (e) {
    debugPrint(e.toString());
  }
  FirebaseMessaging.instance.getToken().then((value) {
    debugPrint('----- my fcm token $value');
  });

  runApp(
    MyApp(),
  );

  // runZonedGuarded(() async {
  //   await SentryFlutter.init(
  //     (options) {
  //       options.dsn =
  //           'https://0a7e3020071c4d788d35343b5d9400f1@o4505081351176192.ingest.sentry.io/4505081354190848';
  //       options.tracesSampleRate = 1.0;
  //       // options.reportPackages = false;
  //       // options.addInAppInclude('khalil');
  //       // options.considerInAppFramesByDefault = false;
  //     },
  //   );
  //   runApp(DefaultAssetBundle(
  //       bundle: SentryAssetBundle(enableStructuredDataTracing: true),
  //       child: MyApp()));
  // }, (error, stackTrace) async {
  //   await Sentry.captureException(error, stackTrace: stackTrace);
  //   FirebaseCrashlytics.instance.recordError(error, stackTrace);
  // });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()?.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    for (int i = DateTime.now().year + 1; i > DateTime.now().year - 50; i--) {
      Vehicle.years.add(DropdownMenuItem<int>(
        child: Text(i.toString()),
        value: i,
      ));
    }
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        showNotificationMessage(message);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        debugPrint("initializing service request page");
      } on SocketException catch (_) {
        HelpooInAppNotification.showErrorMessage(message: "Network Error".tr);
        // Get.snackbar("Error".tr, "Network Error".tr);
      } catch (e) {
        debugPrint(e.toString());
      }

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        if (CurrentUser.isDriver) {
          driverCubit.getRequests();
        }
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showNotificationMessage(message);
    });

    FirebaseMessaging.instance
        .getToken()
        .then((value) => {CurrentUser.fcmToken = value ?? ''});
  }

  Key key = UniqueKey();

  restartApp() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      key = UniqueKey();
      navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'navigatorKey');
    });
  }

  void showNotificationMessage(RemoteMessage message) {
    if (message.notification != null) {
      if (message.notification!.title != null &&
          message.notification!.body != null) {
        HelpooInAppNotification.showMessage(
            message: message.notification!.body!);
        // Get.snackbar(message.notification!.title!, message.notification!.body!);
      }
    }
  }

  GetStorage prefs = GetStorage();
  String str = "";

  // bool working = true;
  Future checkFirstSeen() async {
    str = await prefs.read("seen") ?? "";
    bool _seen = str.isNotEmpty;

    if (_seen == false) {
      setState(() {
        CurrentUser.working = false;
      });
    }
    setState(() {
      CurrentUser.working = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appcastURL =
        'https://raw.githubusercontent.com/jeejaykim/apispa/jeejaykim-test/test.xml';
    final cfg =
        AppcastConfiguration(url: appcastURL, supportedOS: ['android', 'ios']);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppBloc()),
        BlocProvider(create: (_) => di.sl<NewServiceRequestBloc>()),
        BlocProvider(create: (_) => FnolBloc()),
        BlocProvider(
            create: (_) => ServiceRequestBloc()..add(ServiceRequestObserve())),
        BlocProvider(create: (_) => DriverCubit()),
      ],
      child: GetMaterialApp(
        builder: BotToastInit(),
        // navigatorObservers: [
        //   SentryNavigatorObserver(),
        // ],
        routes: Routes.routes,
        navigatorKey: navigatorKey,
        translations: Translation(),
        fallbackLocale: Locale(prefs.read("lang") ?? 'ar'),
        locale: Locale(prefs.read("lang") ?? 'ar'),
        debugShowCheckedModeBanner: false,
        title: 'Helpoo'.tr,
        theme: appThemeData,
        home: BlocBuilder<AppBloc, AppBlocState>(
          builder: (context, state) {
            if (state is NetworkFailure) {
              return connectionError();
            } else if (state is NetworkSuccess) {
              return UpgradeAlert(
                upgrader: Upgrader(
                  dialogStyle: Platform.isIOS
                      ? UpgradeDialogStyle.cupertino
                      : UpgradeDialogStyle.material,
                  appcastConfig: cfg,
                  debugLogging: true,
                  showLater: false,
                  showIgnore: false,
                  minAppVersion: '2.0.0',
                ),
                child: DoubleBack(
                  condition: true,
                  child: SplashFuturePage(),
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
