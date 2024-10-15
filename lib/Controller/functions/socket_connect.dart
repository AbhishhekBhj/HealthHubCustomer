import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthhubcustomer/colors/colors.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel channel;
  final List<Message> messages = []; // List to store received messages

  @override
  void initState() {
    super.initState();
    connectToSocket();
  }

  void connectToSocket() {
    try {
      channel = IOWebSocketChannel.connect(Uri.parse("ws://10.0.2.2:8181"));
      log(channel.toString());

      // Listen for incoming messages
      channel.stream.listen((message) {
        log("Message received: $message");
        setState(() {
          messages.add(Message(message: message, isUserMessage: false));
        });
      });
    } catch (e) {
      log("Error connecting to socket: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebSocket Chat"),
        backgroundColor: appMainColor, // Set AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(messages[index], index);
                },
              ),
            ),
            _buildMessageInputField(), // Build the input field for sending messages
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message, int index) {
    bool isUserMessage = message.isUserMessage;
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isUserMessage ? Colors.teal.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Text(
              message.message,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          if (message.reaction != null) // Show reaction if any
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                _getReactionText(message.reaction!),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          _buildReactionBar(index), // Reaction bar below message
        ],
      ),
    );
  }

  Widget _buildReactionBar(int messageIndex) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildReactionIcon(Icons.thumb_up, "like", messageIndex),
        _buildReactionIcon(Icons.favorite, "love", messageIndex),
        _buildReactionIcon(Icons.emoji_emotions, "haha", messageIndex),
        _buildReactionIcon(Icons.sentiment_very_satisfied, "wow", messageIndex),
        _buildReactionIcon(Icons.sentiment_very_dissatisfied, "sad", messageIndex),
        _buildReactionIcon(Icons.emoji_flags, "angry", messageIndex),
      ],
    );
  }

  Widget _buildReactionIcon(IconData icon, String reactionType, int messageIndex) {
    return IconButton(
      icon: Icon(icon, size:
      messages[messageIndex].reaction == _mapReaction(reactionType) ? 24.0 :
      
       20.0, color:
          messages[messageIndex].reaction == _mapReaction(reactionType)
              ? Colors.red
              :
      
       Colors.grey.shade600),
      onPressed: () => _addReaction(reactionType, messageIndex),
    );
  }

  void _addReaction(String reactionType, int index) {
    setState(() {
      // If the current reaction matches, remove it (set to null), otherwise, add the reaction
      if (messages[index].reaction == _mapReaction(reactionType)) {
        messages[index].reaction = null;
      } else {
        messages[index].reaction = _mapReaction(reactionType);
      }
    });
  }

  MessageReaction _mapReaction(String reactionType) {
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

  String _getReactionText(MessageReaction reaction) {
    switch (reaction) {
      case MessageReaction.like:
        return "👍 Liked";
      case MessageReaction.love:
        return "❤️ Loved";
      case MessageReaction.haha:
        return "😂 Haha";
      case MessageReaction.wow:
        return "😮 Wow";
      case MessageReaction.sad:
        return "😢 Sad";
      case MessageReaction.angry:
        return "😡 Angry";
      default:
        return "";
    }
  }

  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: sendData,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.teal,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendData() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);

      setState(() {
        messages.add(Message(message: _controller.text, isUserMessage: true));
      });

      _controller.clear();
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}

class Message {
  final String message;
  final bool isUserMessage;
  MessageReaction? reaction;

  Message({required this.message, required this.isUserMessage, this.reaction});
}

enum MessageReaction { like, love, haha, wow, sad, angry }
