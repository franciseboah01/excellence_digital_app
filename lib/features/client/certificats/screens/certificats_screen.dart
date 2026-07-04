import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

class CertificatsScreen extends ConsumerWidget {
  const CertificatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certificats = [
      {
        'titre': 'Excel Avancé',
        'formation': 'Bureautique',
        'date': '15/02/2024',
        'score': 92,
        'mention': 'Excellent',
      },
      {
        'titre': 'Développement Web',
        'formation': 'Programmation',
        'date': '01/12/2023',
        'score': 85,
        'mention': 'Très Bien',
      },
      {
        'titre': 'Design Graphique',
        'formation': 'Création',
        'date': '10/10/2023',
        'score': 78,
        'mention': 'Bien',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Mes Certificats')),
      body: certificats.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: certificats.length,
              itemBuilder: (context, index) {
                final c = certificats[index];
                return _buildCertificatCard(context, c, index);
              },
            ),
    );
  }

  Widget _buildCertificatCard(BuildContext context, Map<String, String> cert, int index) {
    final score = int.parse(cert['score']!);
    final mentionColor = score >= 90
        ? EdcTheme.accentGold
        : score >= 80
            ? EdcTheme.success
            : EdcTheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(EdcTheme.radius),
          border: Border.all(color: EdcTheme.border),
        ),
        child: Column(
          children: [
            // En-tête avec ruban
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: EdcTheme.primaryGradient,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(EdcTheme.radius)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.emoji_events, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cert['titre']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '🎓 ${cert['formation']}',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Détails
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildStatBox(context, 'Score', '${cert['score']}%', EdcTheme.primaryLight),
                      const SizedBox(width: 12),
                      _buildStatBox(context, 'Mention', cert['mention']!, mentionColor),
                      const SizedBox(width: 12),
                      _buildStatBox(context, 'Obtenu le', cert['date']!, EdcTheme.textSecondary),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Barre de progression
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: score / 100,
                      backgroundColor: EdcTheme.border,
                      color: mentionColor,
                      minHeight: 10,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _viewCertificat(context, cert),
                          icon: const Icon(Icons.visibility_outlined, size: 18),
                          label: const Text('Voir'),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _downloadCertificat(context, cert),
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('Télécharger'),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: Duration(ms: index * 150)).slideY(begin: 30, end: 0);
  }

  Widget _buildStatBox(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: EdcTheme.bgElevated,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: EdcTheme.textMuted, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🏆', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 16),
          Text('Aucun certificat', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Réussissez des QCMs pour obtenir vos certificats',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _viewCertificat(BuildContext context, Map<String, String> cert) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(EdcTheme.radiusLg),
            border: Border.all(color: EdcTheme.accentGold, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, color: EdcTheme.accentGold, size: 48),
              const SizedBox(height: 16),
              Text('CERTIFICAT', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: EdcTheme.accentGold)),
              const SizedBox(height: 8),
              Text(cert['titre']!, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text('Score: ${cert['score']}% - ${cert['mention']}', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              Text('Délivré le ${cert['date']}', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _downloadCertificat(BuildContext context, Map<String, String> cert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📥 Téléchargement de "${cert['titre']}" en cours...'),
        backgroundColor: EdcTheme.success,
      ),
    );
  }
}