import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dashboard/app_theme.dart';

class HeatmapTab extends StatelessWidget {
  const HeatmapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox.expand(
            child: CustomPaint(
              painter: _TerrainPainter(),
              foregroundPainter: _HeatmapPainter(),
            ),
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
                color: AppColors.textSecondary.withValues(alpha: 0.7), size: 20),
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
            _MapButton(icon: Icons.add_rounded),
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.grey.withValues(alpha: 0.2),
            ),
            _MapButton(icon: Icons.remove_rounded),
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
            onTap: () {},
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
        child: Icon(Icons.north_rounded,
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

  const _MapButton({required this.icon});

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
          onTap: () {},
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
      ),
    );
  }
}

class _TerrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final terrainRect = Rect.fromLTWH(0, 0, size.width, size.height);

    final basePaint = Paint()
      ..shader = LinearGradient(
        colors: const [
          Color(0xFF2D5016),
          Color(0xFF3D6B24),
          Color(0xFF5A8F3C),
          Color(0xFF6BA34E),
          Color(0xFF7BB860),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(terrainRect);
    canvas.drawRect(terrainRect, basePaint);

    final riverPath = Path();
    riverPath.moveTo(size.width * 0.72, 0);
    riverPath.quadraticBezierTo(
        size.width * 0.75, size.height * 0.15,
        size.width * 0.70, size.height * 0.15);
    riverPath.quadraticBezierTo(
        size.width * 0.65, size.height * 0.15,
        size.width * 0.62, size.height * 0.25);
    riverPath.quadraticBezierTo(
        size.width * 0.58, size.height * 0.35,
        size.width * 0.60, size.height * 0.40);
    riverPath.quadraticBezierTo(
        size.width * 0.62, size.height * 0.48,
        size.width * 0.58, size.height * 0.55);
    riverPath.quadraticBezierTo(
        size.width * 0.54, size.height * 0.62,
        size.width * 0.56, size.height * 0.70);
    riverPath.quadraticBezierTo(
        size.width * 0.58, size.height * 0.80,
        size.width * 0.55, size.height * 0.85);
    riverPath.quadraticBezierTo(
        size.width * 0.52, size.height * 0.92,
        size.width * 0.53, size.height);

    final riverPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF2C7A9E).withValues(alpha: 0.5),
          const Color(0xFF4A9FC7).withValues(alpha: 0.4),
          const Color(0xFF2C7A9E).withValues(alpha: 0.5),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(terrainRect);
    canvas.drawPath(riverPath, riverPaint..style = PaintingStyle.fill);

    canvas.drawPath(riverPath, riverPaint..style = PaintingStyle.stroke..strokeWidth = 6);
    canvas.drawPath(riverPath, riverPaint..style = PaintingStyle.fill);

    // Fields / crop areas
    final random = Random(42);
    final fieldPaint = Paint()
      ..color = const Color(0xFF4A7C2E).withValues(alpha: 0.3);
    for (int i = 0; i < 8; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final w = 20 + random.nextDouble() * 60;
      final h = 20 + random.nextDouble() * 40;
      final angle = random.nextDouble() * pi / 4;

      if (x + w < size.width * 0.6 && y + h < size.height * 0.8) {
        canvas.save();
        canvas.translate(x + w / 2, y + h / 2);
        canvas.rotate(angle);
        canvas.drawRect(
          Rect.fromLTWH(-w / 2, -h / 2, w, h),
          fieldPaint..color = Color.fromRGBO(
            74 + random.nextInt(40),
            124 + random.nextInt(40),
            46 + random.nextInt(20),
            0.25 + random.nextDouble() * 0.15,
          ),
        );
        canvas.restore();
      }
    }

    // Roads
    final roadPaint = Paint()
      ..color = const Color(0xFF8B7355).withValues(alpha: 0.4)
      ..strokeWidth = 3;
    final roadPaint2 = Paint()
      ..color = const Color(0xFFD4A76A).withValues(alpha: 0.3)
      ..strokeWidth = 1.5;

    // Main road horizontal
    canvas.drawLine(
      Offset(0, size.height * 0.45),
      Offset(size.width * 0.65, size.height * 0.42),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.45),
      Offset(size.width * 0.65, size.height * 0.42),
      roadPaint2,
    );

    // Main road vertical
    canvas.drawLine(
      Offset(size.width * 0.35, 0),
      Offset(size.width * 0.38, size.height * 0.8),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.35, 0),
      Offset(size.width * 0.38, size.height * 0.8),
      roadPaint2,
    );

    // Secondary roads
    final secondaryPaint = Paint()
      ..color = const Color(0xFF8B7355).withValues(alpha: 0.25)
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.65),
      secondaryPaint,
    );

    // Water reservoir / lake
    final lakePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF4A9FC7).withValues(alpha: 0.4),
          const Color(0xFF2C7A9E).withValues(alpha: 0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.2, size.height * 0.2),
        radius: 40,
      ));
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.2),
      35,
      lakePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeatmapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Heat spots
    final heatSpots = [
      _HeatSpot(Offset(size.width * 0.32, size.height * 0.38), 0.95, 55),
      _HeatSpot(Offset(size.width * 0.55, size.height * 0.32), 0.80, 45),
      _HeatSpot(Offset(size.width * 0.72, size.height * 0.52), 0.70, 50),
      _HeatSpot(Offset(size.width * 0.42, size.height * 0.58), 0.55, 40),
      _HeatSpot(Offset(size.width * 0.62, size.height * 0.68), 0.45, 35),
    ];

    for (final spot in heatSpots) {
      for (int i = 4; i >= 0; i--) {
        final radius = spot.baseRadius + (4 - i) * 25.0;
        final opacity = spot.intensity * (0.25 - (4 - i) * 0.045);

        final paint = Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFFFD93D).withValues(alpha: opacity * 0.3),
              const Color(0xFFFF6B35).withValues(alpha: opacity * 0.6),
              const Color(0xFFB91C1C).withValues(alpha: opacity * 0.8),
              Colors.transparent,
            ],
            stops: const [0.0, 0.25, 0.55, 1.0],
          ).createShader(Rect.fromCircle(center: spot.center, radius: radius))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

        canvas.drawCircle(spot.center, radius, paint);
      }
    }

    // Fire marker pins
    final pinPositions = [
      Offset(size.width * 0.32, size.height * 0.38),
      Offset(size.width * 0.55, size.height * 0.32),
      Offset(size.width * 0.72, size.height * 0.52),
    ];

    for (final pos in pinPositions) {
      _drawFirePin(canvas, pos, size);
    }

    // Grid overlay
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawFirePin(Canvas canvas, Offset pos, Size size) {
    final pinPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFB91C1C), Color(0xFFFF6B35)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: pos, radius: 12));

    final path = Path();
    path.moveTo(pos.dx, pos.dy - 14);
    path.quadraticBezierTo(
      pos.dx + 12, pos.dy - 4,
      pos.dx, pos.dy + 6,
    );
    path.quadraticBezierTo(
      pos.dx - 12, pos.dy - 4,
      pos.dx, pos.dy - 14,
    );
    canvas.drawPath(path, pinPaint);

    // White center dot
    canvas.drawCircle(
      pos - Offset(0, 2),
      3,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );

    // Glow
    canvas.drawCircle(
      pos,
      18,
      Paint()
        ..color = const Color(0xFFB91C1C).withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(center: pos + Offset(0, 10), width: 16, height: 4),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeatSpot {
  final Offset center;
  final double intensity;
  final double baseRadius;

  _HeatSpot(this.center, this.intensity, this.baseRadius);
}
