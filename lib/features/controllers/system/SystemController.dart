import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';

class SystemController extends GetxController {
  final HttpService _httpService = HttpService();

  RxList<Map<String, dynamic>> networkInterfaces = RxList<Map<String, dynamic>>([]);
  RxList<dynamic> networkRoutes = RxList<dynamic>([]);
  RxString gatewayMessage = RxString('');
  RxBool isLoading = RxBool(false);
  RxString errorMessage = RxString('');

  Future<void> fetchNetworkInterfaces() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final interfacesMap = await _httpService.getNetworkInterfaces();
      final interfacesList = (interfacesMap as Map).entries.map((entry) {
        return {
          'name': entry.key,
          'addresses': entry.value,
          'address': (entry.value as List).firstWhere((addr) => addr.contains('.'), orElse: () => 'N/A'),
        };
      }).toList();
      networkInterfaces.assignAll(interfacesList);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNetworkRoutes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final routes = await _httpService.getNetworkRoutes();
      networkRoutes.assignAll(routes);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createGateway(String interfaceName) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _httpService.addGateway(interfaceName);
      gatewayMessage.value = response['message'] ?? 'Gateway added successfully';
      Get.snackbar('Success', gatewayMessage.value);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchNetworkInterfaces();
    fetchNetworkRoutes();
  }
}