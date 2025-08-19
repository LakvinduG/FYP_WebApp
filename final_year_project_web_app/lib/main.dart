import 'package:flutter/material.dart';
import 'screens/splash_screen/splash.dart';
import 'screens/login_screen/login.dart';
import 'screens/register_screen/register.dart';
import 'screens/manufacturing_Info_screen/manufacturing_info.dart';
import 'screens/product_Info_screen/product_info.dart';


/// Entry point of the Shelf Life Web Application.
/// 
/// Initializes the app and runs the root widget.
void main() {
  runApp(const MyApp());
}

/// Root widget of the Shelf Life Web Application.
///
/// Defines theme, routes, and global app configuration.
/// Wraps every screen with a common background image for consistency.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application title displayed in browser tab
      title: 'Shelf Life',
      // Global theme settings
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.purple[50],
      ),
      debugShowCheckedModeBanner: false,
      // Initial route when the app launches
      initialRoute: '/splash',
      // Define application routes
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/manufacturing': (context) => ManufacturingInfoScreen(),
        '/product': (context) => ProductInformationScreen(),
      },
      // Wrap every screen with a background image
      builder: (context, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/webbackground_white.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // The actual content of the app
            child ?? Container(),
          ],
        );
      },
    );
  }
}
