import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'core/services/storage_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/emergency_repository.dart';
import 'data/providers/app_state_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final storageService = await StorageService.init();
  final authRepository = AuthRepository(storageService);
  final emergencyRepository = EmergencyRepository(storageService);

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<AuthRepository>.value(value: authRepository),
        Provider<EmergencyRepository>.value(value: emergencyRepository),
        ChangeNotifierProvider<AppStateProvider>(
          create: (_) => AppStateProvider(
            authRepository: authRepository,
            emergencyRepository: emergencyRepository,
          ),
        ),
      ],
      child: const CareLinkApp(),
    ),
  );
}
