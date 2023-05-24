import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/providers/temp_settings_provider.dart';
import 'package:weather/providers/weather_provider.dart';
import 'package:weather/repositories/weather_repository.dart';
import 'package:weather/services/weather_api_services.dart';
import 'pages/home_page.dart';
import 'package:http/http.dart' as http;

import 'providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WeatherRepository>(create: (context) {
          final WeatherApiServices weatherApiServices = WeatherApiServices(
            httpClient: http.Client(),
          );
          return WeatherRepository(weatherApiServices: weatherApiServices);
        }),
        ChangeNotifierProvider<WeatherProvider>(
          create: (context) => WeatherProvider(
            weatherRepository: context.read<WeatherRepository>(),
          ),
        ),
        ChangeNotifierProvider<TempSettingsProvider>(
          create: (context) => TempSettingsProvider(),
        ),
        ChangeNotifierProxyProvider<WeatherProvider, ThemeProvider>(
          create: (context) => ThemeProvider(),
          update: (
            BuildContext context,
            WeatherProvider weatherProvider,
            ThemeProvider? themeProvider,
          ) =>
              themeProvider!..update(weatherProvider),
        )
      ],
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: context.watch<ThemeProvider>().state.appTheme == AppTheme.light
            ? ThemeData.light()
            : ThemeData.dark(),
        home: const HomePage(),
      ),
    );
  }
}
