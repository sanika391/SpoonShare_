import 'package:flutter/material.dart';
import 'package:dialogflow_flutter/dialogflow_flutter.dart';

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Map> _messages = [];
  final TextEditingController _controller = TextEditingController();
  Dialogflow dialogflow;

  @override
  void initState() {
    super.initState();
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/dialogflow_credentials.json").build();
    dialogflow = Dialogflow(authGoogle: authGoogle, language: Language.english);
  }

  void _sendMessage(String text) async {
    setState(() {
      _messages.add({"data": 1, "message": text});
    });
    _controller.clear();
    AIResponse response = await dialogflow.detectIntent(text);
    setState(() {
      _messages.add({"data": 0, "message": response.getMessage() ?? ''});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI ChatBot')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessageItem(_messages[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Enter message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map msg) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: msg['data'] == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: msg['data'] == 1 ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              msg['message'],
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
