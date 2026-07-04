import 'dart:convert';

class User {
  final int id;
  final String nom;
  final String prenom;
  final String nomComplet;
  final String email;
  final String? telephone;
  final String? avatar;
  final String? emailVerifiedAt;
  final DateTime createdAt;
  final List<String> roles;
  
  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.nomComplet,
    required this.email,
    this.telephone,
    this.avatar,
    this.emailVerifiedAt,
    required this.createdAt,
    this.roles = const [],
  });
  
  // Initiales pour avatar par défaut
  String get initials {
    final first = prenom.isNotEmpty ? prenom[0].toUpperCase() : '';
    final last = nom.isNotEmpty ? nom[0].toUpperCase() : '';
    return '$first$last';
  }
  
  // Rôle principal
  String get mainRole {
    if (roles.contains('admin')) return 'Administrateur';
    if (roles.contains('enseignant')) return 'Enseignant';
    if (roles.contains('client')) return 'Client';
    return 'Utilisateur';
  }
  
  // Vérifier les rôles
  bool get isAdmin => roles.contains('admin');
  bool get isEnseignant => roles.contains('enseignant');
  bool get isClient => roles.contains('client');
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      nomComplet: json['nom_complet'] ?? '${json['prenom']} ${json['nom']}',
      email: json['email'] ?? '',
      telephone: json['telephone'],
      avatar: json['avatar'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      roles: json['roles'] != null 
          ? List<String>.from(json['roles']) 
          : [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'nom_complet': nomComplet,
      'email': email,
      'telephone': telephone,
      'avatar': avatar,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt.toIso8601String(),
      'roles': roles,
    };
  }
  
  String toJsonString() => jsonEncode(toJson());
  
  factory User.fromJsonString(String jsonString) {
    return User.fromJson(jsonDecode(jsonString));
  }
  
  // Copie avec modifications
  User copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? nomComplet,
    String? email,
    String? telephone,
    String? avatar,
    String? emailVerifiedAt,
    DateTime? createdAt,
    List<String>? roles,
  }) {
    return User(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      nomComplet: nomComplet ?? this.nomComplet,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      avatar: avatar ?? this.avatar,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      roles: roles ?? this.roles,
    );
  }
}