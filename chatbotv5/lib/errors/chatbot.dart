//Chatbot() {}
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';

const apiKey = "AIzaSyA6NDbuwBbFlmWIAn7kem-MJEhY2W9vOnE";

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  bool loading = false;
  bool isConnected = true;
  bool _isListening = false;
  List<Map<String, String>> textChat = [];
  String userName = "User";

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  final gemini = GoogleGemini(apiKey: apiKey);
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _checkConnectivity();
    _loadChats();
  }

  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  void _loadChats() async {
    final prefs = await SharedPreferences.getInstance();
    final chatHistory = prefs.getString('chat_history');
    if (chatHistory != null) {
      setState(() {
        textChat = List<Map<String, String>>.from(
          json
              .decode(chatHistory)
              .map((item) => Map<String, String>.from(item)),
        );
      });
    }
  }

  void _saveChats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_history', json.encode(textChat));
  }

  void fromText(String query) {
    if (!isConnected) return;

    setState(() {
      loading = true;
      textChat.add({"role": userName, "text": query});
      _textController.clear();
    });
    _saveChats();
    _scrollToEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textChat.add({"role": "Assistant", "text": value.text});
      });
      _saveChats();
      _scrollToEnd();
      _speak(value.text);
    }).catchError((error) {
      setState(() {
        loading = false;
        textChat.add({"role": "Assistant", "text": error.toString()});
      });
      _saveChats();
      _scrollToEnd();
    });
  }

  void _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.speak(text);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
        });
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                textChat.clear();
              });
              _saveChats();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: textChat.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                bool isUser = textChat[index]["role"] == userName;
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(textChat[index]["text"]!),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _listen,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed:
                      isConnected ? () => fromText(_textController.text) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
