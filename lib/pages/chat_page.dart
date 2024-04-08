import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    // Simulate fetching data
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        messages = [
          'Hello!',
          'Hi there!',
          'How are you?',
          'I\'m doing good. Thanks!'
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageWidget(
                  message: messages[index],
                  isMe: index % 2 == 0, // Alternate message alignment
                );
              },
            ),
          ),
          InputWidget(),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String message;
  final bool isMe;

  const MessageWidget({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

class InputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
