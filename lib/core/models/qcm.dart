class Qcm {
  final int id;
  final String titre;
  final String? description;
  final int formationId;
  final int? niveauId;
  final int duree; // en minutes
  final int seuilReussite;
  final bool actif;
  final int questionsCount;
  final Formation? formation;
  final List<Question>? questions;

  Qcm({
    required this.id,
    required this.titre,
    this.description,
    required this.formationId,
    this.niveauId,
    required this.duree,
    required this.seuilReussite,
    required this.actif,
    required this.questionsCount,
    this.formation,
    this.questions,
  });

  factory Qcm.fromJson(Map<String, dynamic> json) {
    return Qcm(
      id: json['id'] ?? 0,
      titre: json['titre'] ?? '',
      description: json['description'],
      formationId: json['formation_id'] ?? 0,
      niveauId: json['niveau_id'],
      duree: json['duree'] ?? 30,
      seuilReussite: json['seuil_reussite'] ?? 50,
      actif: json['actif'] ?? false,
      questionsCount: json['questions_count'] ?? 0,
      formation: json['formation'] != null
          ? Formation.fromJson(json['formation'])
          : null,
      questions: json['questions'] != null
          ? List<Question>.from(json['questions'].map((x) => Question.fromJson(x)))
          : null,
    );
  }
}

class Question {
  final int id;
  final String enonce;
  final String type; // qcm_unique, qcm_multiple, vrai_faux, texte
  final List<String>? options;
  final int points;
  final int ordre;
  final String? explication;

  Question({
    required this.id,
    required this.enonce,
    required this.type,
    this.options,
    required this.points,
    required this.ordre,
    this.explication,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      enonce: json['enonce'] ?? '',
      type: json['type'] ?? 'qcm_unique',
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      points: json['points'] ?? 1,
      ordre: json['ordre'] ?? 0,
      explication: json['explication'],
    );
  }
}

class SessionQcm {
  final int id;
  final int userId;
  final int qcmId;
  final double score;
  final bool reussite;
  final DateTime? debut;
  final DateTime? fin;
  final DateTime createdAt;

  SessionQcm({
    required this.id,
    required this.userId,
    required this.qcmId,
    required this.score,
    required this.reussite,
    this.debut,
    this.fin,
    required this.createdAt,
  });

  factory SessionQcm.fromJson(Map<String, dynamic> json) {
    return SessionQcm(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      qcmId: json['qcm_id'] ?? 0,
      score: (json['score'] ?? 0).toDouble(),
      reussite: json['reussite'] ?? false,
      debut: json['debut'] != null ? DateTime.parse(json['debut']) : null,
      fin: json['fin'] != null ? DateTime.parse(json['fin']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}