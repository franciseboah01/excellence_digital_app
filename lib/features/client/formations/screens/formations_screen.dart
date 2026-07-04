import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/formation.dart';

class FormationsScreen extends ConsumerStatefulWidget {
  const FormationsScreen({super.key});

  @override
  ConsumerState<FormationsScreen> createState() => _FormationsScreenState();
}

class _FormationsScreenState extends ConsumerState<FormationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Formations'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'En cours'),
            Tab(text: 'Catalogue'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMesFormations(),
          _buildCatalogue(),
        ],
      ),
    );
  }

  Widget _buildMesFormations() {
    // Données mockées pour l'UI
    final formations = [
      {'titre': 'Excel Avancé', 'module': 'Bureautique', 'statut': 'Actif', 'progression': 0.65},
      {'titre': 'Développement Web', 'module': 'Programmation', 'statut': 'En attente', 'progression': 0.0},
      {'titre': 'Design Graphique', 'module': 'Création', 'statut': 'Actif', 'progression': 0.35},
    ];

    return formations.isEmpty
        ? _buildEmptyState('🎓', 'Aucune formation en cours', 'Explorez le catalogue pour commencer')
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: formations.length,
            itemBuilder: (context, index) {
              final f = formations[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: EdcTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.school, color: Colors.white),
                  ),
                  title: Text(f['titre']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('📚 ${f['module']}', style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 8),
                      if (f['progression'] as double > 0)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: f['progression'] as double,
                            backgroundColor: EdcTheme.border,
                            color: EdcTheme.success,
                            minHeight: 6,
                          ),
                        ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (f['statut'] == 'Actif' ? EdcTheme.success : EdcTheme.warning).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      f['statut']!,
                      style: TextStyle(
                        color: f['statut'] == 'Actif' ? EdcTheme.success : EdcTheme.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: Duration(ms: index * 100)).slideX(begin: -20, end: 0);
            },
          );
  }

  Widget _buildCatalogue() {
    final catalogue = [
      {'titre': 'Python Débutant', 'module': 'Programmation', 'duree': '6 semaines', 'prix': '50 000 FCFA'},
      {'titre': 'Photoshop Pro', 'module': 'Design', 'duree': '4 semaines', 'prix': '35 000 FCFA'},
      {'titre': 'Community Management', 'module': 'Marketing', 'duree': '8 semaines', 'prix': '45 000 FCFA'},
      {'titre': 'WordPress', 'module': 'Web', 'duree': '5 semaines', 'prix': '40 000 FCFA'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: catalogue.length,
      itemBuilder: (context, index) {
        final f = catalogue[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f['titre']!, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text('📚 ${f['module']} • ⏱ ${f['duree']}', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: EdcTheme.accentGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(f['prix']!, style: const TextStyle(color: EdcTheme.accentGold, fontWeight: FontWeight.w700, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    child: const Text('S\'inscrire'),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: Duration(ms: index * 100)).scale();
      },
    );
  }

  Widget _buildEmptyState(String emoji, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}