class Service {
  final int id;
  final String nom;
  final String? slug;
  final String? description;
  final String? image;
  final double? prix;
  final bool actif;
  final Categorie? categorie;
  final DateTime createdAt;

  Service({
    required this.id,
    required this.nom,
    this.slug,
    this.description,
    this.image,
    this.prix,
    required this.actif,
    this.categorie,
    required this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      slug: json['slug'],
      description: json['description'],
      image: json['image'],
      prix: json['prix']?.toDouble(),
      actif: json['actif'] ?? true,
      categorie: json['categorie'] != null ? Categorie.fromJson(json['categorie']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}

class Categorie {
  final int id;
  final String nom;
  final String? description;

  Categorie({required this.id, required this.nom, this.description});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      description: json['description'],
    );
  }
}