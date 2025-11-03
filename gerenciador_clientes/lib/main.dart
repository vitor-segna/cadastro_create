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



//tela do login
class TelaLogin extends StatelessWidget{
  const TelaLogin({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
  body: Center(
  child: Text('Login..')
  )
  );
}

class TelaCadastro extends StatelessWidget{
 const TelaCadastro({super.key});
 @override
 Widget build(BuildContext context) => const Scaffold(
  body: Center(child: Text('Cadastro..')), 
 );
}