import 'package:bizfns/core/common/Resource.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/common/Status.dart';
import '../../../core/utils/Utils.dart';
import 'profile_repo.dart';

class ProfileRepoImplementation extends ProfileRepo {
  ProfileRepoImplementation({required super.apiClient});

  @override
  Future<Resource> getProfile() async {
    Utils().printMessage("here im getting profile ");
    Resource data = await apiClient.getProfile();
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Get Profile is successful");
    } else {
      Utils().printMessage("Can not fetch Profile Data");
    }
    return data;
  }

  @override
  Future<Resource> setProfile(
      {required String businessName,
      required String businessLogo,
      required String marketingDescription,
      required List<String> addLocation,
      required String address,
      required String businessContactPerson,
      required String trustedBackupMobileNumber,
      required String trustedBackupEmail,
      required String businessEmail}) async {
    Utils().printMessage("here im setting profile ");
    Resource data = await apiClient.setProfile(
        businessName: businessName,
        businessLogo: businessLogo,
        marketingDescription: marketingDescription,
        addLocation: addLocation,
        address: address,
        businessContactPerson: businessContactPerson,
        trustedBackupMobileNumber: trustedBackupMobileNumber,
        trustedBackupEmail: trustedBackupEmail,
        businessEmail: businessEmail);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Schedule List fetch is successful");
    } else {
      Utils().printMessage("Can not fetch schedule list");
    }
    return data;
  }

  @override
  Future<Resource> uploadBusinessLogo({required XFile? image}) async {
    Resource data = await apiClient.uploadBusinessLogo(image: image);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Profile Updated successfullu");
    } else {
      Utils().printMessage("Can not upload");
    }
    return data;
  }

  @override
  Future<Resource> verifyPassword({required String password}) async {
    Resource data = await apiClient.verifyPassword(password: password);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Password Verified successfully");
    } else {
      Utils().printMessage("Password Verification failed");
    }
    return data;
  }

  @override
  Future<Resource> getOtpForMobileChanges() async {
    Resource data = await apiClient.getOtpForMobileChanges();
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Otp sent successfully");
    } else {
      Utils().printMessage("varification failed");
    }
    return data;
  }
  
  @override
  Future<Resource> saveChangesMobile({required String newMobileNumber,required String otp}) async{
    Resource data = await apiClient.saveChangesMobile(newMobileNumber: newMobileNumber, otp: otp);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Otp sent successfully");
    } else {
      Utils().printMessage("varification failed");
    }
    return data;
  }
}
