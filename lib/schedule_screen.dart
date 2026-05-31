import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Map<String, dynamic>> _schedules = [];

  void _addSchedule() {
    showDialog(
      context: context,
      builder: (context) {
        String selectedDevice = '';
        String selectedAction = 'encender';
        TimeOfDay selectedTime = TimeOfDay.now();
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text('Programar tarea', style: GoogleFonts.outfit(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF1A1A1A),
                style: GoogleFonts.outfit(color: Colors.white),
                decoration: InputDecoration(labelText: 'Dispositivo', labelStyle: GoogleFonts.outfit(color: const Color(0xFF9CA3AF))),
                items: const [DropdownMenuItem(value: 'Televisor', child: Text('Televisor')), DropdownMenuItem(value: 'Aire Acondicionado', child: Text('Aire Acondicionado')), DropdownMenuItem(value: 'Luz principal', child: Text('Luz principal'))],
                onChanged: (value) => selectedDevice = value!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF1A1A1A),
                style: GoogleFonts.outfit(color: Colors.white),
                decoration: InputDecoration(labelText: 'Acción', labelStyle: GoogleFonts.outfit(color: const Color(0xFF9CA3AF))),
                items: const [DropdownMenuItem(value: 'encender', child: Text('Encender')), DropdownMenuItem(value: 'apagar', child: Text('Apagar'))],
                onChanged: (value) => selectedAction = value!,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Hora', style: GoogleFonts.outfit(color: Colors.white)),
                subtitle: Text(selectedTime.format(context), style: GoogleFonts.outfit(color: const Color(0xFF7CDF1E))),
                onTap: () async {
                  final time = await showTimePicker(context: context, initialTime: selectedTime);
                  if (time != null) selectedTime = time;
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar', style: GoogleFonts.outfit(color: const Color(0xFF9CA3AF)))),
            ElevatedButton(
              onPressed: () {
                setState(() => _schedules.add({'device': selectedDevice, 'action': selectedAction, 'time': selectedTime.format(context)}));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7CDF1E)),
              child: Text('Programar', style: GoogleFonts.outfit(color: Colors.black87)),
            ),
          ],
        );
      },
    );
  }

  void _removeSchedule(int index) => setState(() => _schedules.removeAt(index));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Programación', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [IconButton(onPressed: _addSchedule, icon: const Icon(Icons.add, color: Color(0xFF7CDF1E)))],
      ),
      body: _schedules.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.schedule_outlined, size: 64, color: Color(0xFF9CA3AF)),
                  const SizedBox(height: 16),
                  Text('No hay tareas programadas', style: GoogleFonts.outfit(color: const Color(0xFF9CA3AF))),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _addSchedule,
                    icon: const Icon(Icons.add),
                    label: Text('Agregar tarea', style: GoogleFonts.outfit()),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7CDF1E), foregroundColor: Colors.black87),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                final schedule = _schedules[index];
                return Card(
                  color: const Color(0xFF1A1A1A),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(schedule['action'] == 'encender' ? Icons.power_settings_new : Icons.power_off, color: const Color(0xFF7CDF1E)),
                    title: Text(schedule['device'], style: GoogleFonts.outfit(color: Colors.white)),
                    subtitle: Text('${schedule['action']} a las ${schedule['time']}', style: GoogleFonts.outfit(color: const Color(0xFF9CA3AF))),
                    trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _removeSchedule(index)),
                  ),
                );
              },
            ),
    );
  }
}