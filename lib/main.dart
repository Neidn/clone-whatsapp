import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '/router.dart';

import '/common/utils/colors.dart';

import 'package:clone_whatsapp/common/utils/constants.dart';
import '/common/widgets/error.dart';
import '/common/widgets/loader.dart';

import '/models/user_model.dart';

import 'screens/mobile_layout_screen.dart';
import '/features/landing/screens/landing_screen.dart';
import '/features/auth/controller/auth_controller.dart';

import '/firebase_options.dart';

Future<void> init(WidgetsBinding widgetsBinding) async {
  print('Initializing...');
  timeago.setLocaleMessages('ko', timeago.KoMessages());

  await dotenv.load(fileName: configFileName);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Initializing complete!');
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await init(widgetsBinding);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: appBarColor,
          foregroundColor: textColor,
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
            data: (UserModel? userData) {
              if (userData == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (error, stackTrace) => ErrorScreen(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
