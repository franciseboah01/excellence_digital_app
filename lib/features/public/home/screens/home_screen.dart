import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/screens/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            floating: true,
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: EdcTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('EDC', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Excellence Digital Center', style: TextStyle(fontSize: 14)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: const Text('Connexion'),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  child: const Text('S\'inscrire', style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
          
          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              decoration: const BoxDecoration(gradient: EdcTheme.heroGradient),
              child: Column(
                children: [
                  Text(
                    'Former • Créer • Réussir',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: EdcTheme.primaryLight,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 20, end: 0),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    'Services bureautiques, digital et formation',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                  
                  const SizedBox(height: 32),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.work_outline),
                        label: const Text('Nos Services'),
                      ).animate().fadeIn(duration: 500.ms, delay: 400.ms).scale(),
                      
                      const SizedBox(width: 16),
                      
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.school_outlined),
                        label: const Text('Formations'),
                      ).animate().fadeIn(duration: 500.ms, delay: 500.ms).scale(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(context, '150+', 'Clients', Icons.people),
                  _buildStat(context, '50+', 'Formations', Icons.school),
                  _buildStat(context, '30+', 'Services', Icons.work),
                  _buildStat(context, '24/7', 'Support', Icons.support_agent),
                ],
              ),
            ),
          ),
          
          // Section Services
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nos Services', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text('Des solutions adaptées à vos besoins', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildServiceCard(context, 'Création de CV', 'CV professionnels et modernes', Icons.description),
                        const SizedBox(width: 12),
                        _buildServiceCard(context, 'Mise en page Word', 'Documents impeccables', Icons.article),
                        const SizedBox(width: 12),
                        _buildServiceCard(context, 'Logo & Design', 'Identité visuelle unique', Icons.brush),
                        const SizedBox(width: 12),
                        _buildServiceCard(context, 'Site Web', 'Présence en ligne pro', Icons.web),
                        const SizedBox(width: 12),
                        _buildServiceCard(context, 'Formation Excel', 'Maîtrisez les tableurs', Icons.table_chart),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
          
          // CTA
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: EdcTheme.primaryGradient,
                borderRadius: BorderRadius.circular(EdcTheme.radiusLg),
              ),
              child: Column(
                children: [
                  const Icon(Icons.rocket_launch, size: 48, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    'Prêt à commencer ?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rejoignez-nous et donnez vie à vos projets',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: EdcTheme.primary,
                    ),
                    child: const Text('Commencer maintenant'),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 30, end: 0),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),
      
      // WhatsApp flottant
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          launchUrl(Uri.parse('https://wa.me/2250700000000'));
        },
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: EdcTheme.primaryLight, size: 28),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String subtitle, IconData icon) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EdcTheme.bgCard,
        borderRadius: BorderRadius.circular(EdcTheme.radius),
        border: Border.all(color: EdcTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: EdcTheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: EdcTheme.primaryLight, size: 24),
          ),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}