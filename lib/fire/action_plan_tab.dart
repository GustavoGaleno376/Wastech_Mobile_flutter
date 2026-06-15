import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dashboard/app_theme.dart';
import 'widgets/contact_card_widget.dart';

class ActionPlanTab extends StatefulWidget {
  const ActionPlanTab({super.key});

  @override
  State<ActionPlanTab> createState() => _ActionPlanTabState();
}

class _ActionPlanTabState extends State<ActionPlanTab> {
  final Map<int, bool> _checklist = {
    0: false,
    1: false,
    2: false,
    3: false,
    4: false,
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFB91C1C).withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFB91C1C).withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFB91C1C).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_rounded,
                    color: Color(0xFFB91C1C), size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plano de Emergência Ativo',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB91C1C),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Siga os passos abaixo para garantir a segurança da sua equipe e propriedade.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFFB91C1C).withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Contatos Rápidos',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const ContactCardWidget(
          name: 'Corpo de Bombeiros',
          role: 'Emergência - 193',
          phone: '193',
          color: Color(0xFFB91C1C),
          bgColor: Color(0xFFFFEBEE),
        ),
        const SizedBox(height: 10),
        const ContactCardWidget(
          name: 'Defesa Civil',
          role: 'Monitoramento e alertas',
          phone: '199',
          color: Color(0xFFF59E0B),
          bgColor: Color(0xFFFFF8E1),
        ),
        const SizedBox(height: 10),
        const ContactCardWidget(
          name: 'Administrador da Fazenda',
          role: 'João Silva - Responsável técnico',
          phone: '(11) 99999-8888',
          color: AppColors.primary,
          bgColor: AppColors.greenLight,
        ),
        const SizedBox(height: 24),
        Text(
          'Contenção Inicial',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildCheckItem(
                index: 0,
                title: 'Isolar a área de risco',
                subtitle: 'Sinalizar e restringir acesso à zona de perigo',
              ),
              Divider(
                  height: 1,
                  indent: 56,
                  color: AppColors.border.withValues(alpha: 0.5)),
              _buildCheckItem(
                index: 1,
                title: 'Acionar bombeiros',
                subtitle: 'Ligar para 193 e informar coordenadas exatas',
              ),
              Divider(
                  height: 1,
                  indent: 56,
                  color: AppColors.border.withValues(alpha: 0.5)),
              _buildCheckItem(
                index: 2,
                title: 'Evacuar funcionários',
                subtitle: 'Direcionar equipe para ponto de encontro seguro',
              ),
              Divider(
                  height: 1,
                  indent: 56,
                  color: AppColors.border.withValues(alpha: 0.5)),
              _buildCheckItem(
                index: 3,
                title: 'Ativar sprinklers',
                subtitle: 'Ligar sistema de irrigação de emergência',
              ),
              Divider(
                  height: 1,
                  indent: 56,
                  color: AppColors.border.withValues(alpha: 0.5)),
              _buildCheckItem(
                index: 4,
                title: 'Monitorar ventos',
                subtitle: 'Verificar direção e velocidade do vento',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Rotas de Fuga',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2D6A4F).withValues(alpha: 0.9),
                  const Color(0xFF1B4332).withValues(alpha: 0.95),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                CustomPaint(
                  painter: _RouteMapPainter(),
                  size: const Size(double.infinity, 160),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.navigation_rounded,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '3 rotas disponíveis',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: _buildLegend(
                      Icons.location_on_rounded, 'Ponto de Encontro'),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: _buildLegend(
                      Icons.flag_rounded, 'Saída Segura'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem({
    required int index,
    required String title,
    required String subtitle,
  }) {
    return CheckboxListTile(
      value: _checklist[index],
      onChanged: (value) => setState(() => _checklist[index] = value!),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          decoration:
              _checklist[index]! ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      activeColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
      controlAffinity: ListTileControlAffinity.leading,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildLegend(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _RouteMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paths = [
      [
        Offset(size.width * 0.15, size.height * 0.85),
        Offset(size.width * 0.3, size.height * 0.6),
        Offset(size.width * 0.5, size.height * 0.4),
        Offset(size.width * 0.75, size.height * 0.25),
      ],
      [
        Offset(size.width * 0.15, size.height * 0.85),
        Offset(size.width * 0.25, size.height * 0.75),
        Offset(size.width * 0.55, size.height * 0.65),
        Offset(size.width * 0.8, size.height * 0.45),
      ],
      [
        Offset(size.width * 0.15, size.height * 0.85),
        Offset(size.width * 0.35, size.height * 0.8),
        Offset(size.width * 0.6, size.height * 0.75),
        Offset(size.width * 0.85, size.height * 0.6),
      ],
    ];

    final colors = [
      Colors.white.withValues(alpha: 0.7),
      Colors.white.withValues(alpha: 0.4),
      Colors.white.withValues(alpha: 0.25),
    ];

    for (int i = 0; i < paths.length; i++) {
      final path = Path();
      path.moveTo(paths[i][0].dx, paths[i][0].dy);
      for (int j = 1; j < paths[i].length; j++) {
        final mid = Offset(
          (paths[i][j - 1].dx + paths[i][j].dx) / 2,
          (paths[i][j - 1].dy + paths[i][j].dy) / 2,
        );
        path.quadraticBezierTo(
          paths[i][j - 1].dx, paths[i][j - 1].dy,
          mid.dx, mid.dy,
        );
      }

      final paint = Paint()
        ..color = colors[i]
        ..strokeWidth = 3 - i * 0.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, paint);

      canvas.drawCircle(
        paths[i].last,
        5 - i.toDouble(),
        Paint()..color = Colors.white.withValues(alpha: 0.9 - i * 0.2),
      );
    }

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.85),
      8,
      Paint()..color = const Color(0xFFB91C1C),
    );
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.85),
      8,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
