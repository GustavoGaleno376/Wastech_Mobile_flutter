import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dashboard/app_theme.dart';
import 'heatmap_tab.dart';
import 'alert_center_tab.dart';
import 'charts_tab.dart';
import 'action_plan_tab.dart';

class FireHomeScreen extends StatelessWidget {
  const FireHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFFB91C1C).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFB91C1C).withValues(alpha: 0.1),
                ),
              ),
              child: TabBar(
                isScrollable: false,
                labelPadding: EdgeInsets.zero,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                dividerColor: Colors.transparent,
                labelColor: const Color(0xFFB91C1C),
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                tabs: [
                  Tab(
                    child: _TabContent(
                      icon: Icons.map_rounded,
                      label: 'Mapa',
                      isSelected: false,
                    ),
                  ),
                  Tab(
                    child: _TabContent(
                      icon: Icons.notifications_rounded,
                      label: 'Alertas',
                      isSelected: false,
                    ),
                  ),
                  Tab(
                    child: _TabContent(
                      icon: Icons.bar_chart_rounded,
                      label: 'Gráficos',
                      isSelected: false,
                    ),
                  ),
                  Tab(
                    child: _TabContent(
                      icon: Icons.assignment_rounded,
                      label: 'Ação',
                      isSelected: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TabBarView(
                children: [
                  HeatmapTab(),
                  AlertCenterTab(),
                  ChartsTab(),
                  ActionPlanTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _TabContent({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}
