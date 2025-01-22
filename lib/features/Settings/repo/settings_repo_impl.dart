import 'package:bizfns/core/common/Resource.dart';
import 'package:bizfns/features/Settings/repo/settings_repo.dart';

import '../../../core/common/Status.dart';
import '../../../core/utils/Utils.dart';

class SettingsRepoImpl extends SettingsRepo{
  SettingsRepoImpl({required super.apiClient});

  @override
  Future<Resource> addTaxTable({required String taxName, required String taxRate}) async{
    Utils().printMessage("here im");

    Resource data = await apiClient.addTaxTable(
      taxMasterName: taxName, 
      taxMasterRate: taxRate);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Tax added successfully");
    } else {
      Utils().printMessage("Tax added failed");
    }
    return data;
  }
  
}