import 'destination.dart';

/// TP4 — Résultat du formulaire de réservation.
/// Il est créé par ReservationScreen puis renvoyé à l'écran précédent
/// avec Navigator.pop(context, reservation).
class Reservation {
  final String? id;
  final Destination destination;
  final String nom;
  final String email;
  final String telephone;
  final DateTime dateDepart;
  final int voyageurs;
  final String formule; // 'Essentiel' ou 'Confort'

  const Reservation({
    this.id,
    required this.destination,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.dateDepart,
    required this.voyageurs,
    required this.formule,
  });

  int get prixParPersonne => formule == 'Confort'
      ? (destination.prix * 1.3).round()
      : destination.prix;

  int get total => prixParPersonne * voyageurs;

  Map<String, dynamic> toJson() {
    return {
      'destinationId': destination.id,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'voyageurs': voyageurs,
      'formule': formule,
      'total': total,
      'dateDepart': dateDepart.toIso8601String(),
    };
  }
}
