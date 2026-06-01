import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../dashboard/app_theme.dart';
import 'widgets/metric_card_widget.dart';

class FirmsTab extends StatelessWidget {
  const FirmsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      children: [
        _buildChartCard(),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(
              child: MetricCardWidget(
                icon: Icons.map_rounded,
                label: 'Área em Risco',
                value: '12,4',
                unit: 'km²',
                color: Color(0xFFB91C1C),
                bgColor: Color(0xFFFFEBEE),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: MetricCardWidget(
                icon: Icons.verified_rounded,
                label: 'Confiança de Detecção',
                value: '87',
                unit: '%',
                color: AppColors.primary,
                bgColor: Color(0xFFE8F5E9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: MetricCardWidget(
                icon: Icons.thermostat_rounded,
                label: 'Temperatura',
                value: '34',
                unit: '°C',
                color: AppColors.orange,
                bgColor: Color(0xFFFFF3E0),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: MetricCardWidget(
                icon: Icons.water_drop_rounded,
                label: 'Umidade',
                value: '28',
                unit: '%',
                color: AppColors.blue,
                bgColor: Color(0xFFE3F2FD),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: MetricCardWidget(
                icon: Icons.air_rounded,
                label: 'Vento',
                value: '18',
                unit: 'km/h',
                color: Color(0xFF7B61FF),
                bgColor: Color(0xFFEDE7F6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildNasaSourceCard(),
      ],
    );
  }

  Widget _buildChartCard() {
    return Card(
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Tendência de Focos (7 dias)',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withValues(alpha: 0.12),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final days = [
                            'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'
                          ];
                          final index = value.toInt();
                          if (index >= 0 && index < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                days[index],
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  maxY: 30,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 12),
                        FlSpot(1, 18),
                        FlSpot(2, 15),
                        FlSpot(3, 22),
                        FlSpot(4, 28),
                        FlSpot(5, 20),
                        FlSpot(6, 24),
                      ],
                      isCurved: true,
                      color: const Color(0xFFB91C1C),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2.5,
                          strokeColor: const Color(0xFFB91C1C),
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFFB91C1C).withValues(alpha: 0.08),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) => touchedSpots.map(
                        (spot) => LineTooltipItem(
                          '${spot.y.toInt()} focos',
                          GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNasaSourceCard() {
    return Card(
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.satellite_alt_rounded,
                  color: Color(0xFF1A237E), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fonte: FIRMS (NASA)',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Dados atualizados há 15 minutos',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.greenLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.primary, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Online',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
