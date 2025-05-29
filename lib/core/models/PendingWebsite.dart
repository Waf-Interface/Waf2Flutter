import 'package:get/get.dart';

class PendingWebsite {
  String name;
  String url;
  RxString deploymentStatus;

  PendingWebsite({
    required this.name,
    required this.url,
    String initialStatus = 'Waiting for zip',
  }) : deploymentStatus = initialStatus.obs;
}