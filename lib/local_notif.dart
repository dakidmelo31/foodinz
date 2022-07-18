import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CloudMsgService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  static Future<void> _requestPermission() async {
    if (Platform.isAndroid) return;

    await _messaging.requestPermission();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;
  static Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  static Future<void> initialize(
    SelectNotificationCallback onSelectNotification,
  ) async {
    debugPrint(await _messaging.getToken());
    await _requestPermission();

    await _initializeLocalNotification(onSelectNotification);
    await _configureAndroidChannel();

    await _openInitialScreenFromMessage(onSelectNotification);
  }

  static void invokeLocalNotification(RemoteMessage remoteMessage) async {
    debugPrint("Received notification ${remoteMessage.data}");
    RemoteNotification? notification = remoteMessage.notification;
    AndroidNotification? android = remoteMessage.notification?.android;

    if (notification != null && android != null) {
      await _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails("channel", "Foodin City",
              icon: android.smallIcon),
        ),
        payload: jsonEncode(
          remoteMessage.data,
        ),
      );
    }
  }

  static Future<void> _configureAndroidChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      "FoodinCityChannel",
      "Main Foodin News",
      description: "every food you need is right here for you.",
      importance: Importance.max,
    );

    await _localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _openInitialScreenFromMessage(
    SelectNotificationCallback onSelectNotification,
  ) async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage?.data != null) {
      onSelectNotification(jsonEncode(initialMessage!.data));
    }
  }

  static Future<void> _initializeLocalNotification(
    SelectNotificationCallback onSelectNotification,
  ) async {
    const android = AndroidInitializationSettings(
      "ic_launcher",
    );
    const ios = IOSInitializationSettings();
    const initSetting = InitializationSettings(android: android, iOS: ios);

    await _localNotification.initialize(initSetting,
        onSelectNotification: onSelectNotification);
  }
}
