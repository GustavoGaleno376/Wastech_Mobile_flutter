import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

class PlantCardWidget extends StatelessWidget {
  final VoidCallback? onAdd;
  final bool showEmptyState;

  const PlantCardWidget({super.key, this.onAdd, this.showEmptyState = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: showEmptyState ? 36 : 20,
          horizontal: 24,
        ),
        child: Column(
          children: [
            if (showEmptyState) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.yard_rounded,
                  size: 44,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Nenhuma planta cadastrada',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Adicione sua primeira planta para\ncomeçar o monitoramento',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
            SizedBox(
              width: showEmptyState ? 220 : double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(
                  'Adicionar Planta',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
