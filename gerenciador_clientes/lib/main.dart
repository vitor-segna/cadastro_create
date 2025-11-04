// lib/main.dart (INÍCIO ATUALIZADO)
import 'package:flutter/material.dart';
import 'modelos/cliente.dart'; // Importa o modelo.
import 'package:firebase_core/firebase_core.dart'; // NOVO: Para iniciar o Firebase.

// NOVO: Importe o arquivo de opções do seu projeto gerado pelo FlutterFire CLI
import 'firebase_options.dart';


//instaciano nosso BD
// NOVO: Substituímos o GerenciadorClientes pelo ServicoClientes.
final ServicoClientes servicoClientes = ServicoClientes();


// A função main agora é assíncrona para inicializar o Firebase.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o Flutter está pronto.

  // Inicializa o Firebase (OBRIGATÓRIO).
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AplicativoClientes());
}
// ...
// O restante da classe AplicativoClientes permanece o mesmo...
// ...
class AplicativoClientes extends StatelessWidget {
  const AplicativoClientes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Clientes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const TelaLogin(),// <--- agora começa no login
    );
  }
}

class TelaPrincipal extends StatelessWidget {
  final Cliente cliente;

  const TelaPrincipal({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Cliente'),
        automaticallyImplyLeading: false, // Remove a seta de voltar.
        actions: [
          // Botão de Sair (Logout).
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Navegação: Limpa a pilha e volta para a Tela de Login.
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TelaLogin()),
                (Route<dynamic> route) =>
                    false, // Condição que remove todas as rotas.
              );
            },
            tooltip: 'Sair do Sistema',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.indigo,
              ),
              const SizedBox(height: 20),
              Text(
                'Login de ${cliente.nome} realizado!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'E-mail: ${cliente.email}',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              // Título da lista de clientes
              const Text(
                'Clientes cadastrados (BD Simulado):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Lista de Clientes Cadastrados
              
                  // NOVO: StreamBuilder para atualizar a lista em tempo real
     StreamBuilder<List<Cliente>>(
      // Conecta ao Stream de clientes do nosso serviço Firebase.
      stream: servicoClientes.clientesStream,
      builder: (context, snapshot) {
        // 1. Se houver erro.
        if (snapshot.hasError) {
          return const Text('Erro ao carregar clientes.');
        }

        // 2. Se estiver carregando.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 3. Se os dados estiverem prontos.
        final clientes = snapshot.data ?? [];
             return Expanded(
                // Usa o getter 'clientes' do nosso gerenciador.
                child: ListView.builder(
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    final c = clientes[index];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(c.nome),
                      subtitle: Text(c.email),
                    );
                  },
                ),
             );
      }
    ),
  
            ],
          ),
        ),
      ),
    );
  
  }
}



class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _EstadoTelaCadastro();
}

class _EstadoTelaCadastro extends State<TelaCadastro> {
  final _chaveForm = GlobalKey<FormState>(); // Chave para validar o formulário.
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  String _mensagemErro = '';

  void _fazerCadastro() async {
    if (_chaveForm.currentState!.validate()) { // Se a validação dos campos for OK...
      setState(() => _mensagemErro = '');
 final novoCliente = Cliente(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      );

      // Tenta cadastrar no BD simulado.
      final sucesso =  await servicoClientes.cadastrar(novoCliente); // <-- AWAIT AQUI!

      if (sucesso) {
        // Se sucesso: exibe uma notificação e volta para a tela de Login.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Cadastro realizado com sucesso!')),
        );
        Navigator.pop(context); // Volta para a TelaLogin.
      } else {
        // Se falhar (e-mail duplicado).
        setState(() {
          _mensagemErro = 'E-mail já cadastrado. Tente outro!';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Cadastro de Cliente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _chaveForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Crie sua conta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              // Campo Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome Completo', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                validator: (valor) => (valor == null || valor.isEmpty) ? 'Campo obrigatório.' : null,
              ),
              const SizedBox(height: 16),
              // Campo E-mail
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
                validator: (valor) => (valor == null || !valor.contains('@')) ? 'E-mail inválido.' : null,
              ),
              const SizedBox(height: 16),
              // Campo Senha
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
                validator: (valor) => (valor == null || valor.length < 6) ? 'A senha deve ter 6+ caracteres.' : null,
              ),
              const SizedBox(height: 20),
              // Mensagem de Erro
              if (_mensagemErro.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(_mensagemErro, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              // Botão de Cadastro
              ElevatedButton.icon(
                onPressed: _fazerCadastro,
                icon: const Icon(Icons.app_registration),
                label: const Text('Cadastrar'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // BOA PRÁTICA: Liberar os controladores quando o widget for removido
  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
}

// (CLASSE TELA LOGIN COMPLETA)

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _EstadoTelaLogin();
}

class _EstadoTelaLogin extends State<TelaLogin> {
  final _chaveForm = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  String _mensagemErro = '';

  void _fazerLogin() async {
    // 1. Validação dos campos
    if (_chaveForm.currentState!.validate()) {
      setState(() => _mensagemErro = ''); // Limpa erro.

      final email = _emailController.text.trim();
      final senha = _senhaController.text;

      // 2. Chama o método 'login' do nosso BD simulado.
      final clienteLogado = await servicoClientes.login(email, senha); // <-- AWAIT AQUI!

      if (clienteLogado != null) {
        // 3. Login de sucesso: Navega para a tela principal (substituindo o Login).
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TelaPrincipal(cliente: clienteLogado),
          ),
        );
      } else {
        // 4. Login falhou.
        setState(() {
          _mensagemErro = 'E-mail ou senha incorretos.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acesso ao Sistema')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _chaveForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Bem-vindo!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              // Campo E-mail
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (valor) => (valor == null || !valor.contains('@')) ? 'E-mail inválido.' : null,
              ),
              const SizedBox(height: 16),
              // Campo Senha
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (valor) => (valor == null || valor.length < 6) ? 'A senha deve ter 6+ caracteres.' : null,
              ),
              const SizedBox(height: 20),
              // Mensagem de Erro
              if (_mensagemErro.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(_mensagemErro, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              // Botão de Login
              ElevatedButton.icon(
                onPressed: _fazerLogin,
                icon: const Icon(Icons.login),
                label: const Text('Entrar'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              ),
              const SizedBox(height: 10),
              // Botão para Cadastrar
              TextButton(
                onPressed: () {
                  // Navega para a tela de cadastro.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TelaCadastro()),
                  );
                },
                child: const Text('Não tem conta? Cadastre-se aqui.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // BOA PRÁTICA: Liberar os controladores
  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
}