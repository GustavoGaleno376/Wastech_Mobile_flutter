import 'dart:async';

// Modelo de dados para organizar o que é uma "Planta" no sistema
class Planta {
  String id;
  String nome;
  String tipo;

  Planta({required this.id, required this.nome, required this.tipo});

  // Converte a Planta para o formato que o banco de dados (ou Firebase) entende
  Map<String, String> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
    };
  }

  // Cria uma Planta a partir dos dados vindos do banco de dados (ou Firebase)
  factory Planta.fromMap(Map<String, dynamic> map) {
    return Planta(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      tipo: map['tipo'] ?? '',
    );
  }
}

class PlantService {
  // Lista simulando o banco de dados em memória por enquanto
  final List<Planta> _bancoSimulado = [
    Planta(id: '1', nome: 'Tomate Cereja', tipo: 'Hortaliça'),
    Planta(id: '2', nome: 'Milho Híbrido', tipo: 'Grão'),
  ];

  // C - CREATE (Adicionar planta)
  Future<void> adicionarPlanta(String nome, String tipo) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simula o tempo de resposta da internet
    final novaPlanta = Planta(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome,
      tipo: tipo,
    );
    _bancoSimulado.add(novaPlanta);
  }

  // R - READ (Ver/Listar as plantas existentes)
  Future<List<Planta>> obterPlantas() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_bancoSimulado); // Retorna uma cópia da lista
  }

  // U - UPDATE (Editar planta)
  Future<void> editarPlanta(String id, String novoNome, String novoTipo) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _bancoSimulado.indexWhere((p) => p.id == id);
    if (index != -1) {
      _bancoSimulado[index].nome = novoNome;
      _bancoSimulado[index].tipo = novoTipo;
    }
  }

  // D - DELETE (Remover planta)
  Future<void> removerPlanta(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _bancoSimulado.removeWhere((p) => p.id == id);
  }
}