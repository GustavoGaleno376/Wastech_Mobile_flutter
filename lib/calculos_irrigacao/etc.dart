import 'package:flutter/material.dart';

// --- MODELO DE DADOS ---
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

// --- CLASSE DE RESULTADO ---
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

// --- PÁGINA PRINCIPAL ---
class ETCCPage extends StatefulWidget {
  const ETCCPage({super.key});

  @override
  State<ETCCPage> createState() => _ETCCPageState();
}

class _ETCCPageState extends State<ETCCPage> {
  // Lista expandida com dados agronômicos reais (FAO)
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
    "fase3": "Fase 3 - Intermediária (Meio)",
    "fase4": "Fase 4 - Final (Maturação)"
  };

  void _mostrarAlerta(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(mensagem, style: const TextStyle(fontWeight: FontWeight.w500))),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _calcularEtc() {
    if (_etoController.text.isEmpty) {
      _mostrarAlerta("Por favor, preencha o valor de ETo!");
      return;
    }

    if (!_useCustomKc && (_culturaSelecionada == null || _faseSelecionada == null)) {
      _mostrarAlerta("Selecione uma cultura e fase ou use a opção de Kc personalizado.");
      return;
    }

    if (_useCustomKc && _customKcController.text.isEmpty) {
      _mostrarAlerta("Insira o valor do seu Kc personalizado.");
      return;
    }

    final double? etoNumero = double.tryParse(_etoController.text);
    if (etoNumero == null || etoNumero <= 0) {
      _mostrarAlerta("Insira um valor numérico válido maior que zero para o ETo.");
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), 
      appBar: AppBar(
        title: const Text("Calculadora de ETc", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Evapotranspiração da Cultura",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            
            // CARD DO FORMULÁRIO (Efeito Modern Box-Shadow)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // INPUT ETo
                    _buildInputLabel("🌤️ ETo Referência (mm/dia)"),
                    TextField(
                      controller: _etoController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      decoration: _buildInputDecoration("Ex: 4.50", helper: "Valor obtido na medição climática anterior"),
                    ),
                    const SizedBox(height: 24),

                    // SELECT CULTURA
                    _buildInputLabel("🌱 Cultura"),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: _buildBoxDropdownDecoration(disabled: _useCustomKc),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Cultura>(
                          value: _useCustomKc ? null : _culturaSelecionada,
                          isExpanded: true,
                          hint: const Text("Escolha o tipo de plantio", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 15)),
                          items: _useCustomKc
                              ? null
                              : listaCulturas.map((Cultura c) {
                                  return DropdownMenuItem<Cultura>(
                                    value: c,
                                    child: Text("${c.nome} (${c.duracao} dias)", style: const TextStyle(fontWeight: FontWeight.w500)),
                                  );
                                }).toList(),
                          onChanged: _useCustomKc ? null : (Cultura? novaCultura) {
                            setState(() {
                              _culturaSelecionada = novaCultura;
                              _faseSelecionada = null;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SELECT FASE
                    _buildInputLabel("📈 Fase do Desenvolvimento"),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: _buildBoxDropdownDecoration(disabled: _useCustomKc || _culturaSelecionada == null),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _useCustomKc ? null : _faseSelecionada,
                          isExpanded: true,
                          hint: Text(
                            _culturaSelecionada == null ? "Aguardando seleção da cultura" : "Escolha o estágio atual",
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                          ),
                          items: (_useCustomKc || _culturaSelecionada == null)
                              ? null
                              : _fasesNomes.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w500)),
                                  );
                                }).toList(),
                          onChanged: (_useCustomKc || _culturaSelecionada == null) ? null : (String? novaFase) {
                            setState(() {
                              _faseSelecionada = novaFase;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // DIVISOR
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text("OU", style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // CHECKBOX CUSTOM
                    CheckboxListTile(
                      title: const Text("✏️ Configurar Kc manualmente", style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155), fontSize: 15)),
                      value: _useCustomKc,
                      activeColor: const Color(0xFF22C55E),
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
                            child: TextField(
                              controller: _customKcController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: _buildInputDecoration("Ex: 1.05", label: "Fator Kc"),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextField(
                              controller: _diasCicloController,
                              keyboardType: TextInputType.number,
                              decoration: _buildInputDecoration("Ex: 90", label: "Dias Totais"),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 32),

                    // BOTÕES DE COMPILAR E RESET
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ElevatedButton.icon(
                            onPressed: _calcularEtc,
                            icon: const Icon(Icons.flash_on, size: 18),
                            label: const Text("Calcular ETc", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF22C55E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: _limparCampos,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Icon(Icons.refresh, color: Color(0xFF64748B)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // RESULTADOS FORMATADOS
            if (_resultado != null) ...[
              const SizedBox(height: 28),
              _buildWidgetResultado(),
            ],
          ],
        ),
      ),
    );
  }

  // ELEMENTOS DE INTERFACE AUXILIARES (UI BUILDERS)
  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155), fontSize: 14)),
    );
  }

  InputDecoration _buildInputDecoration(String hint, {String? label, String? helper}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF22C55E), width: 1.5)),
    );
  }

  BoxDecoration _buildBoxDropdownDecoration({bool disabled = false}) {
    return BoxDecoration(
      color: disabled ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    );
  }

  Widget _buildWidgetResultado() {
    final res = _resultado!;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA7F3D0), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              res.isCustom ? "📊 Relatório (Kc customizado)" : "📊 Relatório de Demanda Hídrica",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(color: Color(0xFFA7F3D0)),
            ),
            
            _buildResumoRow("Planta Atendida:", res.cultura),
            _buildResumoRow("Fase Identificada:", _fasesNomes[res.fase] ?? res.fase),
            _buildResumoRow("Fator Kc Aplicado:", "${res.kc}"),
            _buildResumoRow("ETo do Período:", "${res.eto} mm/dia"),
            _buildResumoRow("Duração do Ciclo:", "${res.duracaoCiclo} dias"),
            const SizedBox(height: 20),
            
            // CARD DO VOLUME DIÁRIO
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF34D399).withOpacity(0.5)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("💧 Lâmina de Irrigação Líquida (ETc)", style: TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text("${res.etcDiario} mm/dia", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                  const SizedBox(height: 4),
                  Text("Equivale a gastar ${res.etcDiario} L por m² ao dia", style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500)),
                ],
              ),
            ),

            // HISTÓRICO INTEGRADO DO CICLO COMPLETO
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
                    const Text("📅 Projeção para Todo o Ciclo", style: TextStyle(color: Color(0xFFB45309), fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text("Kc Médio Ponderado: ${res.kcMedioCiclo} | Volume Total: ${res.etcTotalCiclo} mm", 
                      style: const TextStyle(fontSize: 12, color: Color(0xFF78350F), fontWeight: FontWeight.bold),
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

  Widget _buildResumoRow(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF065F46), fontSize: 13, fontWeight: FontWeight.w500)),
          Text(valor, style: const TextStyle(color: Color(0xFF047857), fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}