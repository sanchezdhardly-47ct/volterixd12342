import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'voice_command_screen.dart';
import 'chat_screen.dart';
import 'schedule_screen.dart';
import 'volter_ai_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('VOLTER', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF7CDF1E)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.schedule_outlined, color: Color(0xFF7CDF1E)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tarjeta de consumo
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A3A1A), Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Consumo hoy', style: GoogleFonts.outfit(color: Colors.white70)),
                      Text(
                        '${_context['totalKw']} kWh',
                        style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF7CDF1E)),
                      ),
                      Text('\$${_context['costoEstimado']} MXN', style: GoogleFonts.outfit(color: Colors.white70)),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(color: Color(0xFF7CDF1E), shape: BoxShape.circle),
                  child: const Icon(Icons.flash_on, size: 45, color: Colors.black87),
                ),
              ],
            ),
          ),
          
          // Botón de VOLTER
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VoiceCommandScreen())),
            child: Container(
              margin: const EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7CDF1E), Color(0xFF5BAE14)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7CDF1E).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.mic, size: 60, color: Colors.black87),
                    const SizedBox(height: 16),
                    Text(
                      'HABLA CON VOLTER',
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Di "VOLTER apaga la TV"',
                      style: GoogleFonts.outfit(fontSize: 12, color: Colors.black87.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Recomendaciones
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recomendaciones de VOLTER', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  ..._generateRecommendations().map((rec) => Card(
                    color: const Color(0xFF1A1A1A),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.lightbulb_outline, color: Color(0xFF7CDF1E)),
                      title: Text(rec, style: GoogleFonts.outfit(color: Colors.white70)),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Función de recomendaciones CORREGIDA - sin combine problemático
  List<String> _generateRecommendations() {
    List<String> recommendations = [];
    
    // Obtener dispositivos encendidos de forma segura
    List<dynamic> devicesOnRaw = _context['devicesOn'] ?? [];
    List<Map<String, dynamic>> devicesOn = [];
    for (var item in devicesOnRaw) {
      if (item is Map<String, dynamic>) {
        devicesOn.add(item);
      }
    }
    
    // Obtener todos los dispositivos
    List<dynamic> devicesRaw = _context['devices'] ?? [];
    List<Map<String, dynamic>> allDevices = [];
    for (var item in devicesRaw) {
      if (item is Map<String, dynamic>) {
        allDevices.add(item);
      }
    }
    
    // Recomendación 1
    if (devicesOn.isNotEmpty) {
      recommendations.add("Tienes ${devicesOn.length} dispositivos encendidos. Revisa si realmente los necesitas.");
    }
    
    // Recomendación 2: dispositivo con mayor consumo
    if (allDevices.isNotEmpty) {
      Map<String, dynamic> highest = allDevices[0];
      for (var device in allDevices) {
        if ((device['watts'] ?? 0) > (highest['watts'] ?? 0)) {
          highest = device;
        }
      }
      recommendations.add("Tu ${highest['name']} consume ${highest['watts']}W. Intenta usarlo menos horas al día.");
    }
    
    // Recomendación 3: horario pico
    int hour = DateTime.now().hour;
    if (hour >= 18 && hour <= 22) {
      recommendations.add("Estás en horario de alta demanda. Apaga luces que no necesites.");
    }
    
    // Si no hay recomendaciones
    if (recommendations.isEmpty) {
      recommendations.add("¡Excelente! Tu consumo está controlado. Sigue así.");
    }
    
    return recommendations;
  }
}