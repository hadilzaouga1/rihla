import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/destination.dart';
import '../models/reservation.dart';

class ApiService {
  static Uri _uri(String chemin) => Uri.parse('${ApiConfig.baseUrl}$chemin');

  static const _cleCache = 'cache_destinations';

  static bool depuisCache = false;

  static List<Destination> _decoder(String corps) => (jsonDecode(corps) as List)
      .map((e) => Destination.fromJson(e as Map<String, dynamic>))
      .toList();

  /// Réseau d'abord, cache en secours.
  static Future<List<Destination>> getDestinations() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final reponse = await http
          .get(_uri('/destinations'))
          .timeout(ApiConfig.timeout);

      if (reponse.statusCode != 200) {
        throw Exception('Erreur ${reponse.statusCode}');
      }

      final corps = utf8.decode(reponse.bodyBytes);
      // TODO 4 : on mémorise le JSON brut, seulement après un 200
      await prefs.setString(_cleCache, corps);
      depuisCache = false;
      return _decoder(corps);
    } catch (e) {
      // TODO 5 : pas de cache -> on relance l'erreur (écran d'erreur du TP5)
      final cache = prefs.getString(_cleCache);
      if (cache == null) rethrow;
      // TODO 6 : sinon on signale le mode hors-ligne et on décode le cache
      depuisCache = true;
      return _decoder(cache);
    }
  }

  static Future<String> creerReservation(Reservation reservation) async {
    final reponse = await http
        .post(
          _uri('/reservations'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(reservation.toJson()),
        )
        .timeout(ApiConfig.timeout);

    if (reponse.statusCode != 201) {
      throw Exception('Erreur ${reponse.statusCode}');
    }

    final Map<String, dynamic> creee = jsonDecode(
      utf8.decode(reponse.bodyBytes),
    );
    return creee['id'].toString();
  }
}
