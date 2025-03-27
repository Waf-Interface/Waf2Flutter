import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';

class UpdateController extends GetxController {
  HttpService httpService = HttpService();

  var updateStatus = {}.obs;
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpdateStatus();
  }

  Future<void> fetchUpdateStatus() async {
    try {
      isLoading.value = true;
      error.value = '';
      print('Fetching update status...');
      final result = await httpService.checkUpdateStatus();
      print('Raw API response: $result');
      if (result.isNotEmpty) {
        updateStatus.value = result;
        print('Update status set to: ${updateStatus.value}');
      } else {
        print('Received empty result from API');
        updateStatus.value = {};
      }
    } catch (e) {
      error.value = e.toString();
      print('Error fetching update status: $e');
      updateStatus.value = {};
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCrs() async {
    try {
      isLoading.value = true;
      error.value = '';
      print('Updating CRS...');
      final result = await httpService.updateCrs();
      print('CRS update result: $result');
      if (updateStatus.value.containsKey('modules')) {
        updateStatus.value['modules']['crs']['current'] = result['new_version'] ?? 'unknown';
        updateStatus.value['modules']['crs']['needs_update'] = false;
        updateStatus.refresh();
        print('Updated CRS status: ${updateStatus.value}');
      }
    } catch (e) {
      error.value = e.toString();
      print('Error updating CRS: $e');
    } finally {
      isLoading.value = false;
    }
  }
}