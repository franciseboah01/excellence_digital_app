class Message {
  final int id;
  final int expediteurId;
  final int destinataireId;
  final String contenu;
  final bool lu;
  final DateTime createdAt;
  final User? expediteur;

  Message({
    required this.id,
    required this.expediteurId,
    required this.destinataireId,
    required this.contenu,
    required this.lu,
    required this.createdAt,
    this.expediteur,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      expediteurId: json['expediteur_id'] ?? 0,
      destinataireId: json['destinataire_id'] ?? 0,
      contenu: json['contenu'] ?? '',
      lu: json['lu'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      expediteur: json['expediteur'] != null
          ? User.fromJson(json['expediteur'])
          : null,
    );
  }
}

class Conversation {
  final User user;
  final Message? lastMessage;
  final int unreadCount;

  Conversation({
    required this.user,
    this.lastMessage,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      user: User.fromJson(json['user']),
      lastMessage: json['last_message'] != null
          ? Message.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}