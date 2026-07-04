class Certificat {
  final int id;
  final int userId;
  final int formationId;
  final int? qcmId;
  final double score;
  final DateTime dateObtention;
  final Formation? formation;
  final DateTime createdAt;

  Certificat({
    required this.id,
    required this.userId,
    required this.formationId,
    this.qcmId,
    required this.score,
    required this.dateObtention,
    this.formation,
    required this.createdAt,
  });

  factory Certificat.fromJson(Map<String, dynamic> json) {
    return Certificat(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      formationId: json['formation_id'] ?? 0,
      qcmId: json['qcm_id'],
      score: (json['score'] ?? 0).toDouble(),
      dateObtention: json['date_obtention'] != null
          ? DateTime.parse(json['date_obtention'])
          : DateTime.now(),
      formation: json['formation'] != null
          ? Formation.fromJson(json['formation'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}