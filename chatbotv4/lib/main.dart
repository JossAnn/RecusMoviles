import 'package:flutter/material.dart';
import 'screens/api.dart';
import 'screens/apiones.dart';

void main() {
  runApp(ChatBotV4App());
}

class ChatBotV4App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatBotV4',
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
        title: Text('ChatBotV4'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logoup.png',
                height:
                    100), // Asegúrate de colocar el archivo en la carpeta correcta
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
                      'https://github.com/JossAnn/RecusMoviles/tree/main/chatbotv4',
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
                  MaterialPageRoute(builder: (context) => APIfeed()),
                );
              },
              child: Text('Ir a todos los contactos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => APIones()),
                );
              },
              child: Text('Ir a contactos individuales'),
            ),
          ],
        ),
      ),
    );
  }
}
