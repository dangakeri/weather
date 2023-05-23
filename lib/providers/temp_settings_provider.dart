import 'package:flutter/material.dart';

enum TempUnit {
  celsius,
  fahrenheit,
}

class TempSettingsState {
  final TempUnit tempUnit;
  TempSettingsState({
    this.tempUnit = TempUnit.celsius,
  });
  factory TempSettingsState.initial() {
    return TempSettingsState();
  }
  List<Object> get props => [tempUnit];
  bool get stringify => true;

  TempSettingsState copyWith({
    TempUnit? tempUnit,
  }) {
    return TempSettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
    );
  }
}

class TempSettingsProvider with ChangeNotifier {
  TempSettingsState _state = TempSettingsState.initial();
  TempSettingsState get state => _state;
  void toggleTempUnit() {
    _state = _state.copyWith(
      tempUnit: _state.tempUnit == TempUnit.celsius
          ? TempUnit.fahrenheit
          : TempUnit.celsius,
    );
    notifyListeners();
  }
}
