import 'package:flutter/material.dart';
import '../models/destination.dart';

class HeroBanner extends StatelessWidget {
  final Destination destination;

  const HeroBanner({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(destination.image, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),

            // TODO 1 
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      destination.note.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // TODO 2 
            Positioned(
              left: 20,
              right: 130,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'DESTINATION DU MOIS',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    destination.nom,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        destination.region,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bouton Découvrir
            Positioned(
              right: 16,
              bottom: 20,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Découvrir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}