import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/auth_provider.dart';
import 'router/app_router.dart';
import 'services/procurement_service.dart';
import 'services/supabase_service.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase backend — real project credentials
  const supabaseUrl = 'https://zxwhkgcrtlvemqabcint.supabase.co';
  const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp4d2hrZ2NydGx2ZW1xYWJjaW50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI1MjAwNDgsImV4cCI6MjA5ODA5NjA0OH0.8iltsthzwByjGGTPelQ_Bm3JhgeS-7N07fYKI1N9360';
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseService = SupabaseService();

    return MultiProvider(
      providers: [
        Provider(create: (_) => ProcurementService()),
        Provider<SupabaseService>.value(value: supabaseService),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(supabaseService: supabaseService),
        ),
      ],
      child: MaterialApp.router(
        title: 'KoreNex',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}