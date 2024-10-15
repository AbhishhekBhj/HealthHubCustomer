import 'dart:developer';
import '../Controller/providers/chat_provider.dart';

class Conversation {
  int? id;
  List<String>? userIds;
  DateTime? createdAt;
  DateTime? lastUpdated;
  List<Message>? messages;

  Conversation({
    this.id,
    this.userIds,
    this.createdAt,
    this.lastUpdated,
    this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    try {
      return Conversation(
        id: json['id'],
        userIds: List<String>.from(json['userIds']['\$values'] ?? []), // Parse userIds
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        lastUpdated: json['lastUpdated'] != null
            ? DateTime.parse(json['lastUpdated'])
            : null,
        messages: json['messages'] != null
            ? (json['messages']['\$values'] as List)
                .map((item) => Message.fromJson(item))
                .toList()
            : [], // Parse messages list
      );
    } catch (e) {
      log("Error in conversation parsing: $e");
      return Conversation(); // Return an empty conversation on error
    }
  }
}
