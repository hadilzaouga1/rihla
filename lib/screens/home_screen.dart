import 'package:flutter/material.dart';
import '../data/destinations.dart';
import '../models/destination.dart';
import '../services/api_service.dart';
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/hero_banner.dart';
import '../widgets/section_title.dart';
import '../widgets/destination_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categorie = 'Tout';
  int _onglet = 0;

  // AJOUT : Le Future qui contient la requête API
  late Future<List<Destination>> _futurDestinations;

  @override
  void initState() {
    super.initState();
    // On lance la requête UNE SEULE FOIS ici, pas dans build()
    _futurDestinations = ApiService.getDestinations();
  }

  // Méthode pour recharger (utilisée par le RefreshIndicator et le bouton Réessayer)
  Future<void> _recharger() async {
    final futur = ApiService.getDestinations();
    setState(() {
      _futurDestinations = futur;
    });
    try {
      await futur;
    } catch (_) {}
  }

  // Le filtre s'applique maintenant sur la liste reçue en paramètre
  List<Destination> _filtrer(List<Destination> toutes) {
    if (_categorie == 'Tout') return toutes;
    return toutes.where((d) => d.categorie == _categorie).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _onglet == 0
            ? _construireExplorer()
            : const Center(child: Text('Bientôt disponible')),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (index) {
          setState(() {
            _onglet = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // NOUVEAU : Le FutureBuilder gère les 3 états (attente, erreur, données)
  Widget _construireExplorer() {
    return FutureBuilder<List<Destination>>(
      future: _futurDestinations,
      builder: (context, snapshot) {
        // 1. En attente
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 2. Erreur
        if (snapshot.hasError) {
          return ErreurReseau(
            message: 'Impossible de charger les destinations.',
            onReessayer: _recharger,
          );
        }
        // 3. Données reçues
        final destinations = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _recharger,
          child: _construireAccueil(destinations),
        );
      },
    );
  }

  // MODIFIÉ : Prend la liste en paramètre
  Widget _construireAccueil(List<Destination> destinations) {
    final filtrees = _filtrer(destinations);

    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(), // Pour pouvoir tirer même si la liste est courte
      padding: const EdgeInsets.all(20),
      children: [
        const HomeHeader(prenom: 'Hadil'),
        const SizedBox(height: 20),
        const SearchBox(),
        const SizedBox(height: 20),
        // On affiche la première destination de la liste reçue du serveur
        HeroBanner(destination: destinations.first),
        const SizedBox(height: 24),

        const SectionTitle(titre: 'Catégories'),
        const SizedBox(height: 12),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final c in categories)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: _categorie == c,
                    onSelected: (_) {
                      setState(() {
                        _categorie = c;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        const SectionTitle(titre: 'Populaires', action: 'Voir tout'),
        const SizedBox(height: 12),
        // On boucle sur la liste filtrée (qui vient du serveur)
        for (final d in filtrees)
          DestinationCard(key: ValueKey(d.id), destination: d),
      ],
    );
  }
}

// NOUVEAU : Le widget d'erreur à mettre tout en bas du fichier (hors de la classe)
class ErreurReseau extends StatelessWidget {
  final String message;
  final VoidCallback onReessayer;

  const ErreurReseau({
    super.key,
    required this.message,
    required this.onReessayer,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, color: cs.error, size: 56),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            const Text(
              'Vérifiez que json-server est lancé.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onReessayer,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
