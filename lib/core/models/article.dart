class Article {
  final int id;
  final String titre;
  final String slug;
  final String? extrait;
  final String? contenu;
  final String? image;
  final String? statut;
  final ArticleCategorie? categorie;
  final DateTime createdAt;

  Article({
    required this.id,
    required this.titre,
    required this.slug,
    this.extrait,
    this.contenu,
    this.image,
    this.statut,
    this.categorie,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? 0,
      titre: json['titre'] ?? '',
      slug: json['slug'] ?? '',
      extrait: json['extrait'],
      contenu: json['contenu'],
      image: json['image'],
      statut: json['statut'],
      categorie: json['categorie'] != null
          ? ArticleCategorie.fromJson(json['categorie'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}

class ArticleCategorie {
  final int id;
  final String nom;
  final String? slug;

  ArticleCategorie({required this.id, required this.nom, this.slug});

  factory ArticleCategorie.fromJson(Map<String, dynamic> json) {
    return ArticleCategorie(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      slug: json['slug'],
    );
  }
}