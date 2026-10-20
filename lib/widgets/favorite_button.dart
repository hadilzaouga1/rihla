import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _favori = false;

  void _basculer() {
    setState(() {
      _favori = !_favori;
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(_favori ? 'Ajouté aux favoris' : 'Retiré des favoris'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _basculer,
      icon: Icon(
        _favori ? Icons.favorite : Icons.favorite_border,
        color: _favori ? Colors.red : null,
      ),
    );
  }
}