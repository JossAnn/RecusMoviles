/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';
import 'package:wanderrush/screens/historyscreen.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _speechText = '';
  late FlutterTts _flutterTts;
  late List<String> _bannedWords = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _loadHistory();
    _loadBannedWords();
  }

  // aqui metemos el json con als palabrotas
  Future<void> _loadBannedWords() async {
    final String response =
        await rootBundle.loadString('assets/images/banned_words.json');
    final data = jsonDecode(response);
    setState(() {
      _bannedWords = List<String>.from(data['bannedWords']);
    });
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _messages = prefs.getStringList('chat_history') ?? [];
    });
  }

  Future<void> _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('chat_history', _messages);
  }

  // esta es la funcion pa censurar los mensajes
  String _censorBadWords(String message) {
    for (String word in _bannedWords) {
      //aqui valida si son mayusculas o ne
      if (message.toLowerCase().contains(word)) {
        message =
            message.replaceAll(RegExp(word, caseSensitive: false), '****');
      }
    }
    return message;
  }

  // manda mnensje al chatbot y obtenemos la respuesta
  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      String userMessage = _controller.text;
      String censoredMessage = _censorBadWords(userMessage);

      // si tiene palabrotas lo censura
      if (censoredMessage != userMessage) {
        setState(() {
          _messages.add('Usuario: (mensaje censurado)');
        });
      } else {
        setState(() {
          _messages.add('Usuario: $userMessage');
        });

        _controller.clear();

        try {
          String history = _messages.join('\n');

          final response = await http.post(
            Uri.parse('http://10.14.0.83:5001/ask'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'question': userMessage, 'history': history}),
          );

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            String botMessage = responseData['answer'];
            String censoredBotMessage = _censorBadWords(botMessage);

            setState(() {
              _messages.add('Bot: $censoredBotMessage');
            });

            await _flutterTts.speak(censoredBotMessage);
          } else {
            setState(() {
              _messages.add('Error: No se pudo conectar con el servidor.');
            });
          }
        } catch (e) {
          setState(() {
            _messages.add('Error: $e');
          });
        }

        _saveHistory();
      }
    }
  }

  // Mostrar historial de chat
  void _viewHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(messages: _messages),
      ),
    );
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
    });
    _saveHistory();
  }

  Future<void> _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => setState(() => _isListening = val == 'listening'),
        onError: (val) => setState(() => _isListening = false),
      );
      if (available) {
        _speech.listen(
          onResult: (val) => setState(() {
            _speechText = val.recognizedWords;
            _controller.text = _speechText;
          }),
        );
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 231, 210, 175),
        title: const Text(
          'TOKKI CHAT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 8,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Align(
                    alignment: message.startsWith('Usuario:')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: message.startsWith('Usuario:')
                            ? Colors.blue.shade400
                            : Colors.green.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
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
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? Colors.black : Colors.black,
                  ),
                  onPressed: _startListening,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                      hintStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey.shade700,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/

/*import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../services/openai_service.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final OpenAIService _openAIService = OpenAIService();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;

  void _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": message});
    });

    _controller.clear();
    String botResponse = await _openAIService.getChatResponse(message);

    setState(() {
      _messages.add({"role": "bot", "content": botResponse});
    });

    _speak(botResponse);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
      _sendMessage(_controller.text);
    }
  }

  void _speak(String text) async {
    await _flutterTts.speak(text);
  }

  @override
  void dispose() {
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatBotV6'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(
                    message['content']!,
                    textAlign: message['role'] == 'user'
                        ? TextAlign.right
                        : TextAlign.left,
                    style: TextStyle(
                      color: message['role'] == 'user'
                          ? Colors.blue
                          : Colors.green,
                    ),
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
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                  onPressed: _listen,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: 'Escribe un mensaje'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';

const apiKey = "AIzaSyCTREetNKiEu4cs1Wp8f8So5t6QJrfTJIs";

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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

  String cleanText(String text) {
    return text.replaceAll('*', '');
  }

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
    final String? chatHistory = prefs.getString('chat_history');
    if (chatHistory != null) {
      setState(() {
        textChat = List<Map<String, String>>.from(json
            .decode(chatHistory)
            .map((item) => Map<String, String>.from(item)));
      });
    }
  }

  void _saveChats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_history', json.encode(textChat));
  }

  void fromText({required String query}) {
    if (!isConnected) return;

    setState(() {
      loading = true;
      textChat.add({"role": userName, "text": query});
      _textController.clear();
    });
    _saveChats();
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        String cleanedText = cleanText(value.text);
        textChat.add({"role": "Assistant", "text": cleanedText});
      });
      _speak(cleanText(value.text));
      _saveChats();
      scrollToTheEnd();
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textChat.add({"role": "Assistant", "text": error.toString()});
      });
      _saveChats();
      scrollToTheEnd();
    });
  }

  void _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Error: $error'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              _textController.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  void scrollToTheEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Assistant', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 190, 47, 212),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () async {
              setState(() {
                textChat.clear();
              });
              _saveChats();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _controller,
                itemCount: textChat.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  bool isUser = textChat[index]["role"] == userName;
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Color.fromARGB(255, 144, 90, 252)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft:
                              isUser ? Radius.circular(12) : Radius.zero,
                          bottomRight:
                              isUser ? Radius.zero : Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textChat[index]["role"]!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isUser ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            cleanText(textChat[index]["text"]!),
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    onPressed: _listen,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: isConnected
                        ? () => fromText(query: _textController.text)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';

const apiKey = "AIzaSyCTREetNKiEu4cs1Wp8f8So5t6QJrfTJIs";

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
