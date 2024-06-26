import 'package:flutter/material.dart';

class Destino with ChangeNotifier {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final String imagemUrl;
  bool isFavorite;

  Destino({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagemUrl,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  factory Destino.fromJson(Map<String, dynamic> json) {
    return Destino(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      preco: (json['preco'] ?? 0.0).toDouble(),
      imagemUrl: json['imagemUrl'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nome": nome,
      "descricao": descricao,
      "preco": preco,
      "imagemUrl": imagemUrl,
      "isFavorite": isFavorite,
    };
  }
}
