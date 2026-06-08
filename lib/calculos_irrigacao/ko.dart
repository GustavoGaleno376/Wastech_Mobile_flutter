  import 'package:flutter/material.dart';

  // --- MODELO DE DADOS (Caso ainda não tenha criado no seu arquivo culturas.dart) ---
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
    final String fases; // Ex: "20-30-40-20"
    final KcValores kcValores;

    Cultura({
      required this.nome,
      required this.duracao,
      required this.fases,
      required this.kcValores,
    });
  }

  // --- PÁGINA DA TABELA KC ---
  class KoPage extends StatelessWidget {
    KoPage({super.key});

    // Simulando a lista global de culturas do seu banco/dados
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

    // LÓGICA: Calcula a média ponderada do Kc baseado nos dias de cada fase
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

    // LÓGICA: Retorna a cor de fundo com base no valor do Kc médio (Equivalente às cores dinâmicas do React)
    Color _getCorConsumo(double kcMedia) {
      if (kcMedia < 0.7) return const Color(0xFFDCFCE7); // Verde bem claro
      if (kcMedia < 1.0) return const Color(0xFFBBF7D0); // Verde médio
      return const Color(0xFF86EFAC); // Verde forte
    }

    @override
    Widget build(BuildContext context) {
      // Cálculos para os cartões de resumo
      Cultura minCultura = listaCulturas.reduce((min, curr) => _calcularMediaKc(curr) < _calcularMediaKc(min) ? curr : min);
      Cultura maxCultura = listaCulturas.reduce((max, curr) => _calcularMediaKc(curr) > _calcularMediaKc(max) ? curr : max);
      double somaTotalMedias = listaCulturas.fold(0.0, (soma, curr) => soma + _calcularMediaKc(curr));
      String mediaGeral = (somaTotalMedias / listaCulturas.length).toStringAsFixed(2);

      return Scaffold(
        backgroundColor: const Color(0xFFF1F8F1), // Cor de fundo suave da página
        appBar: AppBar(
          title: const Text("Tabela de Coeficientes (Kc)"),
          backgroundColor: const Color(0xFF22C55E),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Valores de Kc para diferentes culturas e fases de crescimento",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
              ),
              const SizedBox(height: 20),

              // 1. TABELA DE DADOS (Simulada em um SingleChildScrollView horizontal para não quebrar em telas pequenas)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color(0xFF22C55E)),
                      columns: const [
                        DataColumn(label: Text('Cultura', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Duração\n(Dias)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Fases\n(Dias)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Kc\nInicial', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Kc\nDesenv.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Kc\nMeio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Kc\nFinal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Kc\nMédio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                      rows: listaCulturas.map((cultura) {
                        final double kcMedia = _calcularMediaKc(cultura);
                        return DataRow(cells: [
                          DataCell(Text(cultura.nome, style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(cultura.duracao.toString())),
                          DataCell(Text(cultura.fases)),
                          DataCell(Text(cultura.kcValores.fase1.toString())),
                          DataCell(Text(cultura.kcValores.fase2.toString())),
                          DataCell(Text(cultura.kcValores.fase3.toString())),
                          DataCell(Text(cultura.kcValores.fase4.toString())),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getCorConsumo(kcMedia),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                kcMedia.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 2. CARD DE INTERPRETAÇÃO E LEGENDA
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "📊 Como interpretar o Kc Médio?",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                      ),
                      const SizedBox(height: 15),
                      
                      // Legendas (Wrap organiza os itens em linha e pula se faltar espaço)
                      Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: [
                          _buildLegendaItem(const Color(0xFFDCFCE7), "Baixo consumo (< 0.7)"),
                          _buildLegendaItem(const Color(0xFFBBF7D0), "Consumo moderado (0.7 - 1.0)"),
                          _buildLegendaItem(const Color(0xFF86EFAC), "Alto consumo (> 1.0)"),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Grid de Resumos (Menor, Maior e Média Geral)
                      LayoutBuilder(builder: (context, constraints) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildSummaryCard(
                              constraints.maxWidth,
                              "🌱 Menor Kc Médio",
                              "${minCultura.nome}: ${_calcularMediaKc(minCultura)}",
                              "Menor necessidade hídrica",
                            ),
                            _buildSummaryCard(
                              constraints.maxWidth,
                              "💧 Maior Kc Médio",
                              "${maxCultura.nome}: ${_calcularMediaKc(maxCultura)}",
                              "Maior necessidade hídrica",
                            ),
                            _buildSummaryCard(
                              constraints.maxWidth,
                              "📈 Média Geral",
                              mediaGeral,
                              "Média de todas as culturas",
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. CARD INFORMATIVO EDUCACIONAL
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "🌱 O que é o Kc (Coeficiente de Cultura)?",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Kc é um número que indica quanta água uma planta precisa em comparação com a grama (padrão de referência ETo).",
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "🔢 Como funciona:",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                      ),
                      SizedBox(height: 8),
                      Text("• Kc = 1.0 → Planta precisa da MESMA água que a referência"),
                      Text("• Kc < 1.0 → Planta precisa de MENOS água"),
                      Text("• Kc > 1.0 → Planta precisa de MAIS água"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
// 4. BOTÕES DE NAVEGAÇÃO
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ElevatedButton.icon(
      onPressed: () {
        // 🎯 ALTERADO: Agora ele navega para a rota do etc.dart em vez de fechar a tela
        Navigator.pushNamed(context, '/etcc'); 
      },
      icon: const Icon(Icons.calculate),
      label: const Text("Calcular ETc"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    const SizedBox(width: 12),
    OutlinedButton.icon(
      onPressed: () {
        // Rota de retorno ao menu principal
        Navigator.pushNamed(context, '/dashboard');
      },
      icon: const Icon(Icons.home),
      label: const Text("Dashboard"),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF6B7280),
        side: const BorderSide(color: Color(0xFF6B7280)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
  ],
),
            ],
          ),
        ),
      );
    }

    // WIDGET AUXILIAR: Item de Legenda
    Widget _buildLegendaItem(Color cor, String texto) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: cor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black12),
            ),
          ),
          const SizedBox(width: 8),
          Text(texto, style: const TextStyle(fontSize: 13)),
        ],
      );
    }

    // WIDGET AUXILIAR: Cartões de Resumo (Calcula largura responsiva)
    Widget _buildSummaryCard(double maxWidth, String titulo, String valor, String subtitulo) {
      // Se a tela for larga (tablet/desktop), divide por 3, se for celular usa o espaço completo.
      double cardWidth = maxWidth > 600 ? (maxWidth - 24) / 3 : maxWidth;

      return Container(
        width: cardWidth,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFBBF7D0)),
        ),
        child: Column(
          children: [
            Text(titulo, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
            const SizedBox(height: 6),
            Text(valor, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
            const SizedBox(height: 4),
            Text(subtitulo, style: const TextStyle(fontSize: 11, color: Color(0xFF4B5563)), textAlign: TextAlign.center),
          ],
        ),
      );
    }
  }