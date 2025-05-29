import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';

class UserController extends GetxController {
  final HttpService _httpService = HttpService();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    fetchActiveUsers();
  }

  RxList<Map<String, dynamic>> users = RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> activeUsers = RxList<Map<String, dynamic>>([]);
  RxBool isLoading = RxBool(false);
  RxString errorMessage = RxString('');
  RxString successMessage = RxString('');
  RxInt? sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final usersList = await _httpService.getUsers();
      users.assignAll(usersList.cast<Map<String, dynamic>>());
    } catch (e) {
      errorMessage.value = e.toString();
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchActiveUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final activeUsersList = await _httpService.getActiveUsers();
      activeUsers.assignAll(activeUsersList);
    } catch (e) {
      errorMessage.value = e.toString();
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String rule,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final newUser = await _httpService.createUser(
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
        email: email,
        rule: rule,
      );
      users.add(newUser);
      successMessage.value = 'User created successfully';
      Get.snackbar('Success', successMessage.value);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser({
    required int userId,
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String rule,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final updatedUser = await _httpService.updateUser(
        userId: userId,
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
        rule: rule,
      );
      final index = users.indexWhere((user) => user['id'] == userId);
      if (index != -1) {
        users[index] = updatedUser;
      }
      successMessage.value = 'User updated successfully';
      Get.snackbar('Success', successMessage.value);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _httpService.deleteUser(userId);
      users.removeWhere((user) => user['id'] == userId);
      successMessage.value = 'User deleted successfully';
      Get.snackbar('Success', successMessage.value);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteActiveUser(int accessId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _httpService.deleteActiveUser(accessId);
      activeUsers.removeWhere((activeUser) => activeUser['id'] == accessId);
      successMessage.value = 'Active user deleted successfully';
      Get.snackbar('Success', successMessage.value);
      await fetchActiveUsers();
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void sortData(int columnIndex, bool ascending) {
    sortColumnIndex?.value = columnIndex;
    isAscending.value = ascending;

    activeUsers.sort((a, b) {
      switch (columnIndex) {
        case 0: // Sort by index (#)
          return ascending
              ? activeUsers.indexOf(a).compareTo(activeUsers.indexOf(b))
              : activeUsers.indexOf(b).compareTo(activeUsers.indexOf(a));
        case 1: // Sort by Username
          return ascending
              ? (a['username'] ?? '').compareTo(b['username'] ?? '')
              : (b['username'] ?? '').compareTo(a['username'] ?? '');
        case 2: // Sort by Rule
          return ascending
              ? (a['rule'] ?? '').compareTo(b['rule'] ?? '')
              : (b['rule'] ?? '').compareTo(a['rule'] ?? '');
        default:
          return 0;
      }
    });
  }
}