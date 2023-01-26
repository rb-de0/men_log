import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:men_log/view/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(tileColor: Colors.black12),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: Colors.green, foregroundColor: Colors.white),
        colorScheme: const ColorScheme.light().copyWith(primary: Colors.green, error: Colors.red),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
      ),
      darkTheme: ThemeData.dark().copyWith(
        listTileTheme: const ListTileThemeData(tileColor: Colors.black12),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: Colors.green, foregroundColor: Colors.white),
        colorScheme: const ColorScheme.dark().copyWith(primary: Colors.green, error: Colors.red),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
      ),
      themeMode: ThemeMode.system,
      home: const Home(),
    );
  }
}
