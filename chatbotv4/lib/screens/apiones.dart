import 'package:flutter/material.dart';
import 'dart:convert'; // Para decodificar JSON
import 'package:http/http.dart' as http;

class APIones extends StatefulWidget {
  @override
  _APIonesState createState() => _APIonesState();
}

class _APIonesState extends State<APIones> {
  List<dynamic> usuarios = []; // Lista para almacenar los datos de la API
  bool isLoading = true; // Estado para controlar si los datos están cargando
  int currentIndex = 0; // Índice del usuario actual

  // URL de la API (modifica según la IP/puerto donde corras tu servidor Flask)
  final String apiUrl = "http://127.0.0.1:5000/api/usuarios";

  @override
  void initState() {
    super.initState();
    fetchUsuarios();
  }

  // Función para obtener los datos de la API
  Future<void> fetchUsuarios() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          usuarios = json.decode(response.body); // Decodifica el JSON
          isLoading = false; // Datos cargados
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Error al obtener los datos de la API');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  void previousUser() {
    setState(() {
      if (currentIndex > 0) currentIndex--;
    });
  }

  void nextUser() {
    setState(() {
      if (currentIndex < usuarios.length - 1) currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios API'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : usuarios.isEmpty
              ? Center(
                  child: Text(
                    'No se encontraron usuarios',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(usuarios[currentIndex]['nombre'][0]),
                    ),
                    SizedBox(height: 20),
                    Text(
                      usuarios[currentIndex]['nombre'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Edad: ${usuarios[currentIndex]['edad']}",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      usuarios[currentIndex]['correo'],
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: currentIndex > 0 ? previousUser : null,
                          icon: Icon(Icons.arrow_left),
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          onPressed: currentIndex < usuarios.length - 1
                              ? nextUser
                              : null,
                          icon: Icon(Icons.arrow_right),
                        ),
                      ],
                    )
                  ],
                ),
    );
  }
}
