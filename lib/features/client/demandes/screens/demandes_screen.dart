import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

class DemandesScreen extends ConsumerStatefulWidget {
  const DemandesScreen({super.key});

  @override
  ConsumerState<DemandesScreen> createState() => _DemandesScreenState();
}

class _DemandesScreenState extends ConsumerState<DemandesScreen> {
  @override
  Widget build(BuildContext context) {
    final demandes = [
      {
        'id': 1,
        'service': 'Création de CV',
        'description': 'CV professionnel pour poste en finance',
        'statut': 'en_cours',
        'date': '15/03/2024',
        'budget': '15 000 FCFA',
      },
      {
        'id': 2,
        'service': 'Logo & Design',
        'description': 'Logo pour startup tech',
        'statut': 'en_attente',
        'date': '10/03/2024',
        'budget': '25 000 FCFA',
      },
      {
        'id': 3,
        'service': 'Formation Excel',
        'description': 'Formation avancée pour équipe de 5 personnes',
        'statut': 'termine',
        'date': '01/02/2024',
        'budget': '50 000 FCFA',
      },
      {
        'id': 4,
        'service': 'Site Web',
        'description': 'Site vitrine pour restaurant',
        'statut': 'annule',
        'date': '20/01/2024',
        'budget': '100 000 FCFA',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Demandes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewDemandeDialog(context),
        backgroundColor: EdcTheme.primary,
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle'),
      ),
      body: demandes.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: demandes.length,
              itemBuilder: (context, index) {
                final d = demandes[index];
                return _buildDemandeCard(context, d, index);
              },
            ),
    );
  }

  Widget _buildDemandeCard(BuildContext context, Map<String, String> demande, int index) {
    final statutColors = {
      'en_attente': EdcTheme.warning,
      'en_cours': EdcTheme.info,
      'termine': EdcTheme.success,
      'annule': EdcTheme.danger,
    };

    final statutIcons = {
      'en_attente': Icons.hourglass_empty,
      'en_cours': Icons.sync,
      'termine': Icons.check_circle_outline,
      'annule': Icons.cancel_outlined,
    };

    final statutLabels = {
      'en_attente': 'En attente',
      'en_cours': 'En cours',
      'termine': 'Terminée',
      'annule': 'Annulée',
    };

    final color = statutColors[demande['statut']] ?? EdcTheme.textMuted;
    final icon = statutIcons[demande['statut']] ?? Icons.help_outline;
    final label = statutLabels[demande['statut']] ?? demande['statut']!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showDemandeDetails(context, demande),
        borderRadius: BorderRadius.circular(EdcTheme.radius),
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
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          demande['service']!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '📅 ${demande['date']}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                demande['description']!,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.monetization_on_outlined, size: 16, color: EdcTheme.accentGold),
                  const SizedBox(width: 4),
                  Text(
                    demande['budget']!,
                    style: const TextStyle(
                      color: EdcTheme.accentGold,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _showDemandeDetails(context, demande),
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('Détails'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: Duration(ms: index * 100)).slideY(begin: 20, end: 0);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('📋', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 16),
          Text(
            'Aucune demande',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre première demande de service',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showNewDemandeDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Nouvelle demande'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: EdcTheme.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filtrer par statut', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(label: const Text('Toutes'), selected: true, onSelected: (_) {}),
                  FilterChip(label: const Text('En attente'), selected: false, onSelected: (_) {}),
                  FilterChip(label: const Text('En cours'), selected: false, onSelected: (_) {}),
                  FilterChip(label: const Text('Terminées'), selected: false, onSelected: (_) {}),
                  FilterChip(label: const Text('Annulées'), selected: false, onSelected: (_) {}),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Appliquer'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNewDemandeDialog(BuildContext context) {
    final serviceController = TextEditingController();
    final descriptionController = TextEditingController();
    final budgetController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: EdcTheme.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nouvelle demande', style: Theme.of(context).textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: serviceController,
                decoration: const InputDecoration(
                  labelText: 'Type de service',
                  hintText: 'Ex: Création de CV, Logo...',
                  prefixIcon: Icon(Icons.work_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Décrivez votre besoin...',
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Budget (optionnel)',
                  hintText: 'Ex: 25 000 FCFA',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Demande envoyée avec succès !'),
                        backgroundColor: EdcTheme.success,
                      ),
                    );
                  },
                  child: const Text('Envoyer la demande'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDemandeDetails(BuildContext context, Map<String, String> demande) {
    showModalBottomSheet(
      context: context,
      backgroundColor: EdcTheme.bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.8,
          minChildSize: 0.3,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: EdcTheme.textMuted,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(demande['service']!, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  _buildDetailRow('📅 Date', demande['date']!),
                  _buildDetailRow('💰 Budget', demande['budget']!),
                  _buildDetailRow('📊 Statut', demande['statut']!),
                  const SizedBox(height: 16),
                  Text('Description', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Text(demande['description']!, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 24),
                  Text('Suivi', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  _buildTimeline(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: EdcTheme.textMuted, fontSize: 13)),
          const SizedBox(width: 12),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final etapes = [
      {'titre': 'Demande créée', 'date': '10/03/2024', 'complete': true},
      {'titre': 'En cours de traitement', 'date': '12/03/2024', 'complete': true},
      {'titre': 'Service en cours', 'date': '15/03/2024', 'complete': false},
      {'titre': 'Livraison', 'date': '—', 'complete': false},
    ];

    return Column(
      children: etapes.map((etape) {
        final index = etapes.indexOf(etape);
        final isLast = index == etapes.length - 1;
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: etape['complete'] as bool ? EdcTheme.success : EdcTheme.border,
                    border: Border.all(
                      color: etape['complete'] as bool ? EdcTheme.success : EdcTheme.textMuted,
                      width: 2,
                    ),
                  ),
                  child: etape['complete'] as bool
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 30,
                    color: (etape['complete'] as bool) ? EdcTheme.success : EdcTheme.border,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    etape['titre']!,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: etape['complete'] as bool ? EdcTheme.textPrimary : EdcTheme.textMuted,
                    ),
                  ),
                  Text(
                    etape['date']!,
                    style: const TextStyle(fontSize: 11, color: EdcTheme.textMuted),
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}