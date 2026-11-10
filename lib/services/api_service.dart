import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/destination.dart';

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
}
