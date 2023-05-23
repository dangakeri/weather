import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/providers/temp_settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListTile(
          title: const Text('Temperature Unit'),
          subtitle: const Text('Celcius/Fahrenheit (Default: celcius)'),
          trailing: Switch(
              value: context.watch<TempSettingsProvider>().state.tempUnit ==
                  TempUnit.celsius,
              onChanged: (_) {
                context.read<TempSettingsProvider>().toggleTempUnit();
              }),
        ),
      ),
    );
  }
}
