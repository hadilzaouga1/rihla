import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/favoris_model.dart';
import 'providers/reglages_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavorisModel()..charger()),
        ChangeNotifierProvider(create: (_) => ReglagesModel()..charger()),
      ],
      child: const RihlaApp(),
    ),
  );
}

class RihlaApp extends StatelessWidget {
  const RihlaApp({super.key});

  static const Color _graine = Color(0xFF0E7C86);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rihla',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _graine),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _graine,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: context.watch<ReglagesModel>().sombre
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
