import 'package:flutter/material.dart';
import 'package:notifications_app/screens/screens.dart';
import 'package:notifications_app/services/push_notifications_service.dart';

void main() async { 
	WidgetsFlutterBinding.ensureInitialized();
	await PushNotificationService.initializeApp();
	runApp(MyApp());
}

class MyApp extends StatefulWidget {
  	const MyApp({Key? key}) : super(key: key);

	@override
	State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

	final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
	final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

	@override
	void initState() {
		super.initState();
		PushNotificationService.messageStream.listen((message) {

			navigatorKey.currentState?.pushNamed('message', arguments: message);

			final snackBar = SnackBar(content: Text(message) );
			messengerKey.currentState?.showSnackBar(snackBar);
		});
	}

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'Notifications App',
			initialRoute: 'home',
			navigatorKey: navigatorKey, // Navigate
			scaffoldMessengerKey: messengerKey, // Snacks
			routes: {
				'home': ( _ ) => const HomeScreen(),
				'message': ( _ ) => const MessageScreen()
			}
		);
	}
}