import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';
import 'screens/home_screen.dart'; // Importa la vista de HomeScreen

const apiKey = "AIzaSyA6NDbuwBbFlmWIAn7kem-MJEhY2W9vOnE";

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.teal,
      useMaterial3: true,
    ),
    home: HomeScreen(), // Establecemos la vista inicial como HomeScreen
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Gemini IA"),
        centerTitle: true,
      ),
      body: const TextWithImage(),
    );
  }
}

class TextWithImage extends StatefulWidget {
  const TextWithImage({Key? key}) : super(key: key);

  @override
  State<TextWithImage> createState() => _TextWithImageState();
}

class _TextWithImageState extends State<TextWithImage> {
  bool loading = false;
  List textChat = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  // Crear instancia de Gemini
  final gemini = GoogleGemini(apiKey: apiKey);

  void fromText({required String query}) {
    setState(() {
      loading = true;
      textChat.add({"role": "User", "text": query});
      _textController.clear();
    });
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textChat.add({"role": "Gemini", "text": value.text});
      });
      scrollToTheEnd();
    }).catchError((error) {
      setState(() {
        loading = false;
        textChat.add({"role": "Gemini", "text": error.toString()});
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (textChat.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'Hola👋 soy Gemini :)',
                style: TextStyle(fontSize: 18, color: Colors.teal),
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: _controller,
            itemCount: textChat.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(textChat[index]["role"][0]),
                ),
                title: Text(textChat[index]["role"]),
                subtitle: Text(textChat[index]["text"]),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Escribe tu mensaje...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              loading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_textController.text.isNotEmpty) {
                          fromText(query: _textController.text);
                        }
                      },
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
