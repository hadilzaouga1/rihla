import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/destination.dart';

class FavorisModel extends ChangeNotifier {
  static const _cle = 'favoris';

  final Map<String, Destination> _favoris = {};

  List<Destination> get liste =>
      List<Destination>.unmodifiable(_favoris.values);

  int get nombre => _favoris.length;

  bool estFavori(Destination d) => _favoris.containsKey(d.id);

  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    final textes = prefs.getStringList(_cle) ?? [];
    for (final texte in textes) {
      final d = Destination.fromJson(jsonDecode(texte) as Map<String, dynamic>);
      _favoris[d.id] = d;
    }
    notifyListeners();
  }

  Future<void> _sauvegarder() async {
    final prefs = await SharedPreferences.getInstance();
    final textes = _favoris.values.map((d) => jsonEncode(d.toJson())).toList();
    await prefs.setStringList(_cle, textes);
  }

  bool gererFavori(Destination d) {
    debugPrint('Basculement du favori pour: ${d.id}');
    final bool ajoute = !_favoris.containsKey(d.id);

    if (ajoute) {
      _favoris[d.id] = d;
    } else {
      _favoris.remove(d.id);
    }

    _sauvegarder();
    notifyListeners();
    return ajoute;
  }
}
