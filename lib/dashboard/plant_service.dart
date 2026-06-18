import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Planta {
  String id;
  String nome;
  String tipo;

  Planta({required this.id, required this.nome, required this.tipo});

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'tipo': tipo,
    };
  }

  factory Planta.fromMap(String id, Map<String, dynamic> map) {
    return Planta(
      id: id,
      nome: map['nome'] ?? '',
      tipo: map['tipo'] ?? '',
    );
  }
}

class PlantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<String> adicionarPlanta(String nome, String tipo) async {
    final docRef = await _firestore.collection('users').doc(_uid).collection('plants').add({
      'nome': nome,
      'tipo': tipo,
    });
    return docRef.id;
  }

  Future<List<Planta>> obterPlantas() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('plants')
        .get();

    return snapshot.docs
        .map((doc) => Planta.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> editarPlanta(String id, String novoNome, String novoTipo) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('plants')
        .doc(id)
        .update({
      'nome': novoNome,
      'tipo': novoTipo,
    });
  }

  Future<void> removerPlanta(String id) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('plants')
        .doc(id)
        .delete();
  }
}