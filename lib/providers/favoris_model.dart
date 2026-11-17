import 'package:flutter/foundation.dart';
import '../models/destination.dart';

class FavorisModel extends ChangeNotifier {
  final Map<String, Destination> _favoris = {};

  List<Destination> get liste =>
      List<Destination>.unmodifiable(_favoris.values);

  int get nombre => _favoris.length;

  bool estFavori(Destination d) => _favoris.containsKey(d.id);

  bool basculer(Destination d) {
    debugPrint('Basculement du favori pour: ${d.id}');
    final bool ajoute = !_favoris.containsKey(d.id);

    if (ajoute) {
      _favoris[d.id] = d;
    } else {
      _favoris.remove(d.id);
    }

    notifyListeners();
    return ajoute;
  }
}
