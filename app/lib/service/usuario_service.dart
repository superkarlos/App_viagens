import 'dart:convert';

import 'package:My_App/model/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsuarioService with ChangeNotifier {
  final baseUrl = 'https://projeto-unid2-ddm-default-rtdb.firebaseio.com/';

  List<Usuario> usuarios = [];

  List<Usuario> get items {
    return [...usuarios];
  }

  Future<void> addUser(Usuario usuario) async {
    try {
      final int lastId = usuarios.isNotEmpty ? usuarios.last.id ?? 0 : 0;
      final newId = (lastId + 1);

      final response = await http.post(
        Uri.parse('$baseUrl/users.json'),
        body: jsonEncode({
          "id": newId,
          "name": usuario.nome,
          "idade": usuario.idade,
          "saldo": usuario.saldo,
          "user": usuario.nomeUsuario,
          "password": usuario.senha,
        }),
      );

      if (response.statusCode == 200) {
        //final id = jsonDecode(response.body)['name'];
        usuarios.add(Usuario(
          id: newId,
          nome: usuario.nome,
          idade: usuario.idade,
          saldo: usuario.saldo,
          nomeUsuario: usuario.nomeUsuario,
          senha: usuario.senha,
        ));
        notifyListeners();
      } else {
        print('Falha ao adicionar usuário: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to add User: $error');
      throw error;
    }
  }

  Future<void> updateUser(Usuario usuario) async {
    int index = usuarios.indexWhere((p) => p.id == usuario.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$baseUrl/users/${usuario.id}.json'),
        body: jsonEncode({
          "id": usuario.id,
          "name": usuario.nome,
          "idade": usuario.idade,
          "saldo": usuario.saldo,
          "user": usuario.nomeUsuario,
          "password": usuario.senha,
        }),
      );
      usuarios[index] = usuario;
      notifyListeners();
    }
  }

  Future<void> removeUser(Usuario usuario) async {
    int index = usuarios.indexWhere((p) => p.id == usuario.id);

    if (index >= 0) {
      await http.delete(Uri.parse('$baseUrl/users/${usuario.id}.json'));
      usuarios.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('$baseUrl/users.json');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody == null) {
          print('Nenhum dado encontrado no servidor');
          return;
        }

        final Map<String, dynamic> data = responseBody as Map<String, dynamic>;
        List<Usuario> loadedusers = [];
        data.forEach((id, userData) {
          if (userData != null) {
            loadedusers.add(Usuario.fromJson(userData));
          }
        });

        usuarios = loadedusers;
        notifyListeners();
      } else {
        print('Falha ao carregar dados: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao carregar usuários: $error');
      throw error;
    }
  }
}