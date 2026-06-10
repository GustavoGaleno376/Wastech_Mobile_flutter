import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:google_fonts/google_fonts.dart';
import '../dashboard/app_theme.dart';
import '../services/mock_climate_service.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final _mapController = MapController();
  final _climateService = MockClimateService();

  static const _center = LatLng(-15.7801, -47.9292);
  LatLng? _selectedLocation;
  ClimateData? _climateData;
  bool _loading = false;
  bool _showHistory = false;

  final List<ClimateSearchEntry> _history = [];

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _onMapTap(TapPosition tapPosition, LatLng point) async {
    setState(() {
      _selectedLocation = point;
      _loading = true;
    });

    final data = await _climateService.getClimateData(point.latitude, point.longitude);

    if (!mounted) return;
    setState(() {
      _climateData = data;
      _loading = false;
    });

    _history.insert(
      0,
      ClimateSearchEntry(
        latitude: point.latitude,
        longitude: point.longitude,
        data: data,
        timestamp: DateTime.now(),
      ),
    );

    _showClimateBottomSheet();
  }

  void _goToLocation(double lat, double lon) {
    setState(() {
      _showHistory = false;
      _selectedLocation = LatLng(lat, lon);
    });
    _mapController.move(LatLng(lat, lon), 10);
  }

  void _showClimateBottomSheet() {
    if (_climateData == null || _selectedLocation == null) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ClimatePanel(
        location: _selectedLocation!,
        data: _climateData!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 5,
              minZoom: 3,
              maxZoom: 18,
              onTap: _onMapTap,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.wastech.mobile',
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on,
                          color: AppColors.primary, size: 40),
                    ),
                  ],
                ),
            ],
          ),
        ),
        _buildSearchBar(),
        _buildZoomControls(),
        _buildInfoButton(),
        if (_loading)
          Positioned.fill(
            child: Container(
              color: Colors.black12,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        if (_showHistory)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _showHistory = false),
              child: Container(color: Colors.black26),
            ),
          ),
        if (_showHistory) _buildHistoryPanel(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.search_rounded,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _history.isEmpty
                    ? 'Toque no mapa para ver o clima'
                    : '${_history.length} consulta(s) salva(s)',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (_history.isNotEmpty)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => _showHistory = !_showHistory),
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.history_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                ),
              ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryPanel() {
    return Positioned(
      top: 72,
      left: 16,
      right: 16,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 320),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.history_rounded,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Histórico de Consultas',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() {
                      _history.clear();
                      _showHistory = false;
                    }),
                    child: Text(
                      'Limpar',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: _history.length,
                separatorBuilder: (_, _) => Divider(
                    height: 1, indent: 16, endIndent: 16,
                    color: AppColors.border),
                itemBuilder: (context, index) {
                  final entry = _history[index];
                  final isToday = DateTime.now().difference(entry.timestamp).inDays == 0;
                  final timeStr = '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';
                  return InkWell(
                    onTap: () => _goToLocation(entry.latitude, entry.longitude),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.location_on,
                                color: AppColors.primary, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.label,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(Icons.thermostat_rounded,
                                        size: 12, color: AppColors.orange),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${entry.data.temperature}°C',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.water_drop_rounded,
                                        size: 12, color: AppColors.blue),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${entry.data.humidity}%',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            isToday ? timeStr : '${entry.timestamp.day}/${entry.timestamp.month}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      right: 16,
      bottom: 52,
      child: Container(
        width: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _MapButton(
              icon: Icons.add_rounded,
              onTap: () => _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom + 1,
              ),
            ),
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.grey.withValues(alpha: 0.2),
            ),
            _MapButton(
              icon: Icons.remove_rounded,
              onTap: () => _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoButton() {
    return Positioned(
      right: 16,
      bottom: 110,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _mapController.move(_center, 5),
            child: const Icon(Icons.my_location_rounded,
                color: AppColors.primary, size: 20),
          ),
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
            bottom: Radius.circular(12),
          ),
          onTap: onTap,
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
      ),
    );
  }
}

class _ClimatePanel extends StatelessWidget {
  final LatLng location;
  final ClimateData data;

  const _ClimatePanel({required this.location, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _ClimateTile(
                icon: Icons.thermostat_rounded,
                label: 'Temperatura',
                value: '${data.temperature}°C',
                color: AppColors.orange,
                bgColor: AppColors.orangeLight,
              ),
              const SizedBox(width: 12),
              _ClimateTile(
                icon: Icons.water_drop_rounded,
                label: 'Umidade',
                value: '${data.humidity}%',
                color: AppColors.blue,
                bgColor: AppColors.blueLight,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ClimateTile(
                icon: Icons.air_rounded,
                label: 'Vento',
                value: '${data.windSpeed} km/h',
                color: AppColors.purple,
                bgColor: AppColors.purpleLight,
              ),
              const SizedBox(width: 12),
              _ClimateTile(
                icon: Icons.water_rounded,
                label: 'Precipitação',
                value: '${data.precipitation} mm',
                color: AppColors.primary,
                bgColor: AppColors.greenLight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClimateTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  const _ClimateTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
