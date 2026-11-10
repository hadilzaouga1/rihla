import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../widgets/favorite_button.dart';
import '../models/reservation.dart';
import 'reservation_screen.dart';
import '../services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final Destination destination;

  const DetailScreen({super.key, required this.destination});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _voyageurs = 2;

  // Réserver et récupérer la réservation
  Future<void> _reserver() async {
    final reservation = await Navigator.push<Reservation>(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationScreen(
          destination: widget.destination,
          voyageurs: _voyageurs,
        ),
      ),
    );

    // TODO 3 : si null, s'arrêter
    if (reservation == null) return;

    // TODO 4 : si l'écran n'est plus affiché, s'arrêter
    if (!mounted) return;

    // TODO 5 : appeler l'API et récupérer l'ID
    final String id;
    try {
      id = await ApiService.creerReservation(reservation);
    } catch (e) {
      if (!mounted) return;
      // TODO 6 : SnackBar rouge en cas d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Envoi impossible : json-server est-il lancé ?'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return; // pas de confirmation si rien n'est enregistré
    }

    if (!mounted) return;

    // Affichage de la confirmation avec le numéro de réservation
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Réservation confirmée'),
        content: Text(
          '${reservation.nom}, votre séjour à '
          '${reservation.destination.nom} est enregistré.\n\n'
          '${reservation.voyageurs} voyageur(s) · ${reservation.formule}\n'
          'Total : ${reservation.total} DT\n'
          'Confirmation envoyée à ${reservation.email}.\n\n'
          'N° de réservation : $id',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Parfait'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final d = widget.destination;
    final total = d.prix * _voyageurs;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 340,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: 'image-${d.nom}',
                    child: Image.asset(d.image, fit: BoxFit.cover),
                  ),
                ),

                // Bouton retour
                Positioned(
                  top: 16,
                  left: 16,
                  child: SafeArea(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        tooltip: 'Retour',
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ),

                // Bouton favori
                Positioned(
                  top: 16,
                  right: 16,
                  child: SafeArea(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: const FavoriteButton(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom et note
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        d.nom,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(d.note.toString()),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Région
                Row(
                  children: [
                    Icon(
                      Icons.place_outlined,
                      size: 16,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      d.region,
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Informations du voyage
                Row(
                  children: [
                    Expanded(
                      child: _Tuile(
                        icone: Icons.schedule,
                        label: 'Durée',
                        valeur: d.duree,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _Tuile(
                        icone: Icons.category_outlined,
                        label: 'Type',
                        valeur: d.categorie,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: _Tuile(
                        icone: Icons.group_outlined,
                        label: 'Groupe',
                        valeur: 'Max 12',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // À propos
                Text(
                  'À propos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(d.description),

                const SizedBox(height: 24),

                // Nombre de voyageurs
                Row(
                  children: [
                    Text(
                      'Voyageurs',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    IconButton.outlined(
                      onPressed: _voyageurs > 1
                          ? () => setState(() => _voyageurs--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '$_voyageurs',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),

                    IconButton.outlined(
                      onPressed: () {
                        setState(() {
                          if (_voyageurs < 12) {
                            _voyageurs++;
                          }
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // Barre de réservation
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total', style: TextStyle(color: cs.onSurfaceVariant)),

                  Text(
                    '$total DT',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Bouton Réserver
              FilledButton(
                onPressed: _reserver,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text('Réserver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tuile d'information
class _Tuile extends StatelessWidget {
  final IconData icone;
  final String label;
  final String valeur;

  const _Tuile({
    required this.icone,
    required this.label,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icone, color: cs.primary),

          const SizedBox(height: 4),

          Text(
            label,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
          ),

          Text(valeur, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
