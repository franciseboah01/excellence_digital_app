class Notification {
  final int id;
  final String titre;
  final String message;
  final String type; // info, success, warning, error
  final bool lu;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.titre,
    required this.message,
    required this.type,
    required this.lu,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? 0,
      titre: json['titre'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'info',
      lu: json['lu'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}