import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Lógica Matemática Pura do ETo
class EToCalculator {
  static double calculateExtraterrestrialRadiation(double latitude, int dayOfYear) {
    final double latitudeRad = latitude * pi / 180;
    final double solarDeclination = 0.409 * sin((2 * pi * dayOfYear / 365) - 1.39);
    final double tanProduct = -tan(latitudeRad) * tan(solarDeclination);
    final double cosSunsetAngle = tanProduct.clamp(-1.0, 1.0);
    final double sunsetHourAngle = acos(cosSunsetAngle);
    final double relativeDistance = 1 + 0.033 * cos(2 * pi * dayOfYear / 365);
    const double solarConstant = 0.0820;
    
    return (24 * 60 / pi) * solarConstant * relativeDistance * (sunsetHourAngle * sin(latitudeRad) * sin(solarDeclination) + 
        cos(latitudeRad) * cos(solarDeclination) * sin(sunsetHourAngle));
  }

  static double calculateHargreavesSamani({
    required double tMin,
    required double tMax,
    required double latitude,
    required int dayOfYear,
  }) {
    final double tMean = (tMax + tMin) / 2;
    final double tRange = tMax - tMin;
    if (tRange <= 0) return 0.0;
    
    final double ra = calculateExtraterrestrialRadiation(latitude, dayOfYear);
    return 0.0023 * 0.408 * ra * (tMean + 17.8) * sqrt(tRange);
  }
}

/// Tela do ETo com Mapa e Cálculos Reais
class ETOPage extends StatefulWidget {
  const ETOPage({super.key});

  @override
  State<ETOPage> createState() => _ETOPageState();
}

class _ETOPageState extends State<ETOPage> {
  final _tMinController = TextEditingController();
  final _tMaxController = TextEditingController();
  final _dayController = TextEditingController();
  
  double _latitude = -3.717; // Ponto inicial (Ex: Ceará)
  double _longitude = -38.543;
  double _resultadoETo = 0.0;

  void _executarCalculo() {
    final double? tMin = double.tryParse(_tMinController.text);
    final double? tMax = double.tryParse(_tMaxController.text);
    final int? day = int.tryParse(_dayController.text);

    if (tMin == null || tMax == null || day == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira valores válidos!')),
      );
      return;
    }

    final resultado = EToCalculator.calculateHargreavesSamani(
      tMin: tMin,
      tMax: tMax,
      latitude: _latitude,
      dayOfYear: day,
    );

    setState(() {
      _resultadoETo = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de ETo Real', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF22C55E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ====== MAPA PARA SELECIONAR LATITUDE ======
            const Text(
              'Clique no mapa para capturar a Latitude:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(_latitude, _longitude),
                    initialZoom: 5.0,
                    onTap: (tapPosition, point) {
                      setState(() {
                        _latitude = point.latitude;
                        _longitude = point.longitude;
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.wastech.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(_latitude, _longitude),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Latitude Selecionada: ${_latitude.toStringAsFixed(4)}',
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // ====== FORMULÁRIO DE ENTRADA ======
            TextField(
              controller: _tMinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Temperatura Mínima (°C)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tMaxController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Temperatura Máxima (°C)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dayController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Dia do Ano (1 a 365)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            // ====== BOTÃO CALCULAR ======
            ElevatedButton(
              onPressed: _executarCalculo,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22C55E), padding: const EdgeInsets.all(16)),
              child: const Text('Calcular ETo', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 20),

            // ====== RESULTADO ======
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Resultado ETo: ${_resultadoETo.toStringAsFixed(2)} mm/dia',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),

            // ====== ATALHOS PARA AS OUTRAS TELAS ======
            const Text('Navegar para outros módulos:', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/etcc'),
                    icon: const Icon(Icons.water_drop),
                    label: const Text('Ir para ETc'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/kc'),
                    icon: const Icon(Icons.grass),
                    label: const Text('Ir para Ko/Kc'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}