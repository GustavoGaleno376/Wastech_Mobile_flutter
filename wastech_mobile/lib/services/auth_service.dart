// Mock do serviço de autenticação.
// Troque este arquivo pela integração real com o backend quando estiver pronto.

class AuthService {
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> register(
      String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
