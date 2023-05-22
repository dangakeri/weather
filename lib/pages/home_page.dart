import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/consts/constants.dart';
import 'package:weather/pages/search_page.dart';
import 'package:weather/providers/weather_provider.dart';
import 'package:weather/widgets/error_dialog.dart';

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
      errorDialog(context, ws.error.errMsg);
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

  String showTemperature(double temperature) {
    return temperature.toStringAsFixed(1) + ' ℃';
  }

  Widget showIcon(String abbr) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'https://$kHost/static/img/weather/png/64/$abbr.png',
      width: 64,
      height: 64,
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
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 6),
        Text(
          weatherState.weather.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          TimeOfDay.fromDateTime(weatherState.weather.lastUpdated)
              .format(context),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18.0),
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              showTemperature(weatherState.weather.theTemp),
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                Text(
                  showTemperature(weatherState.weather.maxTemp),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  showTemperature(weatherState.weather.minTemp),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            showIcon(weatherState.weather.weatherStateAbbr),
            Text(
              weatherState.weather.weatherStateName,
              style: TextStyle(fontSize: 32),
            ),
          ],
        ),
      ],
    );
  }
}
