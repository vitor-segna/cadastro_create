//importa o dart 
import 'package:flutter/material.dart';
//importa o cliente/modelo de BD
import 'package:gerenciador_clientes/modelos/cliente.dart';


//chamando o gerenciador de clientes/instanciando nosso BD
final GerenciadorClientes gerenciadorClientes = GerenciadorClientes();

void main(){ //chamando
 gerenciadorClientes.cadastrar(
  Cliente(nome: 'Admin', email: 'admin@gmail.com', senha: 'admin') //criando o cliente
  );
  runApp(const AplicativoClientes()); 
}
class AplicativoClientes extends StatelessWidget{
 const AplicativoClientes({super.key}); 

 @override
 Widget build(BuildContext context){ //widget|colocando texto nela
 return MaterialApp(
  title: 'Sistema de Clientes', //titulo
  debugShowCheckedModeBanner: false,//sem banner
  theme: ThemeData(//estilizandar
  primarySwatch: Colors.indigo,
  useMaterial3: true,
  ),
 home: TelaPrincipal(
  cliente: Cliente(nome: 'DEV TESTE', email: 'dev@email.com', senha: '0'), 
 ),
 );
 }
}



//mural/TELA INICIAL
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
(Route<dynamic> route) => false, // Condição que remove todas as rotas.
);
},
tooltip: 'Sair do Sistema',
)
],
),
body: Center(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Icon(Icons.check_circle_outline, size: 80, color: Colors.indigo),
const SizedBox(height: 20),
Text('Login de ${cliente.nome} realizado!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
const SizedBox(height: 8),
Text('E-mail: ${cliente.email}', style: const TextStyle(fontSize: 18, color: Colors.grey)),
const SizedBox(height: 40),
// Título da lista de clientes
const Text('Clientes cadastrados (BD Simulado):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
const SizedBox(height: 10),
// Lista de Clientes Cadastrados
Expanded(
// Usa o getter 'clientes' do nosso gerenciador.
child: ListView.builder(
itemCount: gerenciadorClientes.clientes.length,
itemBuilder: (context, index) {
final c = gerenciadorClientes.clientes[index];
return ListTile(
leading: const Icon(Icons.person),
title: Text(c.nome),
subtitle: Text(c.email),
);
},
),
),
],
),
),
),
);
}
}



// lib/main.dart (CLASSE TELA CADASTRO COMPLETA)
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

  void _fazerCadastro() {
    if (_chaveForm.currentState!.validate()) { // Se a validação dos campos for OK...
      final novoCliente = Cliente(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
      );

      // Tenta cadastrar no BD simulado.
      final sucesso = gerenciadorClientes.cadastrar(novoCliente);

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

// ATUALIZE O PLACEHOLDER DA TELA DE LOGIN PARA INCLUIR A NAVEGAÇÃO
class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Acesso ao Sistema (Em Construção)')),
        body: Center(
          child: TextButton(
            onPressed: () {
              // Navega para a tela de cadastro.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaCadastro()),
              );
            },
            child: const Text('Ir para Cadastro'),
          ),
        ),
      );
}