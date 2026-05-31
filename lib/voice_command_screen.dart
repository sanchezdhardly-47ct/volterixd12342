import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class VoiceCommandScreen extends StatefulWidget {
  const VoiceCommandScreen({super.key});

  @override
  State<VoiceCommandScreen> createState() => _VoiceCommandScreenState();
}

class _VoiceCommandScreenState extends State<VoiceCommandScreen> {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String _recognizedText = "";
  List<String> _commandHistory = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    super.dispose();
  }

  Future<void> _initRecorder() async {
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _startRecording() async {
    try {
      await _recorder!.startRecorder(
        toFile: 'volter_temp.aac',
        codec: Codec.aacADTS,
      );
      setState(() {
        _isRecording = true;
        _recognizedText = "Escuchando...";
      });
    } catch (e) {
      print("Error al grabar: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
        _isProcessing = true;
        _recognizedText = "Procesando comando...";
      });
      
      // Simular reconocimiento de voz (sin API externa)
      await Future.delayed(const Duration(seconds: 1));
      
      // Como no tenemos API de reconocimiento, simulamos comandos predefinidos
      _showSimulatedCommands();
      
      setState(() {
        _isProcessing = false;
      });
    } catch (e) {
      print("Error al detener: $e");
      setState(() {
        _isProcessing = false;
        _recognizedText = "Error al procesar";
      });
    }
  }

  void _showSimulatedCommands() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¿Qué quieres hacer?', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              _buildCommandTile('Apagar televisor', () => _executeCommand('Apagar televisor')),
              _buildCommandTile('Apagar luces', () => _executeCommand('Apagar luces')),
              _buildCommandTile('Encender aire acondicionado', () => _executeCommand('Encender aire acondicionado')),
              _buildCommandTile('Ver consumo actual', () => _executeCommand('Ver consumo actual')),
              _buildCommandTile('Apagar todo', () => _executeCommand('Apagar todo')),
              const SizedBox(height: 20),
              Text('Próximamente: comandos personalizados por voz real', 
                style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF9CA3AF))),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommandTile(String command, VoidCallback onTap) {
    return ListTile(
      leading: const Icon(Icons.mic, color: Color(0xFF7CDF1E)),
      title: Text(command, style: GoogleFonts.outfit(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF9CA3AF)),
      onTap: onTap,
    );
  }

  void _executeCommand(String command) {
    Navigator.pop(context);
    setState(() {
      _commandHistory.insert(0, command);
    });
    _simulateVolterResponse(command);
  }

  void _simulateVolterResponse(String command) {
    String response;
    command = command.toLowerCase();
    
    if (command.contains('apagar') && command.contains('televisor')) {
      response = "✅ Apagando el televisor. (Simulación)";
    } else if (command.contains('apagar') && command.contains('luz')) {
      response = "✅ Apagando las luces. (Simulación)";
    } else if (command.contains('encender') && command.contains('aire')) {
      response = "✅ Encendiendo el aire acondicionado. (Simulación)";
    } else if (command.contains('consumo')) {
      response = "📊 Consumo actual: 2.3 kWh. Costo estimado: \$5.75 MXN por hora.";
    } else if (command.contains('apagar todo')) {
      response = "✅ Apagando todos los dispositivos. (Simulación)";
    } else {
      response = "🤖 Comando ejecutado: '$command'. (Modo Demo)";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF7CDF1E),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.flash_on, size: 22, color: Colors.black87),
            ),
            const SizedBox(width: 12),
            Text('VOLTER', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(response, style: GoogleFonts.outfit(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: GoogleFonts.outfit(color: const Color(0xFF7CDF1E))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Comandos de voz', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Botón de grabación
          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _isRecording ? _stopRecording : _startRecording,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red : const Color(0xFF7CDF1E),
                      shape: BoxShape.circle,
                      boxShadow: _isRecording ? [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ] : [
                        BoxShadow(
                          color: const Color(0xFF7CDF1E).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      size: 60,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _isRecording ? "Grabando... Presiona para detener" : "Presiona para hablar con VOLTER",
                  style: GoogleFonts.outfit(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (_isProcessing)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF7CDF1E)),
                      ),
                      const SizedBox(width: 12),
                      Text("Procesando...", style: GoogleFonts.outfit(color: Colors.white70)),
                    ],
                  ),
                if (_recognizedText.isNotEmpty && !_isRecording && !_isProcessing)
                  Text(
                    _recognizedText,
                    style: GoogleFonts.outfit(fontSize: 14, color: const Color(0xFF9CA3AF)),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),

          // Historial de comandos
          if (_commandHistory.isNotEmpty)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Últimos comandos', style: GoogleFonts.outfit(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _commandHistory.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: const Color(0xFF1A1A1A),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(Icons.record_voice_over, color: Color(0xFF7CDF1E)),
                              title: Text(
                                _commandHistory[index],
                                style: GoogleFonts.outfit(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}