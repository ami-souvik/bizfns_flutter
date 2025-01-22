import 'package:image_picker/image_picker.dart';

import '../../../core/common/Resource.dart';
import 'profile_api_client_implementation.dart';

abstract class ProfileRepo {
  final ProfileApiClientImpl apiClient;

  ProfileRepo({required this.apiClient});

  Future<Resource> getProfile();
  Future<Resource> setProfile(
      {required String businessName,
      required String businessLogo,
      required String marketingDescription,
      required List<String> addLocation,
      required String address,
      required String businessContactPerson,
      required String trustedBackupMobileNumber,
      required String trustedBackupEmail,
      required String businessEmail});
  Future<Resource> uploadBusinessLogo({required XFile image});
  // Future<Resource> verifyPassword({required String password});
  Future<Resource> getOtpForMobileChanges();
  Future<Resource> saveChangesMobile({required String newMobileNumber,required String otp});
}
