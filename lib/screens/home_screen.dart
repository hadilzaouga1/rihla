import 'package:flutter/material.dart';
import '../data/destinations.dart';
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/hero_banner.dart';
import '../widgets/section_title.dart';
import '../widgets/destination_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const HomeHeader(prenom: 'Hadil'),
            const SizedBox(height: 20),
            const SearchBox(),
            const SizedBox(height: 20),
            HeroBanner(destination: destinations.first),
            const SizedBox(height: 24),
            const SectionTitle(titre: 'Catégories'),
            const SizedBox(height: 12),
            const SectionTitle(titre: 'Populaires', action: 'Voir tout'),
            const SizedBox(height: 12),
            for (final d in destinations) DestinationCard(destination: d),
          ],
        ),
      ),
    );
  }
}