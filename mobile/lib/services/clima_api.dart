import 'dart:convert';
import 'package:http/http.dart' as http;

class ClimaApi {
  static const baseUrl = 'http://192.168.15.19:3000'; 
  

  static Future<Map<String, dynamic>> buscarClima(String cidade) async {
    final url = Uri.parse('$baseUrl/clima?cidade=$cidade');
    final resp = await http.get(url).timeout(Duration(seconds: 10));
    if (resp.statusCode != 200) throw 'Erro HTTP: ${resp.statusCode}';
    final json = jsonDecode(resp.body);
    return Map<String, dynamic>.from(json);
  }
}
