/*import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(ChatBotV6App());
}

class ChatBotV6App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatBotV6',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBotV6'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logoup.png', height: 100),
            SizedBox(height: 20),
            Text(
              'Ingeniería en Software\nProgramación para Móviles II\nGrupo: 9no A',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Alumno: José Ángel Nataren Ordoñez\nMatrícula: 213367',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Aquí puedes abrir el enlace del repositorio en el navegador
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Enlace al Repositorio'),
                    content: Text(
                      'https://github.com/JossAnn/RecusMoviles/tree/main/chatbotv6',
                    ),
                  ),
                );
              },
              child: Text(
                'Repositorio: GitHub',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatbotScreen()),
                );
              },
              child: Text('Ir a Chat'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
              child: Text('Ir al historial'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';
import 'screens/home_screen.dart'; // Importa la vista de HomeScreen

const apiKey = "AIzaSyA6NDbuwBbFlmWIAn7kem-MJEhY2W9vOnE";

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 105, 166, 140)),
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
        title: const Text(
          "Google Gemini IA",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 58, 177, 183),
        actions: <Widget>[
          Image.network('images/logoupchiapas.png'),
        ],
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

  // Entrada solo de texto
  void fromText({required String query}) {
    setState(() {
      loading = true;
      textChat.add({
        "role": "User",
        "text": query,
      });
      _textController.clear();
    });
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textChat.add({"role": "Gemini", "text": value.text});
      });
      scrollToTheEnd();
    }).onError((error, stackTrace) {
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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (textChat.isEmpty) ...[
            const Expanded(
                flex: 10,
                child: Center(
                  child: Text(
                    'Hola👋 soy Gemini:)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 20,
                    ),
                  ),
                ))
          ],
          Expanded(
            child: ListView.builder(
              controller: _controller,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: textChat.length,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    child: Text(textChat[index]["role"].substring(0, 1)),
                  ),
                  title: Text(textChat[index]["role"]),
                  subtitle: Text(textChat[index]["text"]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 26),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    minLines: 1,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Iniciar conversación',
                      contentPadding: const EdgeInsets.only(
                        left: 20,
                        top: 10,
                        bottom: 10,
                      ),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(height: 0),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: loading
                            ? const CircularProgressIndicator()
                            : InkWell(
                                onTap: () {
                                  fromText(query: _textController.text);
                                },
                                child: const CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 183, 250, 255),
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';
import 'screens/home_screen.dart'; // Importa la vista de HomeScreen

const apiKey = "Aqui-Va-La_APIKEY";

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
