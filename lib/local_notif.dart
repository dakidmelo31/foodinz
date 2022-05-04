import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';

Future initAwesomeNotification() async {
  await AwesomeNotifications().initialize('resource://drawable/ic_launcher', [
    NotificationChannel(
      channelKey: "scheduled",
      channelName: "All notifications",
      channelDescription: "Notification with information about status",
      enableVibration: true,
      defaultRingtoneType: DefaultRingtoneType.Alarm,
    ),
  ]);

  Future<void> showNotificationAtScheduledTime(
      {required int id,
      required BuildContext context,
      required String title,
      required String content}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: "scheduled",
          title: title,
          body: content,
          payload: {"$title": "$content"},
          autoDismissible: false,
          displayOnBackground: true,
          displayOnForeground: true,
          wakeUpScreen: true),
      actionButtons: [
        NotificationActionButton(
            key: "1",
            label: "Cancel",
            autoDismissible: true,
            buttonType: ActionButtonType.Default)
      ],
      schedule: NotificationCalendar.fromDate(
        date: DateTime.now().add(
          Duration(
            seconds: 5,
          ),
        ),
      ),
    );
  }
}
