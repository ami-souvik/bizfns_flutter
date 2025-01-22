import '../../../core/common/Resource.dart';
import '../data/settings_api_client.dart';

abstract class SettingsRepo {
  final SettingsApiClientImpl apiClient;
  SettingsRepo({required this.apiClient});

  Future<Resource> addTaxTable(
      {required String taxName, required String taxRate});
}
