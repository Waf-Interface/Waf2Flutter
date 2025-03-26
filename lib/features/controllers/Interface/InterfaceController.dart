import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';

class InterfaceController extends GetxController {
  final HttpService _httpService = HttpService();

  RxList<Map<String, dynamic>> interfaces = <Map<String, dynamic>>[].obs;

  RxBool isLoading = false.obs;

  RxInt? sortColumnIndex = RxInt(0);
  RxBool isAscending = true.obs;

  @override
  void onInit() {
    fetchInterfaces();
    super.onInit();
  }

  Future<void> fetchInterfaces() async {
    try {
      isLoading.value = true;
      final response = await _httpService.listVirtualIps();
      interfaces.assignAll(response.map((vip) => {
        "#": vip['id'],
        "ip": vip['ip_address'],
        "interface": vip['interface'],
        "usedby": vip['domain'] ?? 'null',
        "status": vip['status'] == 'available' ? 'Available' : 'In Use',
      }).toList());
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch Interfaces: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addInterface({
    required String ipAddress,
    required String netmask,
    required String interface,
  }) async {
    try {
      isLoading.value = true;
      final response = await _httpService.addVirtualIp(
        ipAddress: ipAddress,
        netmask: netmask,
        interface: interface,
      );
      Get.snackbar('Success', 'Interface added successfully');
      await fetchInterfaces();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add Interface: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteInterface(int interfaceId) async {
    try {
      isLoading.value = true;
      await _httpService.deleteVirtualIp(interfaceId);
      Get.snackbar('Success', 'Interface deleted successfully');
      await fetchInterfaces();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete Interface: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> releaseInterface(int interfaceId) async {
    try {
      isLoading.value = true;
      await _httpService.releaseVirtualIp(interfaceId);
      Get.snackbar('Success', 'Interface released successfully');
      await fetchInterfaces();
    } catch (e) {
      Get.snackbar('Error', 'Failed to release Interface: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void sortData(int columnIndex, bool ascending) {
    sortColumnIndex?.value = columnIndex;
    isAscending.value = ascending;

    interfaces.sort((a, b) {
      switch (columnIndex) {
        case 0: // Sort by #
          return ascending ? a["#"].compareTo(b["#"]) : b["#"].compareTo(a["#"]);
        case 1: // Sort by IP
          return ascending ? a["ip"].compareTo(b["ip"]) : b["ip"].compareTo(a["ip"]);
        case 2: // Sort by Interface
          return ascending
              ? a["interface"].compareTo(b["interface"])
              : b["interface"].compareTo(a["interface"]);
        case 3: // Sort by Used By
          return ascending ? a["usedby"].compareTo(b["usedby"]) : b["usedby"].compareTo(a["usedby"]);
        case 4: // Sort by Status
          return ascending ? a["status"].compareTo(b["status"]) : b["status"].compareTo(a["status"]);
        default:
          return 0;
      }
    });
  }
}