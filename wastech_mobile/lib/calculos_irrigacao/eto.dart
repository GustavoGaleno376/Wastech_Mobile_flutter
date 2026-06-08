import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:google_fonts/google_fonts.dart';
import '../dashboard/app_theme.dart';

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

class ETOPage extends StatefulWidget {
  const ETOPage({super.key});

  @override
  State<ETOPage> createState() => _ETOPageState();
}

class _ETOPageState extends State<ETOPage> {
  final _tMinController = TextEditingController();
  final _tMaxController = TextEditingController();
  final _dayController = TextEditingController();

  double _latitude = -3.717;
  double _longitude = -38.543;
  double _resultadoETo = 0.0;

  void _executarCalculo() {
    final double? tMin = double.tryParse(_tMinController.text);
    final double? tMax = double.tryParse(_tMaxController.text);
    final int? day = int.tryParse(_dayController.text);

    if (tMin == null || tMax == null || day == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira valores válidos!')),
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
  void dispose() {
    _tMinController.dispose();
    _tMaxController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Evapotranspiração (ETo)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selecione a localização no mapa',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 220,
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
                                  child: const Icon(Icons.location_on, color: AppColors.red, size: 40),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: AppColors.red),
                        const SizedBox(width: 6),
                        Text(
                          'Lat: ${_latitude.toStringAsFixed(4)}  Lon: ${_longitude.toStringAsFixed(4)}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dados Climáticos',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tMinController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Temperatura Mínima (°C)',
                        prefixIcon: const Icon(Icons.ac_unit_rounded),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _tMaxController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Temperatura Máxima (°C)',
                        prefixIcon: const Icon(Icons.whatshot_rounded),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _dayController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Dia do Ano (1 a 365)',
                        prefixIcon: const Icon(Icons.calendar_today_rounded),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _executarCalculo,
                      icon: const Icon(Icons.calculate_rounded),
                      label: Text(
                        'Calcular ETo',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_resultadoETo > 0) ...[
              const SizedBox(height: 20),
              Card(
                color: AppColors.greenLight,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.water_drop_rounded, size: 40, color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text(
                        '${_resultadoETo.toStringAsFixed(2)} mm/dia',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Evapotranspiração de Referência',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/etc'),
                      icon: const Icon(Icons.water_drop_rounded),
                      label: const Text('Calcular ETc'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/kc'),
                      icon: const Icon(Icons.grass_rounded),
                      label: const Text('Ver Kc'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
