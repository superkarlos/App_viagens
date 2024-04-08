import 'package:flutter/material.dart';
import 'package:ola_mundo/screens/tela_viagens_reservadas.dart';
import '../model/Destino.dart';
import '../main.dart';

class ShowDestino extends StatelessWidget {
  final Destino destino;
  final List<Destino> viagensReservadas;
  final double saldoUsuario;
  final Function(double) updateSaldoCallback;

  ShowDestino({
    required this.destino,
    required this.viagensReservadas,
    required this.saldoUsuario,
    required this.updateSaldoCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Destino'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  destino.url,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Nome do destino: ${destino.nome}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Preço da passagem: ${destino.preco}',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  reservarViagem(context, destino, viagensReservadas,
                      saldoUsuario, updateSaldoCallback);
                },
                child: Text('Reservar Viagem'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void reservarViagem(
    BuildContext context,
    Destino destino,
    List<Destino> viagensReservadas,
    double saldoUsuario,
    Function(double) callback) {
  if (saldoUsuario >= destino.preco) {
    // Reduzir o saldo do usuário
    saldoUsuario -= destino.preco;

    // Adicionar o destino à lista de viagens reservadas
    viagensReservadas.add(destino);

    // Chamar o callback para atualizar o saldo
    callback(saldoUsuario);

    // Voltar para a tela anterior
    Navigator.pop(context, true);
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Saldo Insuficiente'),
          content:
              Text('Você não tem saldo suficiente para reservar esta viagem.'),
          actions: [
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
