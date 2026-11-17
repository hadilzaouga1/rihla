import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/destination.dart';
import '../providers/favoris_model.dart';

class FavoriteButton extends StatelessWidget {
  final Destination destination;

  const FavoriteButton({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final favori = context.watch<FavorisModel>().estFavori(destination);

    return IconButton(
      icon: Icon(
        favori ? Icons.favorite : Icons.favorite_border,
        color: favori ? Colors.red : null,
      ),
      onPressed: () {
        context.read<FavorisModel>().basculer(destination);
      },
    );
  }
}
