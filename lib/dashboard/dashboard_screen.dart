import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_theme.dart';
import 'section_title_widget.dart';
import 'hero_banner_widget.dart';
import 'tool_card_widget.dart';
import 'plant_card_widget.dart';
import 'water_calculator_card.dart';
import 'fire_monitoring_card.dart';
import '../fire/fire_home_screen.dart';
import '../screens/mapa_screen.dart';
import '../screens/ferramentas_screen.dart';
import '../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map_rounded),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            activeIcon: Icon(Icons.build_rounded),
            label: 'Ferramentas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department_outlined),
            activeIcon: Icon(Icons.local_fire_department_rounded),
            label: 'Incêndios',
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.logout_rounded, color: AppColors.red, size: 24),
              const SizedBox(width: 10),
              const Text('Confirmar Saída'),
            ],
          ),
          content: const Text('Tem certeza que deseja sair da sua conta?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      await _authService.logout();
    }
  }

  Widget _logoutAction() {
    return IconButton(
      onPressed: _confirmLogout,
      icon: const Icon(Icons.logout_rounded, color: AppColors.textPrimary),
      tooltip: 'Sair',
    );
  }

  PreferredSizeWidget _buildAppBar() {
    switch (_currentIndex) {
      case 1:
        return AppBar(
          title: const Text('Mapa Climático'),
          centerTitle: true,
          actions: [_logoutAction(), const SizedBox(width: 8)],
        );
      case 2:
        return AppBar(
          title: const Text('Ferramentas'),
          centerTitle: true,
          actions: [_logoutAction(), const SizedBox(width: 8)],
        );
      case 3:
        return AppBar(
          leading: const Padding(
            padding: EdgeInsets.only(left: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFB91C1C),
              child: Icon(Icons.local_fire_department_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          title: const Text('Fire Watch'),
          actions: [
            _logoutAction(),
            Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined,
                      color: AppColors.textPrimary),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB91C1C),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
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
            const SizedBox(width: 4),
          ],
        );
      default:
        return AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              child: Text(
                (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.displayName != null)
                    ? FirebaseAuth.instance.currentUser!.displayName![0].toUpperCase()
                    : '?', // Fallback para '?' se o nome não estiver disponível

                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          title: const Text('Wastech'),
          actions: [
            _logoutAction(),
            Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined,
                      color: AppColors.textPrimary),
                ),
                Positioned(
                  right: 10,
                  top: 10,
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
            const SizedBox(width: 4),
          ],
        );
    }
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 1:
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: MapaScreen(),
        );
      case 2:
        return const FerramentasScreen();
      case 3:
        return const FireHomeScreen();
      default:
        return const SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        );
    }
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName?.split(' ').first ?? 'Usuário';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(
          'Olá, $name',
          style: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Vamos cuidar das suas plantações hoje?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
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
        const SectionTitleWidget(
          title: 'Ferramentas Agrícolas',
          actionLabel: 'Ver todas',
        ),
        const Row(
          children: [
            Expanded(
              child: ToolCardWidget(
                icon: Icons.calendar_month_rounded,
                label: 'Épocas de plantio',
                iconColor: AppColors.primary,
                bgColor: AppColors.greenLight,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ToolCardWidget(
                icon: Icons.cloud_rounded,
                label: 'Previsão do tempo',
                iconColor: AppColors.blue,
                bgColor: AppColors.blueLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ToolCardWidget(
                icon: Icons.calculate_rounded,
                label: 'Irrigação',
                iconColor: AppColors.orange,
                bgColor: AppColors.orangeLight,
                onTap: () => Navigator.pushNamed(context, '/eto'),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: ToolCardWidget(
                icon: Icons.energy_savings_leaf_rounded,
                label: 'Análise do Solo',
                iconColor: AppColors.brown,
                bgColor: AppColors.brownLight,
              ),
            ),
          ],
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
        PlantCardWidget(onAdd: () {}),
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
        Row(
          children: [
            Expanded(
              child: WaterCalculatorCard(
                icon: Icons.water_drop_rounded,
                title: 'ETo',
                subtitle: 'Evapotranspiração',
                color: AppColors.blue,
                bgColor: AppColors.blueLight,
                onTap: () => Navigator.pushNamed(context, '/eto'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WaterCalculatorCard(
                icon: Icons.eco_rounded,
                title: 'ETc',
                subtitle: 'Demanda da planta',
                color: AppColors.primary,
                bgColor: AppColors.greenLight,
                onTap: () => Navigator.pushNamed(context, '/etc'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WaterCalculatorCard(
                icon: Icons.science_rounded,
                title: 'Kc',
                subtitle: 'Coeficientes',
                color: AppColors.purple,
                bgColor: AppColors.purpleLight,
                onTap: () => Navigator.pushNamed(context, '/kc'),
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
        const FireHeroCard(),
        const SizedBox(height: 12),
        const FireMonitoringCard(
          icon: Icons.notifications_active_rounded,
          title: 'Alertas',
          subtitle: '2 alertas ativos na sua região',
          accentColor: AppColors.red,
          bgColor: AppColors.redLight,
          riskValue: 0.72,
        ),
        const SizedBox(height: 12),
        const FireMonitoringCard(
          icon: Icons.satellite_alt_rounded,
          title: 'Dados NASA',
          subtitle: 'Atualizado há 15 minutos',
          accentColor: AppColors.blue,
          bgColor: AppColors.blueLight,
          riskValue: 0.30,
        ),
      ],
    );
  }
}
