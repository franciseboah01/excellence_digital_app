class DemandeService {
  final int id;
  final int? serviceId;
  final String description;
  final String statut;
  final String? commentaireAdmin;
  final DateTime? dateSouhaitee;
  final double? budget;
  final Service? service;
  final DateTime createdAt;

  DemandeService({
    required this.id,
    this.serviceId,
    required this.description,
    required this.statut,
    this.commentaireAdmin,
    this.dateSouhaitee,
    this.budget,
    this.service,
    required this.createdAt,
  });

  String get statutFormatted {
    switch (statut) {
      case 'en_attente': return 'En attente';
      case 'en_cours': return 'En cours';
      case 'termine': return 'Terminée';
      case 'annule': return 'Annulée';
      default: return statut;
    }
  }

  factory DemandeService.fromJson(Map<String, dynamic> json) {
    return DemandeService(
      id: json['id'] ?? 0,
      serviceId: json['service_id'],
      description: json['description'] ?? '',
      statut: json['statut'] ?? 'en_attente',
      commentaireAdmin: json['commentaire_admin'],
      dateSouhaitee: json['date_souhaitee'] != null
          ? DateTime.parse(json['date_souhaitee'])
          : null,
      budget: json['budget']?.toDouble(),
      service: json['service'] != null
          ? Service.fromJson(json['service'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}