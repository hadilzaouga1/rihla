import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favoris_model.dart';
import '../widgets/favorite_button.dart';

class FavorisScreen extends StatelessWidget {
  const FavorisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorisModel = context.watch<FavorisModel>();

    if (favorisModel.liste.isEmpty) {
      return const Center(
        child: Text('Touchez ♥ sur une destination pour l\'ajouter'),
      );
    }

    return ListView.builder(
      itemCount: favorisModel.liste.length,
      itemBuilder: (context, index) {
        final d = favorisModel.liste[index];
        return ListTile(
          leading: Image.asset(
            d.image,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
          title: Text(d.nom),
          subtitle: Text('${d.region} • ${d.note} ★'),
          trailing: FavoriteButton(
            destination: d,
          ), // Permet de retirer le favori
        );
      },
    );
  }
}
