import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'volter_ai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final Map<String, dynamic> _context = {
    'totalKw': 12.5,
    'costoEstimado': 31.25,
    'devicesOn': [
      {'name': 'Televisor', 'watts': 80, 'isOn': true},
      {'name': 'Refrigerador', 'watts': 150, 'isOn': true},
    ],
    'devices': [
      {'name': 'Televisor', 'watts': 80, 'isOn': true},
      {'name': 'Refrigerador', 'watts': 150, 'isOn': true},
      {'name': 'Aire Acondicionado', 'watts': 1500, 'isOn': false},
      {'name': 'Lavadora', 'watts': 500, 'isOn': false},
    ],
  };

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    final userMessage = _messageController.text.trim();
    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _messageController.clear();
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    final volterResponse = VolterAIService.processQuery(userMessage, _context);
    setState(() {
      _messages.add({'role': 'volter', 'content': volterResponse});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            Container(width: 32, height: 32, decoration: const BoxDecoration(color: Color(0xFF7CDF1E), shape: BoxShape.circle), child: const Icon(Icons.flash_on, size: 18, color: Colors.black87)),
            const SizedBox(width: 8),
            Text('Chat con VOLTER', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF7CDF1E) : const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(message['content']!, style: GoogleFonts.outfit(color: isUser ? Colors.black87 : Colors.white)),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(width: 30, height: 30, decoration: const BoxDecoration(color: Color(0xFF7CDF1E), shape: BoxShape.circle), child: const Icon(Icons.flash_on, size: 16, color: Colors.black87)),
                  const SizedBox(width: 8),
                  Text('VOLTER está pensando...', style: GoogleFonts.outfit(color: Colors.white70)),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: GoogleFonts.outfit(color: Colors.white),
                    decoration: InputDecoration(hintText: 'Pregúntale algo a VOLTER...', hintStyle: GoogleFonts.outfit(color: const Color(0xFF6B7280)), border: InputBorder.none),
                  ),
                ),
                IconButton(onPressed: _sendMessage, icon: const Icon(Icons.send, color: Color(0xFF7CDF1E))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}