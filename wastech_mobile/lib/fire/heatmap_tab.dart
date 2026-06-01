import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import '../dashboard/app_theme.dart';

class HeatmapTab extends StatefulWidget {
  const HeatmapTab({super.key});

  @override
  State<HeatmapTab> createState() => _HeatmapTabState();
}

class _HeatmapTabState extends State<HeatmapTab> {
  final _mapController = MapController();

  static const _center = LatLng(-15.7801, -47.9292);

  final _fireSpots = [
    _FireSpot(LatLng(-15.760, -47.940), 0.95),
    _FireSpot(LatLng(-15.800, -47.915), 0.75),
    _FireSpot(LatLng(-15.770, -47.900), 0.60),
    _FireSpot(LatLng(-15.745, -47.910), 0.50),
    _FireSpot(LatLng(-15.785, -47.955), 0.40),
  ];

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
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
              initialZoom: 13,
              minZoom: 8,
              maxZoom: 18,
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
              CircleLayer(circles: _buildHeatCircles()),
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),
        ),
        _buildSearchBar(),
        _buildZoomControls(),
        _buildLocationButton(),
        _buildLegend(),
        _buildStatusBadge(),
        _buildCompass(),
        _buildScaleBar(),
      ],
    );
  }

  List<CircleMarker> _buildHeatCircles() {
    return _fireSpots.map((spot) {
      final opacity = spot.intensity * 0.35;
      return CircleMarker(
        point: spot.position,
        radius: 80 * spot.intensity + 30,
        color: const Color(0xFFB91C1C).withValues(alpha: opacity * 0.6),
        useRadiusInMeter: false,
        borderColor: const Color(0xFFFF6B35).withValues(alpha: opacity),
        borderStrokeWidth: 2,
      );
    }).toList()
      ..addAll(_fireSpots.map((spot) {
        final opacity = spot.intensity * 0.2;
        return CircleMarker(
          point: spot.position,
          radius: 160 * spot.intensity + 60,
          color: const Color(0xFFFFD93D).withValues(alpha: opacity * 0.3),
          useRadiusInMeter: false,
          borderColor: Colors.transparent,
        );
      }));
  }

  List<Marker> _buildMarkers() {
    return _fireSpots.where((s) => s.intensity > 0.55).map((spot) {
      return Marker(
        point: spot.position,
        width: 36,
        height: 44,
        alignment: Alignment.bottomCenter,
        child: _FirePin(intensity: spot.intensity),
      );
    }).toList();
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
            Text(
              'Buscar localidade...',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFB91C1C).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB91C1C),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'AO VIVO',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB91C1C),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      right: 16,
      bottom: 110,
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

  Widget _buildLocationButton() {
    return Positioned(
      right: 16,
      bottom: 52,
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
            onTap: () => _mapController.move(_center, 13),
            child: const Icon(Icons.my_location_rounded,
                color: AppColors.primary, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Positioned(
      left: 16,
      bottom: 80,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Intensidade',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 100,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD93D),
                    Color(0xFFFF8C42),
                    Color(0xFFB91C1C),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Baixo',
                    style: GoogleFonts.inter(
                        fontSize: 8, color: AppColors.textSecondary)),
                Text('Alto',
                    style: GoogleFonts.inter(
                        fontSize: 8, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Positioned(
      left: 16,
      bottom: 24,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFFD93D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '3 focos ativos',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB91C1C),
                  ),
                ),
                Text(
                  'Raio de 12 km',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompass() {
    return Positioned(
      top: 76,
      right: 16,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Icon(Icons.north_rounded,
            color: AppColors.primary, size: 18),
      ),
    );
  }

  Widget _buildScaleBar() {
    return Positioned(
      bottom: 24,
      right: 72,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '2 km',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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

class _FirePin extends StatelessWidget {
  final double intensity;

  const _FirePin({required this.intensity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomPaint(
          size: const Size(36, 44),
          painter: _PinPainter(intensity: intensity),
        ),
        Positioned(
          top: 4,
          left: 0,
          right: 0,
          child: Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: 14,
          ),
        ),
      ],
    );
  }
}

class _PinPainter extends CustomPainter {
  final double intensity;

  _PinPainter({required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 20);
    final radius = 14.0;

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(center: center + Offset(0, 16), width: 20, height: 5),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Pin body - teardrop shape
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.quadraticBezierTo(
      center.dx + radius + 4, center.dy - 2,
      center.dx, center.dy + radius - 2,
    );
    path.quadraticBezierTo(
      center.dx - radius - 4, center.dy - 2,
      center.dx, center.dy - radius,
    );
    path.close();

    final pinPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFB91C1C),
          const Color(0xFFFF6B35),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius + 4));

    canvas.drawPath(path, pinPaint);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white.withValues(alpha: 0.3),
    );

    // Outer glow
    canvas.drawCircle(
      center,
      radius + 8,
      Paint()
        ..color = const Color(0xFFB91C1C).withValues(alpha: 0.15 * intensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
  }

  @override
  bool shouldRepaint(covariant _PinPainter oldDelegate) =>
      oldDelegate.intensity != intensity;
}

class _FireSpot {
  final LatLng position;
  final double intensity;

  _FireSpot(this.position, this.intensity);
}
