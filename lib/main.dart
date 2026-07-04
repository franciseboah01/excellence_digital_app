import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: ExcellenceDigitalApp(),
    ),
  );
}

class ExcellenceDigitalApp extends ConsumerWidget {
  const ExcellenceDigitalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Excellence Digital Center',
      debugShowCheckedModeBanner: false,
      theme: EdcTheme.darkTheme,
      home: const AppShell(),
    );
  }
}