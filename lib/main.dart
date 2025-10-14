import 'package:flutter/material.dart';
import 'package:machine_test/src/features/home/data/home_service.dart';
import 'package:machine_test/src/features/home/state/home_provider.dart';
import 'package:provider/provider.dart';

import 'src/app/app_theme.dart';
import 'src/app/router.dart';
import 'src/core/storage/token_storage.dart';
import 'src/features/auth/presentation/login_screen.dart';
import 'src/features/home/presentation/home_screen.dart';
import 'src/features/auth/state/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(TokenStorage())),
        // ChangeNotifierProvider(create: (_) => HomeProvider(HomeService())),
      ],
      child: MaterialApp(
        title: 'Machine Test',
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: FutureBuilder<String?>(
          future: TokenStorage().readToken(),
          builder: (context, snapshot) {
            final token = snapshot.data;
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (token == null || token.isEmpty) {
              return const LoginScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
