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

class TelaPrincipal extends StatelessWidget{
final Cliente cliente;

const TelaPrincipal({super.key, required this.cliente});

@override
Widget build(BuildContext context){
 return Scaffold( //Tela
  appBar: AppBar(title: const Text('Tela Principal (Em Construção)')),
  body: Center(
  child: Text(
  'Bem Vindo, ${cliente.nome}!!',
  style: const TextStyle(fontSize: 24),  
  ),  
  ),
  );  
}
}

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