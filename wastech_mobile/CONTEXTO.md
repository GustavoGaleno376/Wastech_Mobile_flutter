# WASTECH Mobile — Contexto do Projeto

## Estrutura do Projeto

```
wastech_mobile/
├── lib/
│   ├── main.dart                 # Entry point + tema Material 3
│   ├── screens/
│   │   ├── login_screen.dart     # Tela de Login (pronta)
│   │   ├── register_screen.dart  # Tela de Cadastro (pronta)
│   │   └── home_screen.dart      # Tela inicial pós-login (exemplo)
│   └── services/
│       └── auth_service.dart     # Mock do backend (substituir depois)
├── pubspec.yaml
└── CONTEXTO.md                   # Este arquivo
```

## Telas Prontas

### Login (`lib/screens/login_screen.dart`)
- Logo WASTECH + slogan
- Campo e-mail (valida: vazio, sem `@`)
- Campo senha com toggle visibilidade (valida: vazio, mínimo 6 caracteres)
- Botão "Entrar" com loading
- Link "Esqueci minha senha" (snackbar placeholder)
- Link "Cadastre-se" → navega para RegisterScreen
- Ao logar → navega para HomeScreen

### Cadastro (`lib/screens/register_screen.dart`)
- Logo WASTECH (versão menor)
- Campo nome completo (valida: vazio, precisa nome + sobrenome)
- Campo e-mail
- Campo senha com toggle
- Campo confirmar senha com toggle (valida: igual à senha)
- Botão "Criar conta" com loading
- Link "Fazer login" → volta para LoginScreen
- Após cadastro → snackbar de sucesso + volta ao login

### Home (`lib/screens/home_screen.dart`)
- AppBar com logout
- Placeholder para telas dos colegas

## Como Adicionar Novas Telas (para os colegas)

1. Criar arquivo em `lib/screens/` (ex: `climate_screen.dart`)
2. Usar `Navigator.push` para navegar até ela:
   ```dart
   Navigator.push(
     context,
     MaterialPageRoute(builder: (_) => const ClimateScreen()),
   );
   ```

## Backend (fazer depois)

O arquivo `lib/services/auth_service.dart` é um mock que só simula delay:

```dart
class AuthService {
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
  }
  Future<void> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
```

**Para conectar o backend real:** basta reescrever esse arquivo com chamadas HTTP,
mantendo os mesmos métodos (`login` e `register`). Nenhuma tela precisa ser alterada.

## Paleta de Cores

| Elemento | Cor |
|----------|-----|
| Primary | `#2E7D32` (verde) |
| Background | `#FFFFFF` (branco) |
| Surface (inputs) | `#F5F5F5` (cinza claro) |

## Comandos

```bash
flutter analyze          # Verificar erros
flutter run              # Rodar o app
```

## Observações

- Projeto Flutter com Material 3
- Navegação com `Navigator.push` / `Navigator.pop` (sem rotas nomeadas)
- Validação inline com `Form` + `GlobalKey<FormState>`
- `SingleChildScrollView` em todas as telas (sem overflow com teclado)
- Loading state com `CircularProgressIndicator` nos botões
