import 'package:mow/mow.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ctes
const _kDoneOptionNothing = 'Nada';
const _kDoneOptionGreyOut = 'Borrado Selectivo';
const _kDoneOptionDelete = 'Borrado Total';

enum DoneOptions { nothing, greyOut, delete }

class DoneSettings with Updatable {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Singleton
  DoneSettings._hidden() {
    _load();
  }
  static final DoneSettings shared = DoneSettings._hidden();

  final Map<DoneOptions, bool> _settings = {
    DoneOptions.nothing: true,
    DoneOptions.greyOut: false,
    DoneOptions.delete: false
  };

  bool operator [](DoneOptions option) {
    return _settings[option]!;
  }

  void operator []=(DoneOptions option, bool newValue) {
    if (newValue != _settings[option]) {
      // poner todo en false
      _setAllFalse();
      // asigno
      _settings[option] = newValue;
      // si todo ha quedado en falso,
      if (_areAllFalse()) {
        // activo el por defecto
        _settings[DoneOptions.nothing] = true;
      }

      // aviso del cambio
      changeState(() {
        _commit();
      });
    }
  }

  List<bool> toList() {
    return [
      _settings[DoneOptions.nothing]!,
      _settings[DoneOptions.greyOut]!,
      _settings[DoneOptions.delete]!
    ];
  }

  bool _areAllFalse() {
    return _settings[DoneOptions.nothing]! == false &&
        _settings[DoneOptions.greyOut]! == false &&
        _settings[DoneOptions.delete]! == false;
  }

  void _setAllFalse() {
    _settings[DoneOptions.nothing] = false;
    _settings[DoneOptions.greyOut] = false;
    _settings[DoneOptions.delete] = false;
  }

  // Shared Preferences
  Future<void> _commit() async {
    // Guarda "en segundo plano" en el disco

    // obtener (desempaquetar) el shared preferences
    final prefs = await _prefs;

    // guardamos
    await prefs.setBool(_kDoneOptionNothing, _settings[DoneOptions.nothing]!);
    await prefs.setBool(_kDoneOptionGreyOut, _settings[DoneOptions.greyOut]!);
    await prefs.setBool(_kDoneOptionDelete, _settings[DoneOptions.delete]!);
  }

  Future<void> _load() async {
    // carga todo del disco

    // Desempaquetamos SharedPreferences
    final prefs = await _prefs;

    // Leemos del shared preferences y lo encasquetamos en el mapa
    // Pegamos un grito, para que la UI se refresque con los nuevos datos
    changeState(() {
      _settings[DoneOptions.nothing] =
          prefs.getBool(_kDoneOptionNothing) ?? true;
      _settings[DoneOptions.greyOut] =
          prefs.getBool(_kDoneOptionGreyOut) ?? false;
      _settings[DoneOptions.delete] =
          prefs.getBool(_kDoneOptionDelete) ?? false;
    });
  }
}
