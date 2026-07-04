import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/network/api_client.dart';
import 'core/services/connectivity_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase pour les notifications
  await Firebase.initializeApp();

  // Initialiser le client API
  ApiClient.instance;

  // Initialiser le service de connectivité
  ConnectivityService.instance;

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
      navigatorKey: navigatorKey,
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
