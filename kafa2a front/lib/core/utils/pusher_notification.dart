import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

@injectable
class PusherService {
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Dio _dio;
  final AuthLocalDataSource _authLocalDataSource;

  PusherService(this._dio, this._authLocalDataSource);

  Future<void> init({required int userId}) async {
    // 1. Create notification channel (Android 8+)
    const androidChannel = AndroidNotificationChannel(
      'pusher_channel_id',
      'Pusher Channel',
      description: 'Channel for real-time provider offers',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // 2. Request Android permissions
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // 3. Request iOS permissions
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // 4. Initialize local notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // 5. Initialize Pusher
    try {
      await _pusher.init(
        apiKey: 'f99d5ccf2272f5bd7621',
        cluster: 'eu',

        onConnectionStateChange: (currentState, previousState) async {
          if (currentState == "CONNECTED") {
            try {
              await _pusher.subscribe(
                channelName: 'private-user.$userId',
                onEvent: (event) {
                  flutterLocalNotificationsPlugin.show(
                    0,
                    "New Notification",
                    "You received: ${event.eventName}",
                    const NotificationDetails(
                      android: AndroidNotificationDetails(
                        'pusher_channel_id',
                        'Pusher Channel',
                        importance: Importance.high,
                        priority: Priority.high,
                      ),
                      iOS: DarwinNotificationDetails(),
                    ),
                  );
                },
              );
            } catch (e) {}
          }
        },

        onError: (message, code, error) {},

        onSubscriptionSucceeded: (channelName, data) {},

        onEvent: (event) {},

        // ✅ Private channel authorizer (connects to Laravel)
        onAuthorizer: (channelName, socketId, options) async {
          try {
            final response = await _dio.post(
              "http://10.0.2.2:8000/broadcasting/auth", // Laravel endpoint
              options: Options(
                headers: {
                  'Authorization': 'Bearer ${_authLocalDataSource.getToken()}',
                  'Accept': 'application/json',
                },
              ),
              data: {
                'socket_id': socketId,
                'channel_name': channelName,
              },
            );
            return response.data;
          } catch (e) {}
        },
      );

      // 6. Connect after init
      await _pusher.connect();
    } catch (e) {}
  }

  Future<void> disconnect() async {
    await _pusher.disconnect();
  }
}
