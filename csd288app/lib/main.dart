import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Data Demo',
      home: UserDataScreen(),
    );
  }
}

class UserDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data Screen'),
      ),
      body: Center(
        child: Text('User Data Screen Content'),
      ),
    );
  }
}

class MessageDataLayer {
  static List<String> _messageQueue = [];
  static bool _isOnline = true;
  static List<String> _messages = [];

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
    
  }

  static void deleteMessage(int index) {
    if (index >= 0 && index < _messages.length) {
      _messages.removeAt(index);
    }
  }
}

class ChatHistoryDataLayer {
  static List<String> _chatHistory = [];

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

//Message myMessage = Message(
//  'Hello, blah blah
//  imageUrls: ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'],
//);

//helped to create what i needed for data layer ^^^^^^