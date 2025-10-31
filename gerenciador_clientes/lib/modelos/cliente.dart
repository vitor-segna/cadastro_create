//importe necessário do material App 
import 'package:flutter/material.dart';

//String=tipo de variável(texto)
class Cliente {
  final String nome;
  final String email;
  final String senha;

 //Construtor do cliente
 Cliente({
  required this.nome, //REQUIRED= é obrigatório preencher
  required this.email,
  required this.senha,
 });
 @override
 String toString(){ //toString= transforma em String
 return 'Cliente: $nome, Email: $email'; //$=Puxa as variáveis
 }
}

class GerenciadorClientes{
  //Váriavel estática que guarda a única cópia desta classe
  static final GerenciadorClientes _instancia = GerenciadorClientes._interno();

  //Impede a criação de novas instâncias
  GerenciadorClientes._interno();

  //sempre retorna a instância existente
  factory GerenciadorClientes() => _instancia; //FATORA o gerenciador para a instância 

  //lista <ul> que armazena todos os clientes cadastrados
  final List<Cliente> _clientes= []; //LIST=uma lista não ordenada

  
  List<Cliente> get clientes => List.unmodifiable(_clientes);

 //Tentar cadastrar um cliente novo
  bool cadastrar(Cliente cliente){
 //vamos checar se já existe um email cadastrado
 if(_clientes.any((c) => c.email.toLowerCase() == cliente.email.toLowerCase())){//ANY= se   
 print('Erro: email ${cliente.email} já cadastrado'); //mensagem puxando a variável de email
 return false; //cadastro falhou
  }
 _clientes.add(cliente);//adicionar o cliente
 print('Novo cliente cadastrado : ${cliente.nome}');
 return true; //cadastrou 
}


Cliente ? login(String email, String senha){ //?=possibilidade de ser nulo(falhar)
  return _clientes.firstWhere(
   //é uma função anônima 
   //o c representa cada elemento(cada cliente) da lista _clientes
   (c) => c.email.toLowerCase() == email.toLowerCase() && c.senha == senha,//chamando o email do cliente
   orElse: () => null, //retorna nulo se não encontrar os dados
  );
}
}