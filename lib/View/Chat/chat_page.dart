import 'package:flutter/material.dart';
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
        
        
        chatProvider.messages.isEmpty
              ? Expanded(
        child: NoDataPage(
          onRefresh: () {
            // Add your refresh logic here
            chatProvider.fetchLast10Messages(); // Example callback
          },
        ),
      )
              :
        
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: chatProvider.messages.length,
                itemBuilder: (context, index) {
                  return 
                  
                  
                  _buildMessageBubble(chatProvider, index);
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
    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft, // Align based on sender or receiver
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
          color: isUserMessage ? Colors.teal.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: message.isDeleted == 1
            ? Align(
                alignment: isUserMessage
                    ? Alignment.centerRight // Deleted by sender, show on right
                    : Alignment.centerLeft, // Deleted by receiver, show on left
                child: Text(
                  "Message Deleted",
                  style: TextStyle(
                    color: Colors.red.shade700, // Red to indicate deletion
                    fontStyle: FontStyle.italic, // Italic style for distinction
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
        _buildReactionIcon(chatProvider, Icons.emoji_emotions, "haha", messageIndex),
        _buildReactionIcon(chatProvider, Icons.sentiment_very_satisfied, "wow", messageIndex),
        _buildReactionIcon(chatProvider, Icons.sentiment_very_dissatisfied, "sad", messageIndex),
        _buildReactionIcon(chatProvider, Icons.emoji_flags, "angry", messageIndex),
      ],
    );
  }

  Widget _buildReactionIcon(
      ChatProvider chatProvider, IconData icon, String reactionType, int messageIndex) {
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

  Widget _buildMessageInputField(ChatProvider chatProvider, VoidCallback scrollToBottom) {
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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.copy, color: Colors.teal),
              title: Text('Copy'),
              onTap: () {
                // Handle copy action
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete'),
              onTap: () {

                chatProvider.deleteMessage(message.id!);
                // Handle delete action
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.reply, color: Colors.blue),
              title: Text('Reply'),
              onTap: () {
                // Handle reply action
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.forward, color: Colors.blueGrey),
              title: Text('Forward'),
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
          Icon(Icons.inbox, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No Data Available",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRefresh, // Trigger the callback when pressed
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }
}

