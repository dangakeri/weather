import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/providers/temp_settings_provider.dart';
import 'package:weather/providers/weather_provider.dart';
import 'package:weather/repositories/weather_repository.dart';
import 'package:weather/services/weather_api_services.dart';
import 'pages/home_page.dart';
import 'package:http/http.dart' as http;

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
