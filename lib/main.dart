import 'package:flutter/material.dart';
import 'package:notifications_app/screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Notifications App',
			initialRoute: 'home',
			routes: {
				'home': ( _ ) => const HomeScreen(),
				'message': ( _ ) => const MessageScreen()
			}
		);
	}
}