import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/auth_service.dart';
import '../../../auth/screens/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: EdcTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text('FE', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: EdcTheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).scale(),
            
            const SizedBox(height: 16),
            
            Text('Francis Eboah', style: Theme.of(context).textTheme.headlineSmall).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            Text('francis@email.com', style: Theme.of(context).textTheme.bodyMedium).animate().fadeIn(duration: 400.ms, delay: 300.ms),
            
            const SizedBox(height: 32),
            
            // Menu
            _buildMenuItem(context, Icons.person_outline, 'Informations personnelles', () {}),
            _buildMenuItem(context, Icons.lock_outline, 'Changer le mot de passe', () {}),
            _buildMenuItem(context, Icons.notifications_outlined, 'Notifications', () {}),
            _buildMenuItem(context, Icons.payment_outlined, 'Moyens de paiement', () {}),
            _buildMenuItem(context, Icons.help_outline, 'Aide & Support', () {}),
            _buildMenuItem(context, Icons.info_outline, 'À propos', () {}),
            
            const SizedBox(height: 32),
            
            // Déconnexion
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Déconnexion'),
                      content: const Text('Voulez-vous vraiment vous déconnecter ?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(backgroundColor: EdcTheme.danger),
                          child: const Text('Déconnecter'),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirm == true) {
                    final authService = ref.read(authServiceProvider);
                    await authService.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
                icon: const Icon(Icons.logout, color: EdcTheme.danger),
                label: const Text('Déconnexion', style: TextStyle(color: EdcTheme.danger)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: EdcTheme.danger),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: EdcTheme.primaryLight),
        title: Text(title, style: const TextStyle(fontSize: 15)),
        trailing: const Icon(Icons.chevron_right, color: EdcTheme.textMuted),
        onTap: onTap,
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -10, end: 0);
  }
}