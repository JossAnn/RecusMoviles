import 'package:flutter/material.dart';
import 'dart:convert'; // Para decodificar JSON
import 'package:http/http.dart' as http;

class APIfeed extends StatefulWidget {
  @override
  _APIfeedState createState() => _APIfeedState();
}

class _APIfeedState extends State<APIfeed> {
  List<dynamic> usuarios = []; // Lista para almacenar los datos de la API
  bool isLoading = true; // Estado para controlar si los datos están cargando

  // URL de la API (modifica según la IP/puerto donde corras tu servidor Flask)
  final String apiUrl = "http://127.0.0.1:5000/api/usuarios";
  //final String apiUrl = "http://10.0.2.2:5000/api/usuarios";
  //final String apiUrl = "http://192.168.1.78:5000/api/usuarios";

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
        // Si la API no responde correctamente
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
              : ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = usuarios[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(usuario['nombre'][0]), // Inicial del nombre
                      ),
                      title: Text(usuario['nombre']),
                      subtitle: Text("Edad: ${usuario['edad']}"),
                      trailing: Text(usuario['correo']),
                    );
                  },
                ),
    );
  }
}
