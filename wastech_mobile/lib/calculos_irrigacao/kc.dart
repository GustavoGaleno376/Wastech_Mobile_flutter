import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dashboard/app_theme.dart';

class KcValores {
  final double fase1;
  final double fase2;
  final double fase3;
  final double fase4;

  KcValores({
    required this.fase1,
    required this.fase2,
    required this.fase3,
    required this.fase4,
  });
}

class Cultura {
  final String nome;
  final int duracao;
  final String fases;
  final KcValores kcValores;

  Cultura({
    required this.nome,
    required this.duracao,
    required this.fases,
    required this.kcValores,
  });
}

class KcPage extends StatelessWidget {
  KcPage({super.key});

  final List<Cultura> listaCulturas = [
    Cultura(
      nome: "Milho",
      duracao: 110,
      fases: "20-35-40-15",
      kcValores: KcValores(fase1: 0.3, fase2: 0.7, fase3: 1.2, fase4: 0.6),
    ),
    Cultura(
      nome: "Tomate",
      duracao: 135,
      fases: "30-40-45-20",
      kcValores: KcValores(fase1: 0.6, fase2: 0.9, fase3: 1.15, fase4: 0.8),
    ),
    Cultura(
      nome: "Melancia",
      duracao: 85,
      fases: "10-20-30-25",
      kcValores: KcValores(fase1: 0.4, fase2: 0.7, fase3: 1.0, fase4: 0.6),
    ),
  ];

  double _calcularMediaKc(Cultura cultura) {
    List<int> fasesDias = cultura.fases.split("-").map(int.parse).toList();
    List<double> valores = [
      cultura.kcValores.fase1,
      cultura.kcValores.fase2,
      cultura.kcValores.fase3,
      cultura.kcValores.fase4
    ];

    double somaPonderada = 0;
    int totalDias = 0;

    for (int i = 0; i < fasesDias.length; i++) {
      somaPonderada += fasesDias[i] * valores[i];
      totalDias += fasesDias[i];
    }

    return totalDias > 0 ? double.parse((somaPonderada / totalDias).toStringAsFixed(2)) : 0.0;
  }

  Color _getCorConsumo(double kcMedia) {
    if (kcMedia < 0.7) return const Color(0xFFDCFCE7);
    if (kcMedia < 1.0) return const Color(0xFFBBF7D0);
    return const Color(0xFF86EFAC);
  }

  @override
  Widget build(BuildContext context) {
    Cultura minCultura = listaCulturas.reduce((min, curr) => _calcularMediaKc(curr) < _calcularMediaKc(min) ? curr : min);
    Cultura maxCultura = listaCulturas.reduce((max, curr) => _calcularMediaKc(curr) > _calcularMediaKc(max) ? curr : max);
    double somaTotalMedias = listaCulturas.fold(0.0, (soma, curr) => soma + _calcularMediaKc(curr));
    String mediaGeral = (somaTotalMedias / listaCulturas.length).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Coeficientes de Cultura (Kc)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Valores de Kc para diferentes culturas e fases de crescimento',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppColors.primary),
                    columns: const [
                      DataColumn(label: Text('Cultura',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Dias',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Inicial',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Desenv.',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Meio',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Final',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Médio',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ],
                    rows: listaCulturas.map((cultura) {
                      final double kcMedia = _calcularMediaKc(cultura);
                      return DataRow(cells: [
                        DataCell(Text(cultura.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(cultura.duracao.toString())),
                        DataCell(Text(cultura.kcValores.fase1.toString())),
                        DataCell(Text(cultura.kcValores.fase2.toString())),
                        DataCell(Text(cultura.kcValores.fase3.toString())),
                        DataCell(Text(cultura.kcValores.fase4.toString())),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getCorConsumo(kcMedia),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              kcMedia.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF166534),
                              ),
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Como interpretar o Kc Médio?',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: [
                        _legendaItem(const Color(0xFFDCFCE7), 'Baixo consumo (< 0.7)'),
                        _legendaItem(const Color(0xFFBBF7D0), 'Consumo moderado (0.7 - 1.0)'),
                        _legendaItem(const Color(0xFF86EFAC), 'Alto consumo (> 1.0)'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: _summaryCard('Menor Kc', '${minCultura.nome}: ${_calcularMediaKc(minCultura)}')),
                        const SizedBox(width: 12),
                        Expanded(child: _summaryCard('Maior Kc', '${maxCultura.nome}: ${_calcularMediaKc(maxCultura)}')),
                        const SizedBox(width: 12),
                        Expanded(child: _summaryCard('Média Geral', mediaGeral)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'O que é o Kc (Coeficiente de Cultura)?',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Kc é um número que indica quanta água uma planta precisa em comparação com a grama (padrão de referência ETo).',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _infoRow('Kc = 1.0', 'Planta precisa da MESMA água que a referência'),
                    _infoRow('Kc < 1.0', 'Planta precisa de MENOS água'),
                    _infoRow('Kc > 1.0', 'Planta precisa de MAIS água'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/etc'),
                    icon: const Icon(Icons.calculate_rounded),
                    label: Text('Calcular ETc',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/eto'),
                    icon: const Icon(Icons.water_drop_rounded),
                    label: Text('Calcular ETo',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendaItem(Color cor, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(width: 8),
        Text(texto, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _summaryCard(String titulo, String valor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.greenLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryLighter),
      ),
      child: Column(
        children: [
          Text(titulo,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              )),
          const SizedBox(height: 6),
          Text(valor,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              )),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.primary,
                )),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(description,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                )),
          ),
        ],
      ),
    );
  }
}
