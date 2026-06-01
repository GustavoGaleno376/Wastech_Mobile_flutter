import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dashboard/app_theme.dart';
import 'widgets/alert_tile_widget.dart';

class AlertCenterTab extends StatelessWidget {
  const AlertCenterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      children: [
        _buildFilterRow(),
        const SizedBox(height: 12),
        const AlertTileWidget(
          title: 'Incêndio próximo à Fazenda Boa Vista',
          description:
              'Foco de incêndio detectado a 2,3 km da sua propriedade. Ventos fortes podem propagar as chamas.',
          time: 'Há 8 minutos',
          status: AlertStatus.danger,
          icon: Icons.local_fire_department_rounded,
          iconColor: Color(0xFFB91C1C),
          iconBg: Color(0xFFFFEBEE),
        ),
        const SizedBox(height: 10),
        const AlertTileWidget(
          title: 'Alerta de Queimada Controlada',
          description:
              'Queimada autorizada detectada na região do Vale Verde. Mantenha distância segura.',
          time: 'Há 34 minutos',
          status: AlertStatus.attention,
          icon: Icons.warning_amber_rounded,
          iconColor: Color(0xFFF59E0B),
          iconBg: Color(0xFFFFF8E1),
        ),
        const SizedBox(height: 10),
        const AlertTileWidget(
          title: 'Risco Elevado nas Próximas Horas',
          description:
              'Condições climáticas indicam aumento do risco de incêndio nas próximas 6 horas. Reforce a vigilância.',
          time: 'Há 1 hora',
          status: AlertStatus.danger,
          icon: Icons.notifications_active_rounded,
          iconColor: Color(0xFFB91C1C),
          iconBg: Color(0xFFFFEBEE),
        ),
        const SizedBox(height: 10),
        const AlertTileWidget(
          title: 'Vistoria de Campo Realizada',
          description:
              'Vistoria na área de risco da Colina do Sol concluída. Nenhuma anormalidade encontrada.',
          time: 'Há 3 horas',
          status: AlertStatus.completed,
          icon: Icons.check_circle_rounded,
          iconColor: Color(0xFF2D6A4F),
          iconBg: Color(0xFFE8F5E9),
        ),
        const SizedBox(height: 10),
        const AlertTileWidget(
          title: 'Monitoramento por Satélite',
          description:
              'Dados FIRMS atualizados. 2 novos focos detectados no raio de 50 km.',
          time: 'Há 4 horas',
          status: AlertStatus.attention,
          icon: Icons.satellite_alt_rounded,
          iconColor: Color(0xFFF59E0B),
          iconBg: Color(0xFFFFF8E1),
        ),
      ],
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: [
        _FilterChip(label: 'Todos', selected: true),
        const SizedBox(width: 8),
        _FilterChip(label: 'Perigo', selected: false),
        const SizedBox(width: 8),
        _FilterChip(label: 'Atenção', selected: false),
        const SizedBox(width: 8),
        _FilterChip(label: 'Concluído', selected: false),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary
            : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : AppColors.primary,
        ),
      ),
    );
  }
}
