import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msf/core/services/unit/api/HttpService.dart';
import '../../config/Config.dart';

class UpdateHttpService {

  //Fixing error late init..
  late HttpService _httpService;
  void setHttpService(HttpService service) {
    _httpService = service;
  }


  Future<Map<String, dynamic>> checkUpdateStatus() async {
    final url = Uri.parse('${Config.httpAddress}/update/api/update/check');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${_httpService.accessToken}',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch update status');
    }
  }

  Future<Map<String, dynamic>> updateCrs() async {
    final url = Uri.parse('${Config.httpAddress}/update/api/update/crs');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${_httpService.accessToken}',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update CRS');
    }
  }
}
