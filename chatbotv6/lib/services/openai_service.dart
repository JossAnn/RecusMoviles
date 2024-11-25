import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey = 'APIKEY-DE-OPENAI';
  final String endpoint = 'https://api.openai.com/v1/chat/completions';

  Future<String> getChatResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt",
          "messages": [
            {"role": "system", "content": "Eres un asistente útil."},
            {"role": "user", "content": message}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        return 'Error al obtener respuesta del servidor.';
      }
    } catch (e) {
      print('Excepción: $e');
      return 'Hubo un problema al conectarse al servidor.';
    }
  }
}
