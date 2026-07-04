class Paiement {
  final int id;
  final int userId;
  final double montant;
  final String methode;
  final String statut;
  final String? description;
  final DateTime? datePaiement;
  final Formation? formation;
  final Service? service;
  final DateTime createdAt;

  Paiement({
    required this.id,
    required this.userId,
    required this.montant,
    required this.methode,
    required this.statut,
    this.description,
    this.datePaiement,
    this.formation,
    this.service,
    required this.createdAt,
  });

  String get methodeFormatted {
    switch (methode) {
      case 'carte': return 'Carte bancaire';
      case 'virement': return 'Virement';
      case 'mobile_money': return 'Mobile Money';
      case 'especes': return 'Espèces';
      default: return methode;
    }
  }

  String get statutFormatted {
    switch (statut) {
      case 'en_attente': return 'En attente';
      case 'complete': return 'Validé';
      case 'echoue': return 'Échoué';
      case 'rembourse': return 'Remboursé';
      default: return statut;
    }
  }

  factory Paiement.fromJson(Map<String, dynamic> json) {
    return Paiement(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      montant: (json['montant'] ?? 0).toDouble(),
      methode: json['methode'] ?? '',
      statut: json['statut'] ?? 'en_attente',
      description: json['description'],
      datePaiement: json['date_paiement'] != null
          ? DateTime.parse(json['date_paiement'])
          : null,
      formation: json['formation'] != null
          ? Formation.fromJson(json['formation'])
          : null,
      service: json['service'] != null
          ? Service.fromJson(json['service'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}