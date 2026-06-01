import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dashboard/app_theme.dart';
import 'heatmap_tab.dart';
import 'alert_center_tab.dart';
import 'firms_tab.dart';
import 'action_plan_tab.dart';

class FireHomeScreen extends StatelessWidget {
  const FireHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFB91C1C).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              isScrollable: false,
              labelPadding: EdgeInsets.zero,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              labelColor: const Color(0xFFB91C1C),
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
              tabs: const [
                Tab(text: 'Mapa'),
                Tab(text: 'Alertas'),
                Tab(text: 'FIRMS'),
                Tab(text: 'Ação'),
              ],
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TabBarView(
                children: [
                  HeatmapTab(),
                  AlertCenterTab(),
                  FirmsTab(),
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
