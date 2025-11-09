import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/accessible_form.dart';

void main() {
  runApp(const MyAccessibleApp());
}

class MyAccessibleApp extends StatelessWidget {
  const MyAccessibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configuración global de accesibilidad
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'App Accesible Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, height: 1.5),
          bodyMedium: TextStyle(fontSize: 14, height: 1.5),
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: const AccessibleFormScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
