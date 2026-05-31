import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'home_mapping_screen.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  String? _selectedLocation;

  final List<Map<String, dynamic>> locations = [
    {
      'id': 'hogar',
      'title': 'Hogar',
      'subtitle': 'Casa, departamento o residencia',
      'icon': Icons.home_outlined,
      'iconSelected': Icons.home,
      'color': Color(0xFF7CDF1E),
    },
    {
      'id': 'empresa',
      'title': 'Empresa u Oficina',
      'subtitle': 'Oficina, negocio o comercio',
      'icon': Icons.business_outlined,
      'iconSelected': Icons.business,
      'color': Color(0xFF5BAE14),
    },
    {
      'id': 'industria',
      'title': 'Industria',
      'subtitle': 'Fábrica, taller o almacén',
      'icon': Icons.factory_outlined,
      'iconSelected': Icons.factory,
      'color': Color(0xFF3D8A0A),
    },
    {
      'id': 'otros',
      'title': 'Otros',
      'subtitle': 'Otro tipo de espacio',
      'icon': Icons.more_horiz_outlined,
      'iconSelected': Icons.more_horiz,
      'color': Color(0xFF9CA3AF),
    },
  ];

  void _selectLocation(String locationId) {
    setState(() {
      _selectedLocation = locationId;
    });

    // Si selecciona "Hogar", navega directamente al HomeScreen
    if (locationId == 'hogar') {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeMappingScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Botón de volver
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Título
              Text(
                '¿DÓNDE\nTRABAJAMOS?',
                style: GoogleFonts.outfit(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'Selecciona el espacio donde VOLTER\nte ayudará a optimizar la energía',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF9CA3AF),
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Grid de opciones
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    final isSelected = _selectedLocation == location['id'];
                    
                    return GestureDetector(
                      onTap: () => _selectLocation(location['id']),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    location['color'],
                                    location['color'].withOpacity(0.7),
                                  ],
                                )
                              : null,
                          color: isSelected ? null : const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: location['color'].withOpacity(0.3),
                                  width: 1,
                                ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: location['color'].withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSelected ? location['iconSelected'] : location['icon'],
                              size: 48,
                              color: isSelected ? Colors.black87 : location['color'],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              location['title'],
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.black87 : Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              location['subtitle'],
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: isSelected ? Colors.black87.withOpacity(0.7) : const Color(0xFF6B7280),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Indicador de que Hogar lleva al dashboard
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.tips_and_updates, size: 20, color: const Color(0xFF7CDF1E)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Por ahora, solo "Hogar" está disponible. Las demás opciones llegarán pronto.',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}