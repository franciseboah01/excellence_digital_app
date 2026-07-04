import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

class QcmsScreen extends ConsumerWidget {
  const QcmsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qcms = [
      {'titre': 'Excel - Niveau 1', 'formation': 'Excel Avancé', 'questions': 20, 'duree': 30, 'meilleurScore': 85},
      {'titre': 'HTML/CSS - Base', 'formation': 'Développement Web', 'questions': 25, 'duree': 45, 'meilleurScore': null},
      {'titre': 'Couleurs et Typo', 'formation': 'Design Graphique', 'questions': 15, 'duree': 20, 'meilleurScore': 70},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('QCMs Disponibles')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: qcms.length,
        itemBuilder: (context, index) {
          final q = qcms[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: EdcTheme.purple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.quiz_outlined, color: EdcTheme.purple),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(q['titre']!, style: Theme.of(context).textTheme.titleMedium),
                            Text('🎓 ${q['formation']}', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      if (q['meilleurScore'] != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: EdcTheme.success.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${q['meilleurScore']}%',
                            style: const TextStyle(color: EdcTheme.success, fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(Icons.help_outline, '${q['questions']} questions'),
                      const SizedBox(width: 12),
                      _buildInfoChip(Icons.timer_outlined, '${q['duree']} min'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _startQcm(context, q['titre']!),
                      icon: const Icon(Icons.play_arrow, size: 20),
                      label: const Text('Démarrer le QCM'),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: Duration(ms: index * 100)).slideY(begin: 20, end: 0);
        },
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: EdcTheme.bgElevated,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: EdcTheme.textMuted),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: EdcTheme.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }

  void _startQcm(BuildContext context, String titre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Démarrer le QCM ?'),
        content: Text('Vous allez commencer : $titre\n\nAssurez-vous d\'avoir du temps devant vous.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ QCM démarré !'), backgroundColor: EdcTheme.success),
              );
            },
            child: const Text('Commencer'),
          ),
        ],
      ),
    );
  }
}