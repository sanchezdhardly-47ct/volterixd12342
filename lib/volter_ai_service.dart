class VolterAIService {
  static String processQuery(String query, Map<String, dynamic> context) {
    query = query.toLowerCase();

    if (query.contains('cuánta energía') || query.contains('cuanto estoy gastando')) {
      double totalKw = (context['totalKw'] ?? 0).toDouble();
      double costoEstimado = (context['costoEstimado'] ?? 0).toDouble();
      return "Actualmente estás consumiendo ${totalKw.toStringAsFixed(1)} kWh. Esto equivale a aproximadamente \$${costoEstimado.toStringAsFixed(2)} MXN en el día.";
    }

    if (query.contains('qué equipos me olvidé') || query.contains('que me falta apagar')) {
      List<dynamic> devicesOnRaw = context['devicesOn'] ?? [];
      if (devicesOnRaw.isEmpty) {
        return "¡Excelente! Todos tus dispositivos están apagados. Sigue así ahorrando energía.";
      }
      List<String> deviceNames = [];
      for (var item in devicesOnRaw) {
        if (item is Map<String, dynamic>) {
          deviceNames.add(item['name'] ?? 'desconocido');
        }
      }
      String devicesList = deviceNames.join(', ');
      return "Tienes estos dispositivos encendidos: $devicesList. ¿Quieres que te ayude a apagarlos?";
    }

    List<dynamic> devicesRaw = context['devices'] ?? [];
    for (var item in devicesRaw) {
      if (item is Map<String, dynamic>) {
        String deviceName = (item['name'] ?? '').toLowerCase();
        if (query.contains(deviceName)) {
          String status = (item['isOn'] ?? false) ? "encendido" : "apagado";
          double watts = (item['watts'] ?? 0).toDouble();
          double costPerHour = (watts / 1000) * 2.5;
          return "El ${item['name']} está $status. Si lo usas 1 hora, cuesta aproximadamente \$${costPerHour.toStringAsFixed(2)} MXN.";
        }
      }
    }

    return "Entiendo tu consulta. Por ahora, puedo ayudarte con: \n• Cuánta energía estás gastando\n• Qué equipos olvidaste apagar\n• Costo de uso por hora\n• Consejos de ahorro personalizados";
  }

  static List<String> generateRecommendations(Map<String, dynamic> context) {
    List<String> recommendations = [];
    
    List<dynamic> devicesOnRaw = context['devicesOn'] ?? [];
    List<dynamic> allDevicesRaw = context['devices'] ?? [];

    if (devicesOnRaw.isNotEmpty) {
      recommendations.add("Tienes ${devicesOnRaw.length} dispositivos encendidos. Revisa si realmente los necesitas.");
    }
    
    if (allDevicesRaw.isNotEmpty) {
      Map<String, dynamic> highest = {};
      double maxWatts = 0;
      for (var item in allDevicesRaw) {
        if (item is Map<String, dynamic>) {
          double watts = (item['watts'] ?? 0).toDouble();
          if (watts > maxWatts) {
            maxWatts = watts;
            highest = item;
          }
        }
      }
      if (highest.isNotEmpty) {
        recommendations.add("Tu ${highest['name']} consume ${highest['watts']}W. Intenta usarlo menos horas al día.");
      }
    }
    
    int hour = DateTime.now().hour;
    if (hour >= 18 && hour <= 22) {
      recommendations.add("Estás en horario de alta demanda. Apaga luces que no necesites.");
    }
    
    if (recommendations.isEmpty) {
      recommendations.add("¡Excelente! Tu consumo está controlado.");
    }
    
    return recommendations;
  }
}