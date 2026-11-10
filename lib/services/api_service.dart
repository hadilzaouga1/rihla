import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/destination.dart';
import '../models/reservation.dart';

class ApiService {
  static Uri _uri(String chemin) => Uri.parse('${ApiConfig.baseUrl}$chemin');

  static Future<List<Destination>> getDestinations() async {
    final reponse = await http
        .get(_uri('/destinations'))
        .timeout(ApiConfig.timeout);
    if (reponse.statusCode != 200) {
      throw Exception('Erreur ${reponse.statusCode}');
    }
    final List<dynamic> liste = jsonDecode(utf8.decode(reponse.bodyBytes));

    return liste
        .map((e) => Destination.fromJson(e as Map<String, dynamic>))
        .toList();
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
