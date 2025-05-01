import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_app/screens/bookings/provider/booking_provider.dart';
import 'package:my_app/screens/machinery/provider/machinery_provider.dart';
import 'package:my_app/screens/profile/profile_screen.dart';
import 'package:my_app/utils/extension.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'core/data/machinary_rental_data_provider.dart';
import 'models/user_model.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';



//Ctrl+K to generate a command
//when i press the login button in login_screen, the login is successful showed by the snackbar but screen not changed why?, and also i call the notifyListeners() but consumer are not rebuild them selfs

//krishna9669kantdinkar@gmail.com
//Krishna9669@
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MachineryDataProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        /// MachineryProvider depends on MachineryDataProvider
        ChangeNotifierProxyProvider<MachineryDataProvider, MachineryProvider>(
          create: (_) => MachineryProvider(MachineryDataProvider()),
          update: (context, machineryDataProvider, previous) =>
              previous ?? MachineryProvider(machineryDataProvider),
        ),

        /// BookingProvider depends on MachineryDataProvider
        ChangeNotifierProxyProvider<MachineryDataProvider, BookingProvider>(
          create: (_) => BookingProvider(MachineryDataProvider()),
          update: (context, machineryDataProvider, previous) =>
              previous ?? BookingProvider(machineryDataProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Krishi Machinery Rental',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, value, child) {
          User? loginUse = context.authProvider.getLoginUsr();
          if (kDebugMode) {
            print(loginUse?.sId);
            print(loginUse?.sId == null);
          }

          return loginUse?.sId == null
              ? const LoginScreen()
              : const HomeScreen();
        },
      ),
      routes: {
        '/login': (ctx) => const LoginScreen(),
        '/home': (ctx) => const HomeScreen(),
        "/profile": (context) => ProfileScreen(),
      },
    );
  }
}
