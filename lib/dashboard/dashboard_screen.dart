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
import '../helpers/snackbar_helper.dart';
import 'plant_service.dart';

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
    final loggedOut = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.logout_rounded, color: AppColors.red, size: 24),
              const SizedBox(width: 10),
              const Text('Sair da Conta'),
            ],
          ),
          content: const Text('Tem certeza que deseja sair? Você precisará fazer login novamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar', style: TextStyle(color: AppColors.textSecondary)),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.red),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (loggedOut == true) {
      await FirebaseAuth.instance.signOut();
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
              child: Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 18),
            ),
          ),
          title: const Text('Fire Watch'),
          actions: [
            _logoutAction(),
            _buildNotificationBadge('3'),
            const SizedBox(width: 4),
          ],
        );
      default:
        return AppBar(
          leading: const Padding(
            padding: EdgeInsets.only(left: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              child: Text(
                'D',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
          title: const Text('Wastech'),
          actions: [
            _logoutAction(),
            _buildNotificationBadge('1'),
            const SizedBox(width: 4),
          ],
        );
    }
  }

  Widget _buildNotificationBadge(String count) {
    return Stack(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
            child: Text(
              count,
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        const SingleChildScrollView(
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
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: MapaScreen(),
        ),
        const FerramentasScreen(),
        const FireHomeScreen(),
      ],
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    final name = FirebaseAuth.instance.currentUser?.displayName ?? 'Agricultor';

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

// --- SEÇÃO INTERATIVA CONFIGURADA COM O SERVIÇO (CRUD) ---
class _PlantsSection extends StatefulWidget {
  const _PlantsSection();

  @override
  State<_PlantsSection> createState() => _PlantsSectionState();
}

class _PlantsSectionState extends State<_PlantsSection> {
  final PlantService _plantService = PlantService();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();

  List<Planta> _plantas = [];
  bool _isLoading = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarPlantas();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tipoController.dispose();
    super.dispose();
  }

  Future<void> _carregarPlantas({bool isSilent = false}) async {
    if (!isSilent) {
      setState(() {
        _isLoading = true;
        _erro = null;
      });
    }

    try {
      final plantas = await _plantService.obterPlantas();
      if (mounted) {
        setState(() {
          _plantas = plantas;
          _isLoading = false;
          _erro = _plantas.isEmpty ? _erro : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (!isSilent || _plantas.isEmpty) {
            _erro = '$e';
          }
        });
      }
    }
  }

  Future<void> _salvarPlanta({Planta? plantaExistente}) async {
    if (_nomeController.text.trim().isEmpty) return;

    final nome = _nomeController.text;
    final tipo = _tipoController.text.isEmpty ? 'Geral' : _tipoController.text;

    try {
      if (plantaExistente == null) {
        final docId = await _plantService.adicionarPlanta(nome, tipo);
        if (mounted) {
          setState(() {
            _plantas.add(Planta(id: docId, nome: nome, tipo: tipo));
            _erro = null;
          });
          context.showSuccessSnackbar('Planta adicionada com sucesso!');
          Navigator.pop(context);
          _carregarPlantas(isSilent: true);
        }
      } else {
        await _plantService.editarPlanta(plantaExistente.id, nome, tipo);
        if (mounted) {
          setState(() {
            final i = _plantas.indexWhere((p) => p.id == plantaExistente.id);
            if (i != -1) {
              _plantas[i] = Planta(id: plantaExistente.id, nome: nome, tipo: tipo);
            }
            _erro = null;
          });
          context.showSuccessSnackbar('Planta atualizada com sucesso!');
          Navigator.pop(context);
          _carregarPlantas(isSilent: true);
        }
      }
    } catch (e) {
      if (mounted) context.showErrorSnackbar('Erro ao salvar: $e');
    }
  }

  void _abrirFormularioPlanta({Planta? plantaExistente}) {
    _nomeController.text = plantaExistente?.nome ?? '';
    _tipoController.text = plantaExistente?.tipo ?? '';

    showDialog(
      context: context,
      builder: (ctx) {
        var isSaving = false;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(plantaExistente == null ? 'Adicionar Nova Planta' : 'Editar Planta'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nomeController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Nome da Planta',
                      hintText: 'Ex: Café',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tipoController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Tipo / Categoria',
                      hintText: 'Ex: Perene',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (_nomeController.text.trim().isEmpty) return;
                          setDialogState(() => isSaving = true);
                          await _salvarPlanta(plantaExistente: plantaExistente);
                        },
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _removerPlanta(Planta planta) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remover Planta'),
        content: Text('Tem certeza que deseja remover "${planta.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmado != true) return;

    try {
      await _plantService.removerPlanta(planta.id);
      if (mounted) {
        setState(() {
          _plantas.removeWhere((p) => p.id == planta.id);
        });
        context.showSuccessSnackbar('Planta removida com sucesso!');
        _carregarPlantas(isSilent: true);
      }
    } catch (e) {
      if (mounted) context.showErrorSnackbar('Erro ao remover: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget(title: 'Minhas Plantas'),
        const SizedBox(height: 8),

        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else if (_erro != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.redLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Erro ao carregar plantas: $_erro',
              style: TextStyle(color: AppColors.red, fontSize: 13),
            ),
          )
        else if (_plantas.isEmpty)
          PlantCardWidget(
            showEmptyState: true,
            onAdd: () => _abrirFormularioPlanta(),
          )
        else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _plantas.length,
            itemBuilder: (context, index) {
              final planta = _plantas[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.greenLight,
                    child: Icon(Icons.eco_rounded, color: AppColors.primary),
                  ),
                  title: Text(planta.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(planta.tipo),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                        onPressed: () => _abrirFormularioPlanta(plantaExistente: planta),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.red),
                        onPressed: () => _removerPlanta(planta),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          PlantCardWidget(
            showEmptyState: false,
            onAdd: () => _abrirFormularioPlanta(),
          ),
        ],
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(
          title: 'Monitoramento de Incêndios',
          icon: Icons.local_fire_department_rounded,
          iconColor: AppColors.red,
        ),
        FireHeroCard(),
        SizedBox(height: 12),
        FireMonitoringCard(
          icon: Icons.notifications_active_rounded,
          title: 'Alertas',
          subtitle: '2 alertas ativos na sua região',
          accentColor: AppColors.red,
          bgColor: AppColors.redLight,
          riskValue: 0.72,
        ),
        SizedBox(height: 12),
        FireMonitoringCard(
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