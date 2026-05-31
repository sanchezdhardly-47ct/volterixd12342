import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_screen.dart';
import 'auth_service.dart';

class HomeMappingScreen extends StatefulWidget {
  const HomeMappingScreen({super.key});

  @override
  State<HomeMappingScreen> createState() => _HomeMappingScreenState();
}

class _HomeMappingScreenState extends State<HomeMappingScreen> {
  final AuthService _authService = AuthService(); // ← AGREGADO
  
  int numberOfFloors = 1;
  List<Floor> floors = [];

  // Lista de dispositivos predefinidos
  final List<Device> availableDevices = [
    Device(name: 'Foco LED', baseWatts: 9, icon: Icons.lightbulb_outline),
    Device(name: 'Televisor', baseWatts: 80, icon: Icons.tv_outlined),
    Device(name: 'Refrigerador', baseWatts: 150, icon: Icons.kitchen_outlined),
    Device(name: 'Ventilador', baseWatts: 60, icon: Icons.toys_outlined),
    Device(name: 'Computadora', baseWatts: 200, icon: Icons.computer_outlined),
    Device(name: 'Cargador', baseWatts: 10, icon: Icons.phone_android_outlined),
    Device(name: 'Microondas', baseWatts: 1200, icon: Icons.microwave_outlined),
    Device(name: 'Aire Acondicionado', baseWatts: 1500, icon: Icons.ac_unit_outlined),
    Device(name: 'Calentador de Agua', baseWatts: 2000, icon: Icons.water_drop_outlined),
    Device(name: 'Lavadora', baseWatts: 500, icon: Icons.local_laundry_service_outlined),
    Device(name: 'Secadora', baseWatts: 800, icon: Icons.dry_outlined),
    Device(name: 'Licuadora', baseWatts: 300, icon: Icons.sports_bar_outlined),
    Device(name: 'Router WiFi', baseWatts: 10, icon: Icons.wifi_outlined),
    Device(name: 'Consola de Videojuegos', baseWatts: 150, icon: Icons.sports_esports_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _initializeFloors();
  }

  void _initializeFloors() {
    floors = [];
    for (int i = 0; i < numberOfFloors; i++) {
      floors.add(Floor(
        level: i + 1,
        name: 'Piso ${i + 1}',
        rooms: [
          Room(name: 'Sala de estar', devices: []),
        ],
      ));
    }
    setState(() {});
  }

  void _addRoom(int floorIndex) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController roomNameController = TextEditingController();
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text('Nueva habitación', style: GoogleFonts.outfit(color: Colors.white)),
          content: TextField(
            controller: roomNameController,
            style: GoogleFonts.outfit(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Ej: Dormitorio principal',
              hintStyle: GoogleFonts.outfit(color: const Color(0xFF6B7280)),
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: GoogleFonts.outfit(color: const Color(0xFF9CA3AF))),
            ),
            ElevatedButton(
              onPressed: () {
                if (roomNameController.text.isNotEmpty) {
                  setState(() {
                    floors[floorIndex].rooms.add(Room(
                      name: roomNameController.text,
                      devices: [],
                    ));
                  });
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7CDF1E)),
              child: Text('Agregar', style: GoogleFonts.outfit(color: Colors.black87)),
            ),
          ],
        );
      },
    );
  }

  void _addDeviceToRoom(int floorIndex, int roomIndex) {
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
              Text('Agregar dispositivo', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: availableDevices.length,
                  itemBuilder: (context, index) {
                    final device = availableDevices[index];
                    return ListTile(
                      leading: Icon(device.icon, color: const Color(0xFF7CDF1E)),
                      title: Text(device.name, style: GoogleFonts.outfit(color: Colors.white)),
                      subtitle: Text('${device.baseWatts} W', style: GoogleFonts.outfit(color: const Color(0xFF9CA3AF))),
                      onTap: () {
                        setState(() {
                          floors[floorIndex].rooms[roomIndex].devices.add(Device(
                            name: device.name,
                            baseWatts: device.baseWatts,
                            icon: device.icon,
                          ));
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeDevice(int floorIndex, int roomIndex, int deviceIndex) {
    setState(() {
      floors[floorIndex].rooms[roomIndex].devices.removeAt(deviceIndex);
    });
  }

  void _removeRoom(int floorIndex, int roomIndex) {
    setState(() {
      floors[floorIndex].rooms.removeAt(roomIndex);
    });
  }

  double _calculateTotalWatts() {
    double total = 0;
    for (var floor in floors) {
      for (var room in floor.rooms) {
        for (var device in room.devices) {
          total += device.baseWatts;
        }
      }
    }
    return total;
  }

  double _calculateTotalKwPerDay() {
    double total = 0;
    for (var floor in floors) {
      for (var room in floor.rooms) {
        for (var device in room.devices) {
          total += (device.baseWatts * 8) / 1000;
        }
      }
    }
    return total;
  }

  // FUNCIÓN CORREGIDA - Ahora guarda en Firebase
  Future<void> _saveAndNavigate() async {
    // Guardar el mapeo en Firebase (puedes expandir esto después)
    final user = _authService.getCurrentUser();
    if (user != null) {
      await _authService.markSetupAsCompleted(user.uid);
    }
    
    // Guardar los datos del mapeo (opcional - lo haremos después)
    // Por ahora solo marcamos que completó el setup
    
    if (!mounted) return;
    
    // Mostrar diálogo de confirmación
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text('Configuración guardada', style: GoogleFonts.outfit(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Potencia total: ${_calculateTotalWatts().toStringAsFixed(0)} W',
              style: GoogleFonts.outfit(color: const Color(0xFF7CDF1E), fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Consumo estimado: ${_calculateTotalKwPerDay().toStringAsFixed(1)} kWh/día',
              style: GoogleFonts.outfit(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              'VOLTER ahora conoce tu hogar y te ayudará a optimizar tu consumo.',
              style: GoogleFonts.outfit(color: Color(0xFF9CA3AF), fontSize: 13),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (mounted) {
                Navigator.of(context).pop(); // Cerrar diálogo
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7CDF1E),
            ),
            child: Text('Ver dashboard', style: GoogleFonts.outfit(color: Colors.black87)),
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
        title: Text('Mapeo de mi hogar', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveAndNavigate,
            child: Text('Guardar', style: GoogleFonts.outfit(color: const Color(0xFF7CDF1E), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Selector de pisos
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.apartment, color: Color(0xFF7CDF1E)),
                const SizedBox(width: 12),
                Text('Número de pisos:', style: GoogleFonts.outfit(color: Colors.white)),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (numberOfFloors > 1) {
                      numberOfFloors--;
                      _initializeFloors();
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF7CDF1E)),
                ),
                Text('$numberOfFloors', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                IconButton(
                  onPressed: () {
                    if (numberOfFloors < 3) {
                      numberOfFloors++;
                      _initializeFloors();
                    }
                  },
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF7CDF1E)),
                ),
              ],
            ),
          ),
          
          // Lista de pisos y habitaciones
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: floors.length,
              itemBuilder: (context, floorIndex) {
                return Card(
                  color: const Color(0xFF1A1A1A),
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ExpansionTile(
                    leading: const Icon(Icons.house_outlined, color: Color(0xFF7CDF1E)),
                    title: Text(floors[floorIndex].name, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                    children: [
                      ...floors[floorIndex].rooms.asMap().entries.map((entry) {
                        int roomIndex = entry.key;
                        Room room = entry.value;
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ExpansionTile(
                            leading: const Icon(Icons.room_outlined, color: Color(0xFF7CDF1E)),
                            title: Text(room.name, style: GoogleFonts.outfit(color: Colors.white)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add_circle, color: Color(0xFF7CDF1E), size: 20),
                                  onPressed: () => _addDeviceToRoom(floorIndex, roomIndex),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  onPressed: () => _removeRoom(floorIndex, roomIndex),
                                ),
                              ],
                            ),
                            children: [
                              if (room.devices.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text('No hay dispositivos', style: GoogleFonts.outfit(color: const Color(0xFF6B7280))),
                                ),
                              ...room.devices.asMap().entries.map((deviceEntry) {
                                int deviceIndex = deviceEntry.key;
                                Device device = deviceEntry.value;
                                return ListTile(
                                  leading: Icon(device.icon, color: const Color(0xFF7CDF1E)),
                                  title: Text(device.name, style: GoogleFonts.outfit(color: Colors.white)),
                                  subtitle: Text('${device.baseWatts} W', style: GoogleFonts.outfit(color: const Color(0xFF9CA3AF))),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () => _removeDevice(floorIndex, roomIndex, deviceIndex),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ElevatedButton.icon(
                          onPressed: () => _addRoom(floorIndex),
                          icon: const Icon(Icons.add),
                          label: Text('Agregar habitación'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7CDF1E),
                            foregroundColor: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Resumen de consumo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.energy_savings_leaf, color: Color(0xFF7CDF1E)),
                    const SizedBox(width: 12),
                    Text('Potencia total instalada:', style: GoogleFonts.outfit(color: Colors.white)),
                    const Spacer(),
                    Text('${_calculateTotalWatts().toStringAsFixed(0)} W', 
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF7CDF1E))
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 36),
                    Text('Consumo estimado diario:', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12)),
                    const Spacer(),
                    Text('${_calculateTotalKwPerDay().toStringAsFixed(1)} kWh', 
                      style: GoogleFonts.outfit(fontSize: 14, color: const Color(0xFF9CA3AF))
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Modelos de datos
class Floor {
  int level;
  String name;
  List<Room> rooms;

  Floor({required this.level, required this.name, required this.rooms});
}

class Room {
  String name;
  List<Device> devices;

  Room({required this.name, required this.devices});
}

class Device {
  String name;
  int baseWatts;
  IconData icon;

  Device({required this.name, required this.baseWatts, required this.icon});
}