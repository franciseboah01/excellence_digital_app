import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/auth_service.dart';
import '../../../auth/screens/login_screen.dart';

class ClientDashboardScreen extends ConsumerStatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  ConsumerState<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends ConsumerState<ClientDashboardScreen> {
  int _selectedIndex = 0;
  
  final _pages = const [
    _DashboardContent(),
    _FormationsPlaceholder(),
    _QcmsPlaceholder(),
    _MessagesPlaceholder(),
    _ProfilePlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Espace'),
        actions: [
          // Notifications
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: EdcTheme.danger,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          // Profil
          PopupMenuButton<String>(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: EdcTheme.primary,
              child: Text(
                'E',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            onSelected: (value) async {
              if (value == 'logout') {
                final authService = ref.read(authServiceProvider);
                await authService.logout();
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('👤 Mon profil')),
              const PopupMenuItem(value: 'settings', child: Text('⚙️ Paramètres')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'logout', child: Text('🚪 Déconnexion', style: TextStyle(color: EdcTheme.danger))),
            ],
          ),
        ],
      ),
      
      body: _pages[_selectedIndex],
      
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        animationDuration: const Duration(milliseconds: 400),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Formations'),
          NavigationDestination(icon: Icon(Icons.quiz_outlined), selectedIcon: Icon(Icons.quiz), label: 'QCMs'),
          NavigationDestination(icon: Icon(Icons.message_outlined), selectedIcon: Icon(Icons.message), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person_outlined), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// Contenu du Dashboard
class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message de bienvenue
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: EdcTheme.primaryGradient,
              borderRadius: BorderRadius.circular(EdcTheme.radius),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bonjour ! 👋', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Bienvenue dans votre espace personnel', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 10, end: 0),
          
          const SizedBox(height: 24),
          
          // Stats
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _buildStatCard(context, '5', 'Demandes', EdcTheme.primary, Icons.work_outline),
              _buildStatCard(context, '3', 'Formations', EdcTheme.success, Icons.school_outlined),
              _buildStatCard(context, '2', 'Certificats', EdcTheme.accentGold, Icons.emoji_events_outlined),
              _buildStatCard(context, '150k', 'Points', EdcTheme.purple, Icons.stars_outlined),
            ],
          ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
          
          const SizedBox(height: 24),
          
          // Actions rapides
          Text('⚡ Actions rapides', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionChip(context, '💼 Nouvelle demande', () {}),
              _buildActionChip(context, '🎓 Formations', () {}),
              _buildActionChip(context, '📝 QCMs', () {}),
              _buildActionChip(context, '💬 Messages', () {}),
              _buildActionChip(context, '⭐ Avis', () {}),
              _buildActionChip(context, '💰 Paiements', () {}),
            ],
          ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EdcTheme.bgCard,
        borderRadius: BorderRadius.circular(EdcTheme.radius),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildActionChip(BuildContext context, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(EdcTheme.radius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: EdcTheme.bgCard,
          borderRadius: BorderRadius.circular(EdcTheme.radius),
          border: Border.all(color: EdcTheme.border),
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}

// Placeholders pour les autres onglets
class _FormationsPlaceholder extends StatelessWidget {
  const _FormationsPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('🎓 Formations', style: TextStyle(color: EdcTheme.textMuted, fontSize: 18)));
  }
}

class _QcmsPlaceholder extends StatelessWidget {
  const _QcmsPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('📝 QCMs', style: TextStyle(color: EdcTheme.textMuted, fontSize: 18)));
  }
}

class _MessagesPlaceholder extends StatelessWidget {
  const _MessagesPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('💬 Messages', style: TextStyle(color: EdcTheme.textMuted, fontSize: 18)));
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('👤 Profil', style: TextStyle(color: EdcTheme.textMuted, fontSize: 18)));
  }
}