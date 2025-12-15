import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/auth_wrapper.dart';
import 'config/app_theme.dart';
import 'screens/firebase_options.dart';
import 'providers/favorites_provider.dart';
import 'services/favorites_service.dart';
import 'config/globals.dart' as globals;

// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Sync globals.userEmail with Firebase Auth on startup
  _syncUserEmail();
  
  // Listen to auth state changes and keep globals.userEmail in sync
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    globals.userEmail = user?.email ?? '';
    print('Auth state changed - User email: ${globals.userEmail}');
  });
  
  runApp(const MyApp());
}

/// Sync globals.userEmail with current Firebase Auth user
void _syncUserEmail() {
  final currentUser = FirebaseAuth.instance.currentUser;
  globals.userEmail = currentUser?.email ?? '';
  print('Initial auth sync - User email: ${globals.userEmail}');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FavoritesProvider _favoritesProvider;

  @override
  void initState() {
    super.initState();
    _favoritesProvider = FavoritesProvider(
      FavoritesService(FirebaseFirestore.instance),
    );
    
    // Listen to auth state changes and load favorites
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user?.email != null) {
        _favoritesProvider.loadFavorites(user!.email!);
      } else {
        _favoritesProvider.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _favoritesProvider,
      child: MaterialApp(
        title: 'Kaleidoscope Collaborative',
        theme: AppTheme.getThemeData(),
        home: const AuthWrapper(),
      ),
    );
  }
}
