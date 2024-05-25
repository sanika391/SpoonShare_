import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spoonshare/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoonshare/screens/dashboard/dashboard_home.dart';
import 'package:spoonshare/screens/home/home_page.dart';
import 'package:spoonshare/splash_screen.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'screens/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Spoon Share',
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        theme: theme,
        darkTheme: darkTheme,
        home: const HomePage(name: '', role: ''),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
