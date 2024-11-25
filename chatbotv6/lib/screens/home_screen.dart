/*import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> messages;

  const HistoryScreen({super.key, this.messages = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Conversaciones'),
        backgroundColor: Colors.grey.shade200,
        titleTextStyle: const TextStyle(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  messages[index],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
*/

/*import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> messages;

  const HistoryScreen({super.key, this.messages = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Conversaciones'),
        backgroundColor:
            const Color.fromARGB(255, 0, 123, 255), // Color igual al del chat
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 183, 58, 166),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'lib/images/logoupchiapas.png', // Coloca el logo de tu universidad aquí
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Universidad Ploitecnica de Chiapas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Carrera: Ingeniería en Software',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Materia: PROGRAMACIÓN PARA MÓVILES II',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Grupo: 9no A',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Alumno: José Ángel Nataren Ordoñez',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Matrícula: 213367',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              child: const Text(
                'Ir al Chat',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 117, 27, 117),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () {
                  // Abre el enlace al repositorio en el navegador
                  final url =
                      'https://github.com/JossAnn/RecusMoviles/tree/main/chatbotv6';
                  launch(
                      url); // Asegúrate de tener importado el paquete 'url_launcher'
                },
                child: const Text(
                  'Ver Repositorio',
                  style: TextStyle(color: Color.fromARGB(255, 104, 11, 91)),
                ),
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
import 'chat_screen.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'lib/images/logoupchiapas.png', // Coloca el logo de tu universidad aquí
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Universidad Politécnica de Chiapas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Carrera: Ingeniería en Software',
                style: TextStyle(fontSize: 16)),
            const Text('Materia: Programación para Móviles II',
                style: TextStyle(fontSize: 16)),
            const Text('Grupo: 9no A', style: TextStyle(fontSize: 16)),
            const Text('Alumno: José Ángel Nataren Ordoñez',
                style: TextStyle(fontSize: 16)),
            const Text('Matrícula: 213367', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                  );
                },
                child: const Text('Ir al Chat'),
              ),
            ),
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () async {
                  const url =
                      'https://github.com/JossAnn/RecusMoviles/tree/main/chatbotv6';
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
                child: const Text(
                  'Ver Repositorio',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
