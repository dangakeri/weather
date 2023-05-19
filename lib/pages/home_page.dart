import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/providers/weather_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  _fetchWeather() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<WeatherProvider>().fetchWeather('London');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Weather'),
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
