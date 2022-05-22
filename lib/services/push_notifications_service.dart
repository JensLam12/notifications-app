import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
	static FirebaseMessaging messaging = FirebaseMessaging.instance;
	static String? token;
	static StreamController<String> _messageStreamController = StreamController.broadcast();
	static Stream<String> get messageStream => _messageStreamController.stream;

	static const AndroidNotificationChannel channel = AndroidNotificationChannel(
		'high_importance_channel', // id
		'High Importance Notifications', // title
		//'This channel is used for important notifications.', // description
		importance: Importance.max,
		description: 'This channel is used for important notifications.'
  	);
 
	static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
		FlutterLocalNotificationsPlugin();

	static Future _backgroundHandler( RemoteMessage message ) async {
		_messageStreamController.add( message.data['producto'] ?? 'No data');
	}

	static Future _onMessageHandler( RemoteMessage message ) async {
		await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>() ?.createNotificationChannel(channel);
	
		RemoteNotification? notification = message.notification;
		String url = notification!.android!.imageUrl!;
		String iconName = AndroidInitializationSettings('@mipmap/ic_launcher').defaultIcon.toString();
	
		// Si `onMessage` es activado con una notificación, construimos nuestra propia
		// notificación local para mostrar a los usuarios, usando el canal creado.
		if (notification != null) {
			flutterLocalNotificationsPlugin.show(
				notification.hashCode,
				notification.title,
				notification.body,
				NotificationDetails(
					android: AndroidNotificationDetails(
						channel.id,
						channel.name,
						//description: channel.description,
						channelDescription: channel.description,
						icon: iconName
					),
				)
			);
		}
		_messageStreamController.add( message.data['producto'] ?? 'No data');
	}

	static Future _onMessageOpenApp( RemoteMessage message ) async {
		_messageStreamController.add( message.data['producto'] ?? 'No data');
	}

	static Future initializeApp() async {
		//Push Notifications
		await Firebase.initializeApp();
    	await messaging.getInitialMessage();
		
		token = await FirebaseMessaging.instance.getToken();
		print("Token $token");

		// Handlers
		FirebaseMessaging.onBackgroundMessage( _backgroundHandler );
		FirebaseMessaging.onMessage.listen( _onMessageHandler );
		FirebaseMessaging.onMessageOpenedApp.listen( _onMessageOpenApp );

		//Local Notifications
	}

	static closeStreams() {
		_messageStreamController.close();
	}
}