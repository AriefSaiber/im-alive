import 'package:flutter/material.dart';

import 'features/check_in/check_in_home_screen.dart';

class ImAliveApp extends StatelessWidget {
  const ImAliveApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF247C5A),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "I'm Alive",
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7FAF8),
        appBarTheme: const AppBarTheme(centerTitle: false),
      ),
      home: const CheckInHomeScreen(),
    );
  }
}
