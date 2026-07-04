import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  final _messageController = TextEditingController();
  
  final _conversations = [
    {'nom': 'Admin EDC', 'dernierMessage': 'Votre demande a été validée', 'heure': '10:30', 'nonLus': 2, 'online': true},
    {'nom': 'Prof. Koné', 'dernierMessage': 'Envoyez votre exercice avant vendredi', 'heure': 'Hier', 'nonLus': 0, 'online': false},
    {'nom': 'Support Technique', 'dernierMessage': 'Nous avons résolu le problème', 'heure': 'Lun', 'nonLus': 0, 'online': true},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final conv = _conversations[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: EdcTheme.primary,
                  child: Text(
                    conv['nom']![0],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                if (conv['online'] as bool)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: EdcTheme.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: EdcTheme.bgDeep, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Row(
              children: [
                Expanded(child: Text(conv['nom']!, style: const TextStyle(fontWeight: FontWeight.w600))),
                Text(conv['heure']!, style: const TextStyle(fontSize: 11, color: EdcTheme.textMuted)),
              ],
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                    conv['dernierMessage']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: (conv['nonLus'] as int) > 0 ? EdcTheme.textPrimary : EdcTheme.textMuted,
                      fontWeight: (conv['nonLus'] as int) > 0 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (conv['nonLus'] as int > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: EdcTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${conv['nonLus']}',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            onTap: () => _openConversation(context, conv['nom']!),
          ).animate().fadeIn(duration: 400.ms, delay: Duration(ms: index * 100)).slideX(begin: -20, end: 0);
        },
      ),
    );
  }

  void _openConversation(BuildContext context, String nom) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(radius: 16, backgroundColor: EdcTheme.primary, child: Text(nom[0], style: const TextStyle(color: Colors.white, fontSize: 12))),
                const SizedBox(width: 8),
                Text(nom, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildMessageBubble('Bonjour, comment puis-je vous aider ?', false, '10:00'),
                    _buildMessageBubble('J\'ai une question sur ma formation', true, '10:05'),
                    _buildMessageBubble('Bien sûr, quelle est votre question ?', false, '10:07'),
                    _buildMessageBubble('Quand commence le prochain module ?', true, '10:10'),
                    _buildMessageBubble('Le prochain module commence lundi prochain. Vous recevrez un email de confirmation.', false, '10:12'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: EdcTheme.bgCard,
                  border: Border(top: BorderSide(color: EdcTheme.border)),
                ),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.attach_file, color: EdcTheme.textMuted), onPressed: () {}),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Écrivez votre message...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: EdcTheme.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white, size: 20),
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            _messageController.clear();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isSent, String time) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSent ? EdcTheme.primaryGradient : null,
          color: isSent ? null : EdcTheme.bgElevated,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isSent ? const Radius.circular(16) : Radius.zero,
            bottomRight: isSent ? Radius.zero : const Radius.circular(16),
          ),
          border: isSent ? null : Border.all(color: EdcTheme.border),
        ),
        child: Column(
          crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message, style: TextStyle(color: isSent ? Colors.white : EdcTheme.textPrimary, fontSize: 14)),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(color: isSent ? Colors.white60 : EdcTheme.textMuted, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}