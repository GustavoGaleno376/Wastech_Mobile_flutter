import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Realiza o login com e-mail e senha
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Cria uma nova conta e salva o nome no perfil do usuário
  Future<void> register(String name, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // No Firebase Auth, podemos salvar o nome diretamente no objeto do usuário
      await credential.user?.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Desloga o usuário do sistema
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Envia e-mail de redefinição de senha
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Traduz os erros técnicos do Firebase para mensagens em português
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'Usuário não encontrado. Verifique o e-mail informado.';
      case 'wrong-password': return 'Senha incorreta. Tente novamente.';
      case 'invalid-credential': return 'E-mail ou senha inválidos.';
      case 'email-already-in-use': return 'Este e-mail já está em uso por outra conta.';
      case 'weak-password': return 'A senha escolhida é muito fraca. Use pelo menos 6 caracteres.';
      case 'invalid-email': return 'O formato do e-mail é inválido.';
      case 'user-disabled': return 'Este usuário foi desativado. Entre em contato com o suporte.';
      case 'too-many-requests': return 'Muitas tentativas. Aguarde alguns minutos e tente novamente.';
      case 'network-request-failed': return 'Sem conexão com a internet. Verifique sua rede.';
      case 'operation-not-allowed': return 'Este tipo de autenticação não está disponível no momento.';
      case 'expired-action-code': return 'O código de redefinição expirou. Solicite um novo.';
      case 'requires-recent-login': return 'Faça login novamente para continuar.';
      default: return 'Ocorreu um erro inesperado. Tente novamente mais tarde.';
    }
  }
}
