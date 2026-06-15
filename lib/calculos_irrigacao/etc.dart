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

  double valorPorFase(String fase) {
    switch (fase) {
      case 'fase1': return fase1;
      case 'fase2': return fase2;
      case 'fase3': return fase3;
      case 'fase4': return fase4;
      default: return 0.0;
    }
  }
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

class ResultadoETCc {
  final double etcDiario;
  final double etcMediaPorDiaCiclo;
  final double etcTotalCiclo;
  final double kc;
  final double kcMedioCiclo;
  final String cultura;
  final String fase;
  final double eto;
  final int duracaoCiclo;
  final bool isCustom;
  final bool showMediaCiclo;

  ResultadoETCc({
    required this.etcDiario,
    required this.etcMediaPorDiaCiclo,
    required this.etcTotalCiclo,
    required this.kc,
    required this.kcMedioCiclo,
    required this.cultura,
    required this.fase,
    required this.eto,
    required this.duracaoCiclo,
    required this.isCustom,
    required this.showMediaCiclo,
  });
}

class ETCCPage extends StatefulWidget {
  const ETCCPage({super.key});

  @override
  State<ETCCPage> createState() => _ETCCPageState();
}

class _ETCCPageState extends State<ETCCPage> {
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
      nome: "Alface",
      duracao: 45,
      fases: "15-15-10-5",
      kcValores: KcValores(fase1: 0.7, fase2: 0.85, fase3: 1.0, fase4: 0.95),
    ),
    Cultura(
      nome: "Feijão",
      duracao: 90,
      fases: "15-25-35-15",
      kcValores: KcValores(fase1: 0.4, fase2: 0.8, fase3: 1.15, fase4: 0.35),
    ),
    Cultura(
      nome: "Banana",
      duracao: 365,
      fases: "120-90-120-35",
      kcValores: KcValores(fase1: 1.0, fase2: 1.1, fase3: 1.1, fase4: 1.0),
    ),
    Cultura(
      nome: "Café (Adulto)",
      duracao: 365,
      fases: "60-90-150-65",
      kcValores: KcValores(fase1: 0.9, fase2: 0.95, fase3: 1.1, fase4: 0.95),
    ),
  ];

  final TextEditingController _etoController = TextEditingController();
  final TextEditingController _customKcController = TextEditingController();
  final TextEditingController _diasCicloController = TextEditingController();

  Cultura? _culturaSelecionada;
  String? _faseSelecionada;
  bool _useCustomKc = false;
  ResultadoETCc? _resultado;

  final Map<String, String> _fasesNomes = {
    "fase1": "Fase 1 - Inicial",
    "fase2": "Fase 2 - Desenvolvimento",
    "fase3": "Fase 3 - Intermediária",
    "fase4": "Fase 4 - Maturação"
  };

  void _mostrarAlerta(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(mensagem)),
          ],
        ),
        backgroundColor: AppColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _calcularEtc() {
    if (_etoController.text.isEmpty) {
      _mostrarAlerta("Preencha o valor de ETo!");
      return;
    }

    if (!_useCustomKc && (_culturaSelecionada == null || _faseSelecionada == null)) {
      _mostrarAlerta("Selecione uma cultura e fase ou use Kc personalizado.");
      return;
    }

    if (_useCustomKc && _customKcController.text.isEmpty) {
      _mostrarAlerta("Insira o valor do Kc personalizado.");
      return;
    }

    final double? etoNumero = double.tryParse(_etoController.text);
    if (etoNumero == null || etoNumero <= 0) {
      _mostrarAlerta("Insira um valor numérico válido maior que zero.");
      return;
    }

    double kc;
    String culturaNome;
    String faseNome;
    int duracaoCiclo;

    if (_useCustomKc) {
      final double? kcNumero = double.tryParse(_customKcController.text);
      if (kcNumero == null || kcNumero < 0.1 || kcNumero > 2.0) {
        _mostrarAlerta("O Kc deve estar entre 0.1 e 2.0.");
        return;
      }

      final int diasNumero = int.tryParse(_diasCicloController.text) ?? 1;
      if (diasNumero <= 0 || diasNumero > 365) {
        _mostrarAlerta("A duração do ciclo deve ser entre 1 e 365 dias.");
        return;
      }

      kc = kcNumero;
      culturaNome = "Personalizado";
      faseNome = "Personalizado";
      duracaoCiclo = diasNumero;
    } else {
      kc = _culturaSelecionada!.kcValores.valorPorFase(_faseSelecionada!);
      culturaNome = _culturaSelecionada!.nome;
      faseNome = _faseSelecionada!;
      duracaoCiclo = _culturaSelecionada!.duracao;
    }

    double etcDiario = etoNumero * kc;
    double kcMedioCiclo = kc;
    double etcTotalCiclo = etoNumero * kc * duracaoCiclo;
    double etcMediaPorDiaCiclo = etcDiario;

    if (!_useCustomKc && _culturaSelecionada != null) {
      List<int> fasesDias = _culturaSelecionada!.fases.split("-").map(int.parse).toList();
      List<double> valoresKc = [
        _culturaSelecionada!.kcValores.fase1,
        _culturaSelecionada!.kcValores.fase2,
        _culturaSelecionada!.kcValores.fase3,
        _culturaSelecionada!.kcValores.fase4,
      ];

      double somaPonderada = 0;
      int totalDias = 0;

      for (int i = 0; i < fasesDias.length; i++) {
        somaPonderada += fasesDias[i] * valoresKc[i];
        totalDias += fasesDias[i];
      }

      if (totalDias > 0) {
        kcMedioCiclo = double.parse((somaPonderada / totalDias).toStringAsFixed(2));
        etcMediaPorDiaCiclo = etoNumero * kcMedioCiclo;
        etcTotalCiclo = etoNumero * kcMedioCiclo * _culturaSelecionada!.duracao;
      }
    }

    setState(() {
      _resultado = ResultadoETCc(
        etcDiario: double.parse(etcDiario.toStringAsFixed(2)),
        etcMediaPorDiaCiclo: double.parse(etcMediaPorDiaCiclo.toStringAsFixed(2)),
        etcTotalCiclo: double.parse(etcTotalCiclo.toStringAsFixed(2)),
        kc: kc,
        kcMedioCiclo: kcMedioCiclo,
        cultura: culturaNome,
        fase: faseNome,
        eto: etoNumero,
        duracaoCiclo: duracaoCiclo,
        isCustom: _useCustomKc,
        showMediaCiclo: !_useCustomKc,
      );
    });
  }

  void _limparCampos() {
    setState(() {
      _etoController.clear();
      _customKcController.clear();
      _diasCicloController.clear();
      _culturaSelecionada = null;
      _faseSelecionada = null;
      _useCustomKc = false;
      _resultado = null;
    });
  }

  @override
  void dispose() {
    _etoController.dispose();
    _customKcController.dispose();
    _diasCicloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Calculadora de ETc'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Evapotranspiração da Cultura',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'ETo Referência (mm/dia)',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _etoController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: 'Ex: 4.50',
                        prefixIcon: const Icon(Icons.water_drop_rounded),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Cultura',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Cultura>(
                      value: _useCustomKc ? null : _culturaSelecionada,
                      isExpanded: true,
                      hint: Text('Escolha o tipo de plantio',
                          style: GoogleFonts.inter(color: AppColors.textSecondary)),
                      items: _useCustomKc
                          ? null
                          : listaCulturas.map((Cultura c) {
                              return DropdownMenuItem<Cultura>(
                                value: c,
                                child: Text('${c.nome} (${c.duracao} dias)'),
                              );
                            }).toList(),
                      onChanged: _useCustomKc ? null : (Cultura? novaCultura) {
                        setState(() {
                          _culturaSelecionada = novaCultura;
                          _faseSelecionada = null;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _useCustomKc ? AppColors.border : AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fase do Desenvolvimento',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _useCustomKc ? null : _faseSelecionada,
                      isExpanded: true,
                      hint: Text(
                        _culturaSelecionada == null ? 'Selecione a cultura primeiro' : 'Escolha o estágio atual',
                        style: GoogleFonts.inter(color: AppColors.textSecondary),
                      ),
                      items: (_useCustomKc || _culturaSelecionada == null)
                          ? null
                          : _fasesNomes.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                      onChanged: (_useCustomKc || _culturaSelecionada == null) ? null : (String? novaFase) {
                        setState(() {
                          _faseSelecionada = novaFase;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: (_useCustomKc || _culturaSelecionada == null) ? AppColors.border : AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('OU',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              )),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      title: Text('Usar Kc personalizado',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          )),
                      value: _useCustomKc,
                      activeColor: AppColors.primary,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (bool? valor) {
                        setState(() {
                          _useCustomKc = valor ?? false;
                          if (_useCustomKc) {
                            _culturaSelecionada = null;
                            _faseSelecionada = null;
                          }
                        });
                      },
                    ),
                    if (_useCustomKc) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _customKcController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: 'Fator Kc',
                                hintText: 'Ex: 1.05',
                                filled: true,
                                fillColor: AppColors.background,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _diasCicloController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Dias Totais',
                                hintText: 'Ex: 90',
                                filled: true,
                                fillColor: AppColors.background,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: FilledButton.icon(
                            onPressed: _calcularEtc,
                            icon: const Icon(Icons.flash_on_rounded, size: 18),
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
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: _limparCampos,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_resultado != null) ...[
              const SizedBox(height: 24),
              _buildResultado(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultado() {
    final res = _resultado!;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greenLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryLighter, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              res.isCustom ? 'Relatório (Kc customizado)' : 'Relatório de Demanda Hídrica',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _resumoRow('Cultura:', res.cultura),
            _resumoRow('Fase:', _fasesNomes[res.fase] ?? res.fase),
            _resumoRow('Fator Kc:', '${res.kc}'),
            _resumoRow('ETo:', '${res.eto} mm/dia'),
            _resumoRow('Ciclo:', '${res.duracaoCiclo} dias'),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.5)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Lâmina de Irrigação (ETc)',
                      style: GoogleFonts.inter(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      )),
                  const SizedBox(height: 8),
                  Text('${res.etcDiario} mm/dia',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      )),
                  Text('${res.etcDiario} L por m² ao dia',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      )),
                ],
              ),
            ),
            if (res.showMediaCiclo && res.kcMedioCiclo != res.kc) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Text('Projeção para Todo o Ciclo',
                        style: GoogleFonts.inter(
                          color: Color(0xFFB45309),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        )),
                    const SizedBox(height: 4),
                    Text(
                      'Kc Médio: ${res.kcMedioCiclo} | Total: ${res.etcTotalCiclo} mm',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Color(0xFF78350F),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _resumoRow(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                color: AppColors.primaryDark,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              )),
          Text(valor,
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
