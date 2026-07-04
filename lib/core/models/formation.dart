class Formation {
  final int id;
  final String titre;
  final String slug;
  final String? description;
  final String? image;
  final double? prix;
  final String? duree;
  final String? prerequis;
  final String? statut;
  final dynamic module;
  final List<dynamic> niveaux;
  final List<dynamic> enseignants;
  final int? inscriptionsCount;
  final DateTime? createdAt;

  Formation({
    required this.id,
    required this.titre,
    required this.slug,
    this.description,
    this.image,
    this.prix,
    this.duree,
    this.prerequis,
    this.statut,
    this.module,
    this.niveaux = const [],
    this.enseignants = const [],
    this.inscriptionsCount,
    this.createdAt,
  });

  factory Formation.fromJson(Map<String, dynamic> json) {
    return Formation(
      id: json['id'] ?? 0,
      titre: json['titre'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      image: json['image'],
      prix: (json['prix'] as num?)?.toDouble(),
      duree: json['duree'],
      prerequis: json['prerequis'],
      statut: json['statut'],
      module: json['module'],
      niveaux: json['niveaux'] ?? [],
      enseignants: json['enseignants'] ?? [],
      inscriptionsCount: json['inscriptions_count'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}

class Module {
  final int id;
  final String nom;
  final String? slug;

  Module({required this.id, required this.nom, this.slug});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      slug: json['slug'],
    );
  }
}

class Niveau {
  final int id;
  final String nom;
  final String? description;
  final int ordre;

  Niveau({
    required this.id,
    required this.nom,
    this.description,
    required this.ordre,
  });

  factory Niveau.fromJson(Map<String, dynamic> json) {
    return Niveau(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      description: json['description'],
      ordre: json['ordre'] ?? 0,
    );
  }
}

class Enseignant {
  final int id;
  final String nom;
  final String prenom;
  final String? avatar;
  final String? email;

  Enseignant({
    required this.id,
    required this.nom,
    required this.prenom,
    this.avatar,
    this.email,
  });

  String get nomComplet => '$prenom $nom';

  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      avatar: json['avatar'],
      email: json['email'],
    );
  }
}
