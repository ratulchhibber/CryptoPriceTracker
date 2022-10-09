import 'package:crypto_price_tracker/pages/home/home_page.dart';
import 'package:crypto_price_tracker/provider/favorite_provider.dart';
import 'package:crypto_price_tracker/provider/market_provider.dart';
import 'package:crypto_price_tracker/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crypto_price_tracker/theme/theme.dart';

import 'constant/storage/theme_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    FutureBuilder<ThemeMode>(
      future: ThemeStorage().fetch(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Directionality(
              textDirection: TextDirection.ltr,
              child: Text('Loading....'),
            );
          default:
            if (snapshot.hasError) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return MyApp(themeMode: snapshot.requireData);
            }
        }
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  ThemeMode themeMode;
  MyApp({Key? key, required this.themeMode}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MarketProvider>(
          create: (context) => MarketProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(themeMode),
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (context) => FavoriteProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: provider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
