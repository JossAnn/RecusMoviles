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
