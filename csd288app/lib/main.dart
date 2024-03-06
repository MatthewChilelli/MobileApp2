import 'dart:async';
import 'package:flutter/material.dart';
import 'global.dart';

void main() {
  runApp(MyApp());
}

//im going overboard with Lab 3 because i though i did well on lab 2 but it was not nearrly enough
//besides the navigation and crerate message which is what 8im assuming lab 3 is asking for 
//im going to get each stateless widget working in some compacity maybe not backed with a database of users and convos but 
//at least lists i can hardcode right into this.
// execpt chat history, for thatr im going to select a user from the globallist that the user can make with the create user funtion
// and show what messages has been sent to that person. perhaps anotrher day tho

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation',
      home: UserDataScreen(), // UserDataScreen as the home screen of the app
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //get the total number of messages, idk why i put this in but im sticking to my lab 2 design which is kind of bad
    final int totalMessages = ChatHistoryDataLayer.getChatHistory().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Center(
        child: Text('Total messages: $totalMessages'),
      ),
    );
  }
}

class CreateMessageScreen extends StatefulWidget {
  const CreateMessageScreen({super.key});

  @override
  _CreateMessageScreenState createState() => _CreateMessageScreenState();
}

class _CreateMessageScreenState extends State<CreateMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  UserData? _selectedUser; // Added to store the selected user

  void _sendMessage(BuildContext context) async {
    final String message = _controller.text.trim();
    if (message.isNotEmpty && _selectedUser != null) { // Check if a user is selected
      // Update the sendMessage call to include the selected user's username
      await MessageDataLayer.sendMessage("To: ${_selectedUser!.username}, Message: $message");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message sent to ${_selectedUser!.username}!')),
      );
      _controller.clear(); // Clear the text field after sending the message
    }
  }

  // Function to show a modal bottom sheet for user selection
  void _showUserSelectModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return ListView.builder(
        itemCount: globalUsers.length, // Use globalUsers here
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(globalUsers[index].username),
            onTap: () {
              setState(() {
                _selectedUser = globalUsers[index];
              });
              Navigator.pop(context); // Close the modal after selection
            },
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 5, // Allow the input to expand to multiple lines
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _showUserSelectModal(context), //button to show user selection modal
              child: const Text('Select User'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _sendMessage(context),
              child: Text('Send to ${_selectedUser?.username ?? "Select a user"}'), // Show selected user
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> chatHistory = ChatHistoryDataLayer.getChatHistory();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
      ),
      body: ListView.builder(
        itemCount: chatHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(chatHistory[index]),
          );
        },
      ),
    );
  }
}

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {

  void _showUsersModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return ListView.builder(
        itemCount: globalUsers.length,
        itemBuilder: (context, index) {
          UserData user = globalUsers[index];
          return ListTile(
            title: Text(user.username),
            subtitle: Text(user.email),
          );
        },
      );
    },
  );
}

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _createUser() {
  final String username = _usernameController.text;
  final String password = _passwordController.text;
  final String email = _emailController.text;

  if (username.isNotEmpty && password.isNotEmpty && email.isNotEmpty) {
    final userData = UserData(username: username, password: password, email: email);
    globalUsers.add(userData); //add to the global list

    //clear the text fields after adding the user
    _usernameController.clear();
    _passwordController.clear();
    _emailController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User created successfully!')),
    );

    print(globalUsers);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Username',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createUser,
              child: const Text('Create User'),
            ),
            ElevatedButton(
              onPressed: () => _showUsersModal(context),
              child: const Text('Show All Users'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    //clean up the controllers when the widget is disposed.
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class UserDataScreen extends StatelessWidget {
  const UserDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data Screen'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('User Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfileScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Create Message'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateMessageScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Chat History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatHistoryScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Create User'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateUserScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MessageDataLayer {
  static final List<String> _messageQueue = [];
  static bool _isOnline = true;
  static final List<String> _messages = [];

  static Future<void> sendMessage(String message) async {
    if (_isOnline) {
      print('Sending message ...: $message');
    } else {
      print('Queueing message for when data or wifi turns on: $message');
      _messageQueue.add(message);
    }
  }

  static Future<void> checkConnectivityStatus() async {
    _isOnline = true;
    if (_isOnline) {
      await _sendQueuedMessages();
    }
  }

  static Future<void> _sendQueuedMessages() async {
    if (_messageQueue.isNotEmpty) {
      for (String message in _messageQueue) {
        print('Sending message: $message');
      }
      _messageQueue.clear();
    }
  }

  static void markMessageAsRead(int index) {
    // Placeholder for marking a message as read
  }

  static void deleteMessage(int index) {
    if (index >= 0 && index < _messages.length) {
      _messages.removeAt(index);
    }
  }
}

class ChatHistoryDataLayer {
  static final List<String> _chatHistory = [];

  static void addMessage(String message) {
    _chatHistory.add(message);
  }

  static List<String> getChatHistory() {
    return List.from(_chatHistory);
  }
}

class MessageType {
  final String content;
  final List<String>? imageUrls;

  MessageType(this.content, {this.imageUrls});
}