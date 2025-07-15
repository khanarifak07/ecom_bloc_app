import 'package:ecom_app_bloc/src/providers/theme/theme.dart';
import 'package:ecom_app_bloc/src/providers/theme_provider.dart';
import 'package:ecom_app_bloc/src/screens/quotes/quote_home_page_wrapper.dart';
import 'package:ecom_app_bloc/src/services/notification_service.dart';
import 'package:ecom_app_bloc/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // final config = ClarityConfig(
  //   projectId: 'sbm7t25omg',
  //   logLevel: LogLevel.Verbose,
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotifications();
  await Utils.initSF();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: MaterialTheme.lightMediumContrastScheme()),
      darkTheme: ThemeData(
        colorScheme: MaterialTheme.darkMediumContrastScheme(),
      ),
      themeMode: Provider.of<ThemeProvider>(context).isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: QuoteHomePageWrapper(),
    );
  }
}
