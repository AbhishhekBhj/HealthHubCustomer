import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthhubcustomer/View/widgets/alerts/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/animation.dart';
import '../../Controller/providers/chat_provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _reactionController;
  late ChatProvider chatProvider;
  bool _isApiCalled = false; // To prevent continuous API calls
  int offset = 10;
  int limit = 10;
  bool scrollisAtTop = false;


  @override
  void initState() {
    super.initState();
    _reactionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Call the API once during the initial build
    Future.microtask(() {
      Provider.of<ChatProvider>(context, listen: false).fetchLast10Messages();
    });
  }

  @override
  void dispose() {
    _reactionController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context);

    ScrollController _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
            log("At the top of the list");
        if (!scrollisAtTop) {
          
          scrollisAtTop = true;
        }
      } else {
        log("Not at the top of the list");
        scrollisAtTop = false;
      }
    });




    // Method to scroll to the bottom of the list
    void _scrollToBottom() {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }

    // Scroll to the bottom when a new message is Fm
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatProvider.messages.isNotEmpty) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with Trainer"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
              
            Visibility(
              visible: scrollisAtTop,
              child: ElevatedButton(
                onPressed: () {
                  // Add your logic here to load older messages
                  // e.g., call the API to fetch older messages
                  // chatProvider.loadOlderMessages(); // You can implement this in your ChatProvider
                },
                child: const Text("Load Older Messages"),
              ),
            ),
            chatProvider.messages.isEmpty
                ? Expanded(
                    child: NoDataPage(
                      onRefresh: () {
                        // Add your refresh logic here
                        chatProvider.fetchLast10Messages(); // Example callback
                      },
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: chatProvider.messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(chatProvider, index);
                      },
                    ),
                  ),
            _buildMessageInputField(chatProvider, _scrollToBottom),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatProvider chatProvider, int index) {
    Message message = chatProvider.messages[index];
    bool isUserMessage = message.senderId == '6';

    // Fade animation for incoming messages
    AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    Animation<double> _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();

    return FadeTransition(
      opacity: _animation,
      child: Align(
        alignment: isUserMessage
            ? Alignment.centerRight
            : Alignment.centerLeft, // Align based on sender or receiver
        child: InkWell(
          onLongPress: () {
            if (message.isDeleted != 1 && message.senderId == '6') {
              _showMessageOptions(context, message);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color:
                  isUserMessage ? Colors.teal.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: message.isDeleted == 1
                ? Align(
                    alignment: isUserMessage
                        ? Alignment
                            .centerRight // Deleted by sender, show on right
                        : Alignment
                            .centerLeft, // Deleted by receiver, show on left
                    child: Text(
                      "Message Deleted",
                      style: TextStyle(
                        color: Colors.red.shade700, // Red to indicate deletion
                        fontStyle:
                            FontStyle.italic, // Italic style for distinction
                        fontSize: 16.0,
                      ),
                    ),
                  )
                : Text(
                    message.content!,
                    style: const TextStyle(fontSize: 16.0),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildReactionBar(ChatProvider chatProvider, int messageIndex) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildReactionIcon(chatProvider, Icons.thumb_up, "like", messageIndex),
        _buildReactionIcon(chatProvider, Icons.favorite, "love", messageIndex),
        _buildReactionIcon(
            chatProvider, Icons.emoji_emotions, "haha", messageIndex),
        _buildReactionIcon(
            chatProvider, Icons.sentiment_very_satisfied, "wow", messageIndex),
        _buildReactionIcon(chatProvider, Icons.sentiment_very_dissatisfied,
            "sad", messageIndex),
        _buildReactionIcon(
            chatProvider, Icons.emoji_flags, "angry", messageIndex),
      ],
    );
  }

  Widget _buildReactionIcon(ChatProvider chatProvider, IconData icon,
      String reactionType, int messageIndex) {
    return ScaleTransition(
      scale: _reactionController,
      child: IconButton(
        icon: Icon(
          icon,
          size: chatProvider.messages[messageIndex].reaction ==
                  chatProvider.mapReaction(reactionType)
              ? 24.0
              : 20.0,
        ),
        onPressed: () {
          chatProvider.addReaction(reactionType, messageIndex);
          _reactionController.forward(from: 0.0); // Play reaction animation
        },
      ),
    );
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

  Widget _buildMessageInputField(
      ChatProvider chatProvider, VoidCallback scrollToBottom) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30.0),
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
            onTap: () {
              chatProvider.sendMessage(_controller.text);
              _controller.clear();
              scrollToBottom();
            },
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
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

  void _showMessageOptions(BuildContext context, Message message) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.teal),
                title: const Text('Copy'),
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: message.content??""));
                  customSnackBar(
                      context: context,
                      message: "Message copied to clipboard",
                      snackBarColor: Colors.teal,
                      textColor: Colors.white);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete'),
                onTap: () {
                  if (message.id != null) {
                    chatProvider.deleteMessage(message.id!);
                    Navigator.pop(context);
                  } else {
                    customSnackBar(
                        context: context,
                        message:
                            "Unexpected error while Trying to delete Message",
                        snackBarColor: Colors.red,
                        textColor: Colors.white);
                  }
                  // Handle delete action
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);

                  showEditDialog(context, message);

                  // Handle reply action
                },
              ),
              ListTile(
                leading: const Icon(Icons.forward, color: Colors.blueGrey),
                title: const Text('Forward'),
                onTap: () {
                  // Handle forward action
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showEditDialog(BuildContext context, Message message) {
  // Create a controller for the TextField
  final TextEditingController _controller = TextEditingController(text: message.content);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        title: const Text(
          "Edit Message",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite, // Makes the dialog content full width
          child: TextField(
            controller: _controller,
            maxLines: 5, // Allow multiple lines
            decoration: InputDecoration(
              hintText: "Type your message here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners for TextField
                borderSide: BorderSide(
                  color: Colors.grey.shade400, // Custom border color
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.blue, // Border color when focused
                ),
              ),
              filled: true, // Fill color
              fillColor: Colors.grey.shade100, // Background color of TextField
              contentPadding: const EdgeInsets.all(12), // Padding inside TextField
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.red), // Cancel button in red
            ),
          ),
          TextButton(
            onPressed: () async {
              // Handle edit action
              if (_controller.text.isNotEmpty) {
                Navigator.pop(context); // Close dialog
                await chatProvider.editMessage(message.id!, _controller.text);
              } else {
                // Optionally show a snackbar if message is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Message cannot be empty.")),
                );
              }
            },
            child: const Text("Edit"),
          ),
        ],
      );
    },
  );
}

}

class NoDataPage extends StatelessWidget {
  final VoidCallback onRefresh; // Callback for refresh action

  const NoDataPage({Key? key, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "No Data Available",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRefresh, // Trigger the callback when pressed
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
