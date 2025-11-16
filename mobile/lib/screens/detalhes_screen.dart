import 'package:flutter/material.dart';

class DetalhesScreen extends StatelessWidget {
  final Map<String, dynamic> dados;
  DetalhesScreen({required this.dados});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> alertas = dados['alertas'] ?? [];
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes - ${dados['cidade']}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Temperatura: ${dados['temperatura']} °C', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Vento: ${dados['vento']} km/h', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Umidade: ${dados['umidade'] ?? "N/D"} %', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text('Alertas:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...alertas.map((a) => ListTile(leading: Icon(Icons.warning), title: Text(a))).toList()
          ],
        ),
      ),
    );
  }
}
