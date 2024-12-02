import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
//import 'qr_code_scanner_screen.dart';

const apiKey = "AIzaSyA6NDbuwBbFlmWIAn7kem-MJEhY2W9vOnE";

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool loading = false;
  bool isConnected = true;
  List<Map<String, String>> textChat = [];
  String userName = "User";

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  final gemini = GoogleGemini(apiKey: apiKey);

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadChats();
  }

  void _checkConnectivity() async {
    // Verificación de conexión (opcional)
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  void _loadChats() async {
    // Cargar chats almacenados (opcional)
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
    // Guardar chats (opcional)
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
    }).catchError((error) {
      setState(() {
        loading = false;
        textChat.add({"role": "Assistant", "text": error.toString()});
      });
      _saveChats();
      _scrollToEnd();
    });
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  Future<void> _scanQr() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QrCodeScannerScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        _textController.text = result; // Poner el valor del QR en el input
      });
    }
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
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _scanQr, // Activar escaneo QR
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

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  _QrCodeScannerScreenState createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  String? qrCodeResult = "Escanea un código QR";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escáner de Código QR'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: MobileScanner(
              controller: controller,
              onDetect: (BarcodeCapture capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  setState(() {
                    qrCodeResult = barcode.rawValue ?? "Código no detectado";
                  });

                  // Verifica que el QR no sea nulo o vacío antes de cerrarlo
                  if (qrCodeResult != null && qrCodeResult!.isNotEmpty) {
                    Navigator.pop(context, qrCodeResult);
                    return; // Salir de la función para evitar múltiples pop
                  }
                }
              },
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  qrCodeResult ?? "Escanea un código QR",
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
