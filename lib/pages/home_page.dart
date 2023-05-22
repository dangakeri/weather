import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/search_page.dart';
import 'package:weather/providers/weather_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;
  late final WeatherProvider weatherProv;
  @override
  void initState() {
    super.initState();
    weatherProv = context.read<WeatherProvider>();
    weatherProv.addListener(registerListener);
  }

  @override
  void dispose() {
    weatherProv.removeListener(registerListener);
    super.dispose();
  }

  void registerListener() {
    final WeatherState ws = context.read<WeatherProvider>().state;
    if (ws.status == WeatherStatus) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(ws.error.errMsg),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Weather',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              _city = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return const SearchPage();
              }));
              if (_city != null) {
                // ignore: use_build_context_synchronously
                context.read<WeatherProvider>().fetchWeather(_city!);
              }
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: showWeather(),
    );
  }

  Widget showWeather() {
    final weatherState = context.watch<WeatherProvider>().state;
    if (weatherState.status == WeatherState.initial) {
      return const Center(
        child: Text(
          'Search a city',
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    if (weatherState.status == WeatherStatus.error &&
        weatherState.weather.title == '') {
      return const Center(
        child: Text(
          'Select a City',
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    if (weatherState.status == WeatherStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
      child: Text(
        weatherState.weather.title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
