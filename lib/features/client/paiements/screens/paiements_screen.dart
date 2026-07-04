import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

class PaiementsScreen extends ConsumerStatefulWidget {
  const PaiementsScreen({super.key});

  @override
  ConsumerState<PaiementsScreen> createState() => _PaiementsScreenState();
}

class _PaiementsScreenState extends ConsumerState<PaiementsScreen> {
  @override
  Widget build(BuildContext context) {
    final paiements = [
      {
        'id': 'INV-2024-001',
        'description': 'Formation Excel Avancé',
        'montant': '50 000 FCFA',
        'methode': 'mobile_money',
        'statut': 'complete',
        'date': '15/03/2024',
      },
      {
        'id': 'INV-2024-002',
        'description': 'Création de Logo',
        'montant': '25 000 FCFA',
        'methode': 'virement',
        'statut': 'complete',
        'date': '10/03/2024',
      },
      {
        'id': 'INV-2024-003',
        'description': 'Développement Web - Module 1',
        'montant': '75 000 FCFA',
        'methode': 'carte',
        'statut': 'en_attente',
        'date': '05/03/2024',
      },
      {
        'id': 'INV-2024-004',
        'description': 'Formation Photoshop',
        'montant': '35 000 FCFA',
        'methode': 'mobile_money',
        'statut': 'echoue',
        'date': '01/03/2024',
      },
    ];

    final totalPaye = paiements
        .where((p) => p['statut'] == 'complete')
        .fold<int>(0, (sum, p) => sum + int.parse(p['montant']!.replaceAll(RegExp(r'[^0-9]'), '')));

    return Scaffold(
      appBar: AppBar(title: const Text('Mes Paiements')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: EdcTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(EdcTheme.radius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
                        const SizedBox(height: 12),
                        Text(
                          '$totalPaye FCFA',
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                        const Text('Total payé', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).scale(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: EdcTheme.bgCard,
                      borderRadius: BorderRadius.circular(EdcTheme.radius),
                      border: Border.all(color: EdcTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.receipt_long, color: EdcTheme.primaryLight, size: 28),
                        const SizedBox(height: 12),
                        Text(
                          '${paiements.length}',
                          style: const TextStyle(color: EdcTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                        const Text('Transactions', style: TextStyle(color: EdcTheme.textMuted, fontSize: 12)),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms).scale(),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            Text('Historique', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            
            ...paiements.asMap().entries.map((entry) {
              final index = entry.key;
              final p = entry.value;
              return _buildPaiementCard(context, p, index);
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewPaiementDialog(context),
        backgroundColor: EdcTheme.primary,
        icon: const Icon(Icons.add),
        label: const Text('Nouveau'),
      ),
    );
  }

  Widget _buildPaiementCard(BuildContext context, Map<String, String> paiement, int index) {
    final statutColors = {
      'complete': EdcTheme.success,
      'en_attente': EdcTheme.warning,
      'echoue': EdcTheme.danger,
    };

    final methodIcons = {
      'mobile_money': Icons.phone_android,
      'virement': Icons.account_balance,
      'carte': Icons.credit_card,
      'especes': Icons.money,
    };

    final methodLabels = {
      'mobile_money': 'Mobile Money',
      'virement': 'Virement',
      'carte': 'Carte bancaire',
      'especes': 'Espèces',
    };

    final color = statutColors[paiement['statut']] ?? EdcTheme.textMuted;
    final icon = methodIcons[paiement['methode']] ?? Icons.payment;
    final methodLabel = methodLabels[paiement['methode']] ?? paiement['methode']!;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => _showPaiementDetails(context, paiement),
        borderRadius: BorderRadius.circular(EdcTheme.radius),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(paiement['description']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text('📅 ${paiement['date']}', style: const TextStyle(fontSize: 11, color: EdcTheme.textMuted)),
                        const SizedBox(width: 8),
                        Text('•', style: TextStyle(color: EdcTheme.textMuted)),
                        const SizedBox(width: 8),
                        Text(methodLabel, style: const TextStyle(fontSize: 11, color: EdcTheme.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    paiement['montant']!,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: EdcTheme.accentGold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      paiement['statut'] == 'complete' ? 'Validé' : paiement['statut'] == 'en_attente' ? 'En attente' : 'Échoué',
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: Duration(ms: index * 80)).slideX(begin: -10, end: 0);
  }

  void _showPaiementDetails(BuildContext context, Map<String, String> paiement) {
    showModalBottomSheet(
      context: context,
      backgroundColor: EdcTheme.bgCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: EdcTheme.textMuted, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),
              Text('Détails du paiement', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              _buildDetailRow('📋 Référence', paiement['id']!),
              _buildDetailRow('📝 Description', paiement['description']!),
              _buildDetailRow('💰 Montant', paiement['montant']!),
              _buildDetailRow('💳 Méthode', paiement['methode']!),
              _buildDetailRow('📅 Date', paiement['date']!),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.receipt_outlined, size: 18),
                      label: const Text('Reçu'),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Facture PDF'),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: EdcTheme.textMuted, fontSize: 13)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  void _showNewPaiementDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: EdcTheme.bgCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
              Text('Effectuer un paiement', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Montant',
                  hintText: 'Ex: 25 000',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Motif du paiement',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Méthode de paiement',
                  prefixIcon: Icon(Icons.payment),
                ),
                items: const [
                  DropdownMenuItem(value: 'mobile_money', child: Text('📱 Mobile Money')),
                  DropdownMenuItem(value: 'carte', child: Text('💳 Carte bancaire')),
                  DropdownMenuItem(value: 'virement', child: Text('🏦 Virement')),
                ],
                onChanged: (_) {},
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Paiement initié !'), backgroundColor: EdcTheme.success),
                    );
                  },
                  child: const Text('Payer maintenant'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}