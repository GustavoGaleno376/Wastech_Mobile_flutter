import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/section_title_widget.dart';
import '../widgets/hero_banner_widget.dart';
import '../widgets/tool_card_widget.dart';
import '../widgets/plant_card_widget.dart';
import '../widgets/water_calculator_card.dart';
import '../widgets/fire_monitoring_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            _GreetingSection(),
            SizedBox(height: 20),
            HeroBannerWidget(),
            SizedBox(height: 28),
            _ToolsSection(),
            SizedBox(height: 28),
            _PlantsSection(),
            SizedBox(height: 28),
            _WaterCalculatorsSection(),
            SizedBox(height: 28),
            _FireMonitoringSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Row(
        children: [
          Text(
            'Wastech',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined,
                  color: AppColors.textPrimary),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(right: 4),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              'G',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Início'),
        BottomNavigationBarItem(
            icon: Icon(Icons.build_rounded), label: 'Ferramentas'),
        BottomNavigationBarItem(
            icon: Icon(Icons.yard_rounded), label: 'Plantas'),
        BottomNavigationBarItem(
            icon: Icon(Icons.water_drop_rounded), label: 'Irrigação'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded), label: 'Perfil'),
      ],
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Olá, Gustavo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Vamos cuidar das suas plantações hoje?',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _ToolsSection extends StatelessWidget {
  const _ToolsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(title: 'Ferramentas Agrícolas'),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ToolCardWidget(
                icon: Icons.calendar_month_rounded,
                label: 'Épocas de plantio',
                iconColor: AppColors.primary,
              ),
              const SizedBox(width: 12),
              ToolCardWidget(
                icon: Icons.cloud_rounded,
                label: 'Previsão do tempo',
                iconColor: AppColors.blue,
              ),
              const SizedBox(width: 12),
              ToolCardWidget(
                icon: Icons.calculate_rounded,
                label: 'Irrigação',
                iconColor: AppColors.orange,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Acessar Todas as Ferramentas',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlantsSection extends StatelessWidget {
  const _PlantsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(title: 'Minhas Plantas'),
        PlantCardWidget(
          onAdd: () {},
        ),
      ],
    );
  }
}

class _WaterCalculatorsSection extends StatelessWidget {
  const _WaterCalculatorsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(title: 'Calculadoras de Água'),
        const Row(
          children: [
            Expanded(
              child: WaterCalculatorCard(
                icon: Icons.water_drop_rounded,
                title: 'ETo',
                subtitle: 'Evapotranspiração',
                color: AppColors.blue,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: WaterCalculatorCard(
                icon: Icons.eco_rounded,
                title: 'ETc',
                subtitle: 'Demanda da planta',
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: WaterCalculatorCard(
                icon: Icons.science_rounded,
                title: 'Kc',
                subtitle: 'Coeficientes',
                color: AppColors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FireMonitoringSection extends StatelessWidget {
  const _FireMonitoringSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(
          title: 'Monitoramento de Incêndios',
          icon: Icons.local_fire_department_rounded,
          iconColor: AppColors.red,
        ),
        const FireMonitoringCard(
          icon: Icons.map_rounded,
          title: 'Mapa de Calor',
          subtitle: 'Risco em tempo real',
          accentColor: AppColors.orange,
        ),
        const SizedBox(height: 10),
        const FireMonitoringCard(
          icon: Icons.notifications_active_rounded,
          title: 'Alertas',
          subtitle: 'Notificações de proximidade',
          accentColor: AppColors.red,
        ),
        const SizedBox(height: 10),
        const FireMonitoringCard(
          icon: Icons.satellite_alt_rounded,
          title: 'Dados NASA',
          subtitle: 'Informações de satélite',
          accentColor: AppColors.blue,
        ),
      ],
    );
  }
}
