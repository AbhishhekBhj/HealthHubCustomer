import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthhubcustomer/Controller/repositories/message_repo.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class ChatProvider extends ChangeNotifier {
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  late WebSocketChannel channel;
  final MessageRepo _messageRepo = MessageRepo();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ChatProvider() {
    connectToSocket();
    fetchLast10Messages();
  }

  Future<void> deleteMessage(int messageId) async {
    try {
      var success = await _messageRepo.deleteMessage(messageId: messageId);

      if (success) {
        fetchLast10Messages();
        notifyListeners();
      }
    } catch (e) {
      log("Error deleting message: $e");
    }
  }

  /// Fetches the last 10 messages from the repository
  Future<void> fetchLast10Messages() async {
    _setLoading(true);
    try {
      var conversation = await _messageRepo.getLast10Messages(senderId: 6, receiverId: 7);


      if (conversation != null && conversation.messages != null) {
        log("Messages fetched: ${conversation.messages}");
        _messages = conversation.messages!;
        log("Messages fetcheds: $_messages");

        notifyListeners();
      } else {
        log("No messages found");
      }
    } catch (e) {
      log("Error fetching messages: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Sends a message through the API and WebSocket
  Future<bool> sendMessage(String message,) async {
    try {
      Message newMessage = Message(
        conversationId: 1,
        senderId: "6",
        receiverId: "7",
        content: message,
        sentAt: DateTime.now(),
        isRead: false,
        messageType: 0,
      );

      // Add the message optimistically to the list
      _messages.add(newMessage);
      notifyListeners();

      var success = await _messageRepo.sendMessage(
        conversationId: newMessage.conversationId!,
        senderId: 6,
        receiverId: 7,
        message: message,
      );

      if (!success) {
        // Handle message send failure (e.g., remove optimistic message)
        
        _messages.remove(newMessage);
        notifyListeners();
        return false;
      }
      else{
        try{
          log("Adding sink");
          channel.sink.add(jsonEncode(newMessage.toJson()));
        }
        catch(e){
          log("Error adding sink : $e");
          return false;
        }
        
        notifyListeners();
        return true;
      }
    } catch (e) {
      log("Error sending message: $e");
      return false;
    }
  }

  /// Connect to the WebSocket server for real-time communication
  void connectToSocket() {
    try {
      channel = IOWebSocketChannel.connect(Uri.parse("ws://10.0.2.2:8181"));
      log("WebSocket connected");

      channel.stream.listen((message) {
        log("Message received: $message");
        final decodedMessage = Message(
          content: jsonDecode(message)['Content'],
          sentAt: DateTime.parse(jsonDecode(message)['SentAt']),
          senderId: jsonDecode(message)['SenderId'],
          receiverId: jsonDecode(message)['ReceiverId'],
          conversationId: jsonDecode(message)['ConversationId'],

        );
        _messages.add(decodedMessage);
        notifyListeners(); // Update the UI when new message arrives
      });
    } catch (e) {
      log("Error connecting to WebSocket: $e");
    }
  }

  /// Add or remove reaction to a message
  void addReaction(String reactionType, int index) {
    if (_messages[index].reaction == mapReaction(reactionType)) {
      _messages[index].reaction = null;  // Toggle reaction off
    } else {
      _messages[index].reaction = mapReaction(reactionType);  // Add reaction
    }
    notifyListeners();
  }

  /// Map a string reaction to the MessageReaction enum
  MessageReaction mapReaction(String reactionType) {
    switch (reactionType) {
      case "like":
        return MessageReaction.like;
      case "love":
        return MessageReaction.love;
      case "haha":
        return MessageReaction.haha;
      case "wow":
        return MessageReaction.wow;
      case "sad":
        return MessageReaction.sad;
      case "angry":
        return MessageReaction.angry;
      default:
        return MessageReaction.like;
    }
  }

  /// Set loading state and notify listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Dispose WebSocket connection properly
  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

// Enums for message reactions
enum MessageReaction { like, love, haha, wow, sad, angry }

// Message Model
class Message {
  int? id;
  int? conversationId;
  String? senderId;
  String? receiverId;
  String? content;
  DateTime? sentAt;
  bool? isRead;
  int? isDeleted;
  int? isUpdated;
  int? messageType;
  dynamic reaction;

  Message({
    this.id,
    this.conversationId,
    this.senderId,
    this.receiverId,
    this.content,
    this.sentAt,
    this.isRead,
    this.messageType,
    this.reaction,

    this.isDeleted,
    this.isUpdated,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    try{
      return Message(
      id: json['id'],
      conversationId: json['conversationId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
      isRead: json['isRead'],
      messageType: json['messageType'],
      reaction: json['reaction'],
      isDeleted: json['isDeleted'],
      isUpdated: json['isUpdated'],
    );
    } catch (e) {
      log("Error in message parsing: $e");
      return Message(); // Return an empty message on error
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'sentAt': sentAt?.toIso8601String(),
      'isRead': isRead,
      'messageType': messageType,
      'reaction': reaction,
    };
  }
}
