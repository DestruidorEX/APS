import 'package:flutter/material.dart';
import '../services/clima_api.dart';
import 'detalhes_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController(text: 'sao-paulo');
  bool _loading = false;
  Map<String, dynamic>? dados;

  void buscar() async {
    setState(() { _loading = true; dados = null; });
    final cidade = _controller.text.trim().toLowerCase();
    try {
      final resp = await ClimaApi.buscarClima(cidade);
      setState(() { dados = resp; });
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DetalhesScreen(dados: resp)
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('APS - Monitoramento Climático')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Cidade (ex: sao-paulo)'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : buscar,
              child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Buscar'),
            ),
            SizedBox(height: 20),
            if (dados != null) ...[
              Text('Última consulta: ${dados!['hora_atualizacao'] ?? ''}'),
              SizedBox(height: 8),
              Text('Temperatura: ${dados!['temperatura']} °C'),
            ]
          ],
        ),
      ),
    );
  }
}
