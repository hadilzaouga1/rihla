import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favoris_model.dart';
import '../providers/reglages_model.dart';
import '../services/api_service.dart';

class HomeHeader extends StatelessWidget {
  final String prenom;

  const HomeHeader({super.key, required this.prenom});

  Future<void> _effacer(BuildContext context) async {
    final favoris = context.read<FavorisModel>();
    final messenger = ScaffoldMessenger.of(context);

    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Effacer les données ?'),
        content: const Text(
          "Les favoris et les destinations enregistrées sur l'appareil "
          'seront supprimés.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );

    if (confirme == true) {
      await favoris.vider();
      await ApiService.effacerCache();
      messenger.showSnackBar(const SnackBar(content: Text('Données effacées')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO 1
              Text(
                'Ahlan, $prenom 👋',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              // TODO 2
              Text(
                "Où partez-vous\naujourd'hui ?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Effacer les données',
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _effacer(context),
        ),
        IconButton(
          tooltip: 'Changer de thème',
          icon: Icon(
            context.watch<ReglagesModel>().sombre
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () => context.read<ReglagesModel>().basculerTheme(),
        ),
        const SizedBox(width: 4),
        // TODO 3
        CircleAvatar(
          radius: 26,
          backgroundColor: cs.primaryContainer,
          child: Text(
            prenom[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ],
    );
  }
}
