import 'package:bizfns/core/route/RouteConstants.dart';
import 'package:bizfns/features/Admin/Create%20Job/api-client/schedule_api_client_implementation.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/add_schedule_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/auth/Login/model/login_otp_verification_model.dart';
import '../shared_pref/shared_pref.dart';

class ImageController {
  final _picker = ImagePicker();

  XFile? _xFile;

  AddScheduleModel model = AddScheduleModel.addSchedule;

  getImageFromCamera(String date, String slot) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();

    String companyID = loginData!.cOMPANYID!.toString();

    String tempID = "$companyID-$date-$slot";

    print("tempID================>>>>$tempID");

    _xFile = await _picker.pickImage(source: ImageSource.camera,imageQuality: 20,);

    // List<XFile> allImageList = [];

    // await ScheduleAPIClientImpl().addImage(
    //   image: _xFile!,
    // );

    if (model.images != null) {
      model.images!.add(_xFile!);
    } else {
      List<XFile> imageList = [];
      imageList.add(_xFile!);
      model.images = imageList;
    }
  }

  // getImageFromGallery(String date, String slot) async {

  //   OtpVerificationData? loginData = await GlobalHandler.getLoginData();

  //   String companyID = loginData!.cOMPANYID!.toString();

  //   String tempID = "$companyID-$date-$slot";

  //   print(tempID);

  //   List<XFile> images = await _picker.pickMultiImage();

  //   model.images!.addAll(images);
  // }

  getImageFromGallery(String date, String slot) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();

    String companyID = loginData!.cOMPANYID!.toString();

    String tempID = "$companyID-$date-$slot";

    print(tempID);

    // var y = await _picker.pickImage(source: ImageSource.gallery);
    List<XFile> images = [];
    // if (y != null) {
    //   images.add(y);
    // }

    List<XFile> _xFileArray = await _picker.pickMultiImage(
      imageQuality: 20,
    );

    print("_xFileArray=============$_xFileArray");
    // if (_xFile != null) {
    //   images.add(_xFile!);
    // }

    // if (_xFile != null) {
    // await ScheduleAPIClientImpl().addImage(
    //   image: _xFile!,
    //   tempJobID: tempID,
    // );
    print("picking from gallery========>$_xFile");
    // if (model.images != null) {
    if (model.images != null) {
      model.images!.addAll(_xFileArray);
    } else {
      model.images = (_xFileArray);
    }

    print("MOdel.images.length====>${model.images!.length}");
    // }
    //  else {
    //   List<XFile> imageList = [];
    //   imageList.add(_xFile!);
    //   model.images = imageList;
    //   // }
    // }

    // model.images?.add(_xFile!);
    // model.images?.addAll(images);

    // await ScheduleAPIClientImpl().addImage(
    //   image: _xFile!,
    //   tempJobID: tempID,
    // );
  }

  // pickProfileImageFromGallery() async {
  //   OtpVerificationData? loginData = await GlobalHandler.getLoginData();

  //   String companyID = loginData!.cOMPANYID!.toString();

  //   // String tempID = "$companyID-$date-$slot";

  //   // print(tempID);

  //   _xFile = await _picker.pickImage(source: ImageSource.gallery);
  // }

  pickProfileImageFromCamera() async {
    // OtpVerificationData? loginData = await GlobalHandler.getLoginData();

    // String companyID = loginData!.cOMPANYID!.toString();

    // String tempID = "$companyID-$date-$slot";

    // print("tempID================>>>>$tempID");

    _xFile = await _picker.pickImage(source: ImageSource.camera);

    // List<XFile> allImageList = [];

    // await ScheduleAPIClientImpl().addImage(
    //   image: _xFile!,
    // );

    // if (model.images != null) {
    //   model.images!.add(_xFile!);
    // } else {
    //   List<XFile> imageList = [];
    //   imageList.add(_xFile!);
    //   model.images = imageList;
    // }
  }

  deleteMedia(String mediaId) async {
    await ScheduleAPIClientImpl().deleteMedia(mediaId: mediaId);
  }
}
