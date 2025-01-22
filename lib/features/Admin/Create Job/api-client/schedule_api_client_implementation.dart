import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/core/route/RouteConstants.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/JobScheduleModel/job_schedule_response_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/JobScheduleModel/schedule_list_response_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/add_schedule_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/service_entity_question_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/api_helper/api_helper.dart';
import '../../../../core/common/Resource.dart';
import '../../../../core/common/Status.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../../core/utils/const.dart';
import '../../../../provider/job_schedule_controller.dart';
import '../../../auth/Login/model/login_otp_verification_model.dart';
import '../model/add_tax_response_model.dart';
import '../model/all_pdf_list_model.dart';
import '../model/create_invoice_pdf_model.dart';
import '../model/customer_service_history_model.dart';
import '../model/get_edit_invoice_model.dart';
import '../model/get_status_model.dart';
import '../model/invoiced_customer_model.dart';
import '../model/tax_model.dart';

class ScheduleAPIClientImpl {
  AddScheduleModel model = AddScheduleModel.addSchedule;

  Future<Resource> getScheduleList({required String date}) async {
    try {
      Utils().printMessage("here im");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      Utils().printMessage("here im");
      var body = {
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2],
        "tenantId": loginData!.tenantId,
        "userId": userId,
        "fromDate":
            date.contains(' ') ? date.split(' ')[0] : date, //"2023-08-22",
      };

      Utils().printMessage("GET_SCHEDULE_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.GET_SCHEDULE_LIST,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});

      log('Response: ${jsonEncode(response.data)}');

      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            Map<String, dynamic> data = response.data as Map<String, dynamic>;

            ScheduleListResponseModel resp =
                ScheduleListResponseModel.fromJson(data);

            return Resource(
                status: STATUS.SUCCESS,
                data: resp,
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e, stackTrace) {
        Utils().printMessage('Catch Error $e $stackTrace');
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e, stackTrace) {
      Utils().printMessage(stackTrace.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> getJobStatus({required Map<String, dynamic> data}) async {
    try {
      Utils().printMessage("here im getting JobStatus");
      Utils().printMessage("here im");
      var body = data;

      var value = jsonEncode(data);

      Utils().printMessage("GET_JOB_STATUS_BODY==>${jsonEncode(data)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.GET_JOB_STATUS,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            Map<String, dynamic> data = response.data as Map<String, dynamic>;

            GetJobStatusResponse resp = GetJobStatusResponse.fromJson(data);

            return Resource(
                status: STATUS.SUCCESS,
                data: resp,
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> saveJobStatus({required Map<String, dynamic> data}) async {
    try {
      Utils().printMessage("here im savingg JobStatus");
      Utils().printMessage("here im");
      var body = data;

      var value = jsonEncode(data);

      Utils().printMessage("SAVE_JOB_STATUS_BODY==>${jsonEncode(data)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.SAVE_JOB_STATUS,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            Map<String, dynamic> data = response.data as Map<String, dynamic>;

            GetJobStatusResponse resp = GetJobStatusResponse.fromJson(data);

            return Resource(
                status: STATUS.SUCCESS,
                data: resp,
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> addSchedule({required Map<String, dynamic> data}) async {
    try {
      Utils().printMessage("here im adding schedule");
      Utils().printMessage("here im");
      var body = data;

      var value = jsonEncode(data);

      log("ADD_SCHEDULE_BODY==>${jsonEncode(data)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.ADD_SCHEDULE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            Map<String, dynamic> data = response.data as Map<String, dynamic>;

            ScheduleListResponse resp = ScheduleListResponse.fromJson(data);

            return Resource(
                status: STATUS.SUCCESS,
                data: resp,
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> addImage({
    required List<XFile> image,
  }) async {
    try {
      Utils().printMessage("here im adding images");
      Utils().printMessage("here im");

      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      List allFiles = [];
      for (var i = 0; i < image.length; i++) {
        var file = MultipartFile.fromFileSync(
          image[i].path,
          filename: '$timestamp-${image[i].name}',
        );
        allFiles.add(file);
      }

      final formData = FormData.fromMap({
        'Pkjobid': '0',
        'tenantId': loginData!.tenantId,
        'file': allFiles,
        'auditId': ''
      });

      print("FormData value=====>$formData");

      String? token = await GlobalHandler.getToken();
      if (token == null) {
        token = loginData.token ?? "";
        await GlobalHandler.setToken(token);
      }

      var response = await ApiHelper().apiCallForImage(
          url: Urls.SAVE_JOB_IMAGE,
          body: formData,
          header: {"Authorization": "Bearer $token"});
      try {
        Utils().printMessage(response.data.toString());
        // if (response != null && response.status == STATUS.SUCCESS) {
        // if (response.data["success"] == true) {
        // Map<String, dynamic> data = response.data as Map<String, dynamic>;
        print(
            "imageSuccessMEssage====================>${response.data['message']}");
        print("imageId====================>${response.data['data']}");
        log("previous model.imageId value---->${model.imageId}");

        // model!.copyImages!.addAll(response.data['data'].toString().split(',').toList())

        //
        model.imageId = model.imageId.isNotEmpty
            ? model.imageId + ',' + response.data['data'].toString()
            : response.data['data'].toString();

        // if (model.imageId.isNotEmpty) {
        //   String a = model.imageId;
        //   // String b = "$a,${}";
        //   // model.imageId = b;
        // } else {
        //   model.imageId = response.data['data'].toString();
        // }
        print("model.imageId==============>${model.imageId}");

        return Resource(
            status: STATUS.SUCCESS,
            data: response,
            message: response.data["message"]);
        // } else {
        //   return Resource.error(message: response.data["message"].toString());
        // }
        // } else {
        //   if (response.data.toString() == "403") {
        //     return Resource.error(message: TOKEN_EXPIRED);
        //   } else {
        //     return Resource.error(message: response.message);
        //   }
        // }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> deleteMedia({
    required String mediaId,
  }) async {
    try {
      Utils().printMessage("here im deleting images");
      Utils().printMessage("here im");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();

      log("mideia id in delete api --->$mediaId");

      var body = {"tenantId": loginData!.tenantId, "mediaId": mediaId};

      print("delete body --------->$body");

      String? token = await GlobalHandler.getToken();
      if (token == null) {
        token = loginData!.token ?? "";
        await GlobalHandler.setToken(token);
      }

      var response = await ApiHelper().deleteImage(
          url: Urls.DELETE_MEDIA_FILE,
          body: body,
          header: {"Authorization": "Bearer $token"});
      try {
        Utils().printMessage(response.data.toString());
        // if (response != null && response.status == STATUS.SUCCESS) {
        // if (response.data["success"] == true) {
        // Map<String, dynamic> data = response.data as Map<String, dynamic>;
        print(
            "deleteImageData====================>${response.data['message']}");
        // model.imageId = response.data['data'].toString();

        return Resource(
            status: STATUS.SUCCESS,
            data: response,
            message: response.data["message"]);
        // } else {
        //   return Resource.error(message: response.data["message"].toString());
        // }
        // } else {
        //   if (response.data.toString() == "403") {
        //     return Resource.error(message: TOKEN_EXPIRED);
        //   } else {
        //     return Resource.error(message: response.message);
        //   }
        // }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> editSchedule({required Map<String, dynamic> data}) async {
    try {
      Utils().printMessage("here im editing schedule");
      Utils().printMessage("here im");
      var body = data;

      Utils().printMessage("EDIT_SCHEDULE_BODY==>${jsonEncode(data)}");

      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.EDIT_SCHEDULE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      try {
        Utils().printMessage('Rsposne: ${response.data}');
        if (response.status == STATUS.SUCCESS) {
          print(
              "response.data[success]------------>${response.data["success"]}");
          if (response.data["success"] == true) {
            /*Map<String,dynamic> data = response.data as Map<String,dynamic>;

            ScheduleListResponse resp = ScheduleListResponse.fromJson(data);*/

            return Resource(
                status: STATUS.SUCCESS,
                data: '',
                message: response.data["message"]);
          } else {
            return Resource(
                status: STATUS.ERROR,
                data: '',
                message: response.data["message"]);
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> reSchedule(
      {required String jobID,
      required String startTime,
      required String endTime}) async {
    try {
      Utils().printMessage("here im re-schedule");

      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      Utils().printMessage("here im");

      Map<String, dynamic> data = {
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2],
        "tenantId": loginData!.tenantId,
        "userId": userId,
        "jobId": jobID,
        "startTime": startTime,
        "endTime": endTime,
      };

      Utils().printMessage("RE_SCHEDULE_BODY==>${jsonEncode(data)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.RE_SCHEDULE,
          body: data,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      try {
        Utils().printMessage('Edit Response: ${response.data}');
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            return Resource(
                status: STATUS.SUCCESS,
                data: data,
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> deleteSchedule({required Map<String, dynamic> data}) async {
    try {
      Utils().printMessage("here im delete schedule");
      Utils().printMessage("here im");
      var body = data;

      Utils().printMessage("DELETE_SCHEDULE_BODY==>${jsonEncode(data)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.DELETE_SCHEDULE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      try {
        Utils().printMessage('Rsposne: ${response.data}');
        // if (response != null && response.status == STATUS.SUCCESS) {
        //   if (response.data["success"] == true) {
        /*Map<String,dynamic> data = response.data as Map<String,dynamic>;

            ScheduleListResponse resp = ScheduleListResponse.fromJson(data);*/

        return Resource(
            status: STATUS.SUCCESS,
            data: '',
            message: response.data["message"]);
        // } else {
        //   return Resource.error(message: response.data["message"].toString());
        // }
        // } else {
        //   if (response.data.toString() == "403") {
        //     return Resource.error(message: TOKEN_EXPIRED);
        //   } else {
        //     return Resource.error(message: response.message);
        //   }
        // }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> getServiceEntityQuestion() async {
    try {
      Utils().printMessage("here im getting service entity questions ");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      Utils().printMessage("here im getting service entity question");
      var body = {
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2],
        "tenantId": loginData!.tenantId,
        "compId": loginData.cOMPANYID!.toString(),
      };

      Utils().printMessage("GET_SERVICE_ENTITY_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();

      ServiceEntityQuestionModel resp =
          ServiceEntityQuestionModel.fromJson(entityData);

      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.SERVICE_ENIITY,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});

      var responseData = response.data;

      Utils().printMessage(json.encode(response.data));
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          log("service entity resp : ${jsonEncode(response.data)}");
          Map<String, dynamic> data = response.data as Map<String, dynamic>;

          ServiceEntityQuestionModel resp =
              ServiceEntityQuestionModel.fromJson(data);

          return Resource(
              status: STATUS.SUCCESS,
              data: resp,
              message: response.data["message"]);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> getServiceEntityDetails(
      {String? customerID, String? serviceEntityID}) async {
    try {
      Utils().printMessage("here im getting service entity questions ");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      Utils().printMessage("here im getting service entity question");
      var body = {
        // "deviceId": deviceDetails[0],
        // "deviceType": deviceDetails[1],
        // "appVersion": deviceDetails[2],
        // "tenantId": loginData!.tenantId,
        // "compId": loginData.cOMPANYID!.toString(),
        // "userId": loginData.userTypeId!.toString(),
        // "customer_id": customerID,
        // "service_entity_id": serviceEntityID,
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2],
        "userId": userId,
        "tenantId": loginData!.tenantId,
        "customer_id": customerID,
        "service_entity_id": serviceEntityID,
        "compId": loginData.cOMPANYID!.toString()
      };

      log("GET_SERVICE_ENTITY_DETAILS==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();

      ServiceEntityQuestionModel resp =
          ServiceEntityQuestionModel.fromJson(entityData);

      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      Utils().printMessage('Body: $body');
      var response = await ApiHelper().apiCall(
          url: Urls.SERVICE_ENTITY_DETAILS,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});

      var responseData = response.data;

      Utils().printMessage(json.encode(response.data));
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;

          ServiceEntityQuestionModel resp =
              ServiceEntityQuestionModel.fromJson(data);

          return Resource(
              status: STATUS.SUCCESS,
              data: resp,
              message: response.data["message"]);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> generateInvoice({required String jobID}) async {
    try {
      Utils().printMessage("here im generating invoice");
      Utils().printMessage("here im");

      OtpVerificationData? loginData = await GlobalHandler.getLoginData();

      var body = {
        "jobid": jobID,
        "tenantId": loginData!.tenantId,
      };

      print(body);

      String? token = await GlobalHandler.getToken();
      if (token == null) {
        token = loginData.token ?? "";
        await GlobalHandler.setToken(token);
      }

      var response = await ApiHelper().apiCall(
          url: Urls.GET_JOB_PRICE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});

      var invoiceRequest = response.data['data'];

      print('INvoice Request: ' + invoiceRequest.toString());

      print(response.data);

      var invoiceResponse = await ApiHelper().apiCall(
          url: Urls.CREATE_INVOICE,
          body: invoiceRequest,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});

      print('Invoice Response$invoiceResponse');

      try {
        Utils().printMessage(response.data.toString());
        if (invoiceResponse != null
            // &&
            //     invoiceResponse.status == STATUS.SUCCESS
            ) {
          // if (invoiceResponse.data["success"] == true) {
          Map<String, dynamic> data =
              invoiceResponse.data as Map<String, dynamic>;
          AllPdfListModel resp = AllPdfListModel.fromJson(data);
          print(
              "invoiceeeeeeeeeeeeeeeeeeeeeeeee datttttttttttttttttttttttt==============>$data");
          return Resource(
            status: STATUS.SUCCESS,
            data: resp,
            message: response.data["message"],
          );
          // } else {
          //   return Resource.error(message: response.data["message"].toString());
          // }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: invoiceResponse.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: invoiceResponse.message);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  String convertTimeFormatWhileAdding(String timeString) {
    log("convertTimeFormatWhileAdding calling");
    log("Getting timeString : ${timeString}");
    // log("isEdit WhileAdding: ${addScheduleModel!.isEdit}");
    // Parse the input time string
    DateTime parsedTime;

    // Check if the time string contains seconds
    if (timeString.contains(':00:00')) {
      // Parse the input time string with seconds
      parsedTime = DateFormat('hh:mm:ss a').parseLoose(timeString);
    } else {
      // Parse the input time string without seconds
      parsedTime = DateFormat('hh:mm a').parseLoose(timeString);
    }

    // Format the time as 'HH:mm' (24-hour format)
    String formattedTime = DateFormat('HH:mm').format(parsedTime);

    return formattedTime;
  }

  Future<Resource> getRecurrDate() async {
    try {
      Utils().printMessage("here im getting recur dates");
      Utils().printMessage("here im");

      OtpVerificationData? loginData = await GlobalHandler.getLoginData();

      AddScheduleModel model = AddScheduleModel.addSchedule;

      String difference = model.recurrType == "Daily"
          ? "1"
          : model.recurrType == "Weekly"
              ? "7"
              : model.recurrType == "Monthly"
                  ? "30"
                  : "365";

      String recurrType = model.recurrType == "Daily"
          ? "Day"
          : model.recurrType == "Weekly"
              ? "Week"
              : model.recurrType == "Monthly"
                  ? "Month"
                  : "Year";

      var body = {
        "startDate": model.startDate!.split(' ')[0],
        "startTime": convertTimeFormatWhileAdding(model.startTime!),
        "endDate": model.endDate!.split(' ')[0],
        "endTime": convertTimeFormatWhileAdding(model.endTime!),
        "jobstopdate": model.jobStopDate!.split(' ')[0],
        "DurationOfrecurr": difference,
        "Numberofrecurr": model.totalJobs,
        "recurrType": recurrType,
        "weekNumber": model.weekNumber ?? "0",
        "tanentId": loginData!.tenantId,
      };

      print("recurJsonBody=============>${jsonEncode(body)}");

      String? token = await GlobalHandler.getToken();
      if (token == null) {
        token = loginData!.token ?? "";
        await GlobalHandler.setToken(token);
      }

      var response = await ApiHelper().apiCall(
          url: Urls.RECCURR_DATE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});

      print(response);

      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            Map<String, dynamic> data = response.data as Map<String, dynamic>;
            return Resource(
              status: STATUS.SUCCESS,
              data: data,
              message: response.data["message"],
            );
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> getStaffValidation(
      {required List recurDateList, required BuildContext context}) async {
    try {
      Utils().printMessage("here im validating staff");
      Utils().printMessage("here im");

      OtpVerificationData? loginData = await GlobalHandler.getLoginData();

      AddScheduleModel model = AddScheduleModel.addSchedule;

      // print(
      //     "last date bro---->${Provider.of<JobScheduleProvider>(context, listen: false).reccurrDateList.last.endTime}");
      // print("end day bro------------>${model.endDate!.split(' ')[0]}");
      print("model.startDate!------------>${model.startDate}");
      String startDate = model.startDate!.split(' ')[0];
      print("startDate------------->${startDate}");

      int day = int.parse(startDate.split('-')[2]);
      String sDay = day < 10 ? "0$day" : day.toString();

      String sDate =
          '${startDate.split('-')[0]}-${startDate.split('-')[1]}-$sDay';
      String endDate = model.endDate!.split(' ')[0];
      print("endDate------------->${endDate}");
      // String endDate = Provider.of<JobScheduleProvider>(context, listen: false).reccurrDateList.last.endTime!.split(' ')[0];

      int day1 = int.parse(endDate.split('-')[2]);
      String eDay = day1 < 10 ? "0$day1" : day1.toString();

      // String eDate = '${endDate.split('-')[0]}-${endDate.split('-')[1]}-$eDay';
      String eDate = '${endDate.split('-')[0]}-${endDate.split('-')[1]}-$eDay';
      ;

      var body = {
        "startDate": sDate, //get staff details startDate
        "endDate": eDate, //get staff details endDate
        "tenantId": loginData!.tenantId, // tanent Id
        "staffId": model.staffList!.map((e) => e.id!).toList(), //staff Id
        "currentRecurrDate": recurDateList,
        "jobId": model.jobId ?? ""
      };

      log("getStuffVaidationBody----->${jsonEncode(body)}");

      String? token = await GlobalHandler.getToken();
      if (token == null) {
        token = loginData!.token ?? "";
        await GlobalHandler.setToken(token);
      }

      var response = await ApiHelper().apiCall(
          url: Urls.STAFF_VALIDATION,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});

      print(response.data);

      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          // if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;
          return Resource(
            status: STATUS.SUCCESS,
            data: data,
            message: response.data["message"],
          );
          // } else {
          //   return Resource.error(message: response.data["message"].toString());
          // }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> createServiceEntity(String customerID) async {
    AddScheduleModel _model = AddScheduleModel.addSchedule;

    try {
      Utils().printMessage("here im getting service entity questions ");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      Utils().printMessage("here im getting service entity question");
      var body = {
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2],
        "tenantId": loginData!.tenantId,
        "compId": loginData.cOMPANYID!.toString(),
        "customer_id": customerID,
        "questionData": _model.serviceEntity!['data'],
      };

      log("ADD_SERVICE_ENTITY_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();

      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.ADD_SERVICE_ENTIYTY,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      log("after api calling gettng the data----->${json.encode(response.data)}");
      Utils().printMessage(json.encode(response.data));
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: '',
              message: response.data["message"]);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage('Service Entity Error: $e');
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //---------------------UPDATE-SERVICE-ENTITY--------------------//
  Future<Resource> editServiceEntity({
    required String customerID,
    required String serviceEntityId,
  }) async {
    AddScheduleModel _model = AddScheduleModel.addSchedule;

    try {
      Utils().printMessage("here im getting service entity questions ");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      Utils().printMessage("here im getting service entity question");
      var body = {
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2],
        "userId": userId,
        "tenantId": loginData!.tenantId,
        // "compId": loginData.cOMPANYID!.toString(),
        "customer_id": customerID,
        "service_Entity_Id": serviceEntityId,
        "service_entity_items": _model.serviceEntity!['data'],
      };

      log("EDIT_SERVICE_ENTITY_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();

      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.EDIT_SERVICE_ENTITY,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      log("after api calling gettng the data----->${json.encode(response.data)}");
      Utils().printMessage(json.encode(response.data));
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: '',
              message: response.data["message"]);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage('Service Entity Error: $e');
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //---------------------DELETE-SERVICE-OBJECT---------------------//
  Future<Resource> deleteServiceEntity({
    required String customerID,
    required String serviceEntityId,
  }) async {
    AddScheduleModel _model = AddScheduleModel.addSchedule;

    try {
      Utils().printMessage("here im Deleting service entity");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      Utils().printMessage("here im Deleting service entity");
      // var body = {
      //   "deviceId": deviceDetails[0],
      //   "deviceType": deviceDetails[1],
      //   "appVersion": deviceDetails[2],
      //   "userId": userId,
      //   "tenantId": loginData!.tenantId,
      //   // "compId": loginData.cOMPANYID!.toString(),
      //   "customer_id": customerID,
      //   "service_Entity_Id": serviceEntityId,
      //   "service_entity_items": _model.serviceEntity!['data'],
      // };
      var body = {
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2],
        "userId": userId,
        "tenantId": loginData!.tenantId,
        "customer_id": customerID,
        "service_entity_id": serviceEntityId,
        "compId": loginData!.cOMPANYID.toString()
      };

      log("DELETE_SERVICE_ENTITY_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();

      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.DELETE_SERVICE_ENTITY,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      log("after api calling DELETING the data----->${json.encode(response.data)}");
      Utils().printMessage(json.encode(response.data));
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: '',
              message: response.data["message"]);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage('Service Entity Error: $e');
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future getCustomerServiceHistory({required Map<String, dynamic> data}) async {
    try {
      Utils().printMessage("here im getting customer History");
      var body = data;

      var value = jsonEncode(data);

      Utils()
          .printMessage("GETTING_CUSTOMER_HISTORY_BODY==>${jsonEncode(data)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.GET_CUSTOMER_SERVICE_HISTORY,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            List<Map<String, dynamic>> flattenedJobs = [];
            for (var customerJobs in response.data['data']) {
              for (var jobData in customerJobs) {
                flattenedJobs.addAll(
                    (jobData['jobs'] as List).cast<Map<String, dynamic>>());
              }
            }
            log("======>${(flattenedJobs)}");
            return flattenedJobs;
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future getTaxTable() async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      var body = {"tenantId": loginData!.tenantId, "userId": userId};
      log("GET-getTaxTable_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      var response = await ApiHelper().apiCall(
          url: Urls.GET_TAX_TABLE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      log("TAX TABLERESPONSE -- ${jsonEncode(response.toString())}");
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;

          TaxModel resp = TaxModel.fromJson(data);
          return Resource(
              status: STATUS.SUCCESS,
              data: resp,
              message: response.data["message"]);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

// }

  Future<Resource> addTaxTable(
      {required String taxMasterName, required String taxMasterRate}) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      var body = {
        "tenantId": loginData!.tenantId,
        "userId": userId,
        "taxMasterName": taxMasterName,
        "taxMasterRate": taxMasterRate
      };
      log("ADD-TAX BODY ===> ${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.ADD_TAX_TABLE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;
          AddTaxResponseModel resp = AddTaxResponseModel.fromJson(data);
          return Resource(
              status: STATUS.SUCCESS,
              data: resp,
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> updateTaxTable(
      {required Map<String, dynamic> taxUpdates}) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      // var body = {
      //   "tenantId": loginData!.tenantId,
      //   "userId": userId,
      //   "taxMasterName": taxMasterName,
      //   "taxMasterRate": taxMasterRate
      // };
      var body = {
        "tenantId": loginData!.tenantId,
        "userId": userId,
        "taxUpdates": [taxUpdates]
      };
      log("UPDATE-TAX BODY ===> ${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.UPDATE_TAX_TABLE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;
          AddTaxResponseModel resp = AddTaxResponseModel.fromJson(data);
          return Resource(
              status: STATUS.SUCCESS,
              data: resp,
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> deleteTaxTable({required String taxTypeId}) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      // var body = {
      //   "tenantId": loginData!.tenantId,
      //   "userId": userId,
      //   "taxMasterName": taxMasterName,
      //   "taxMasterRate": taxMasterRate
      // };
      var body = {
        "tenantId": loginData!.tenantId,
        "userId": userId,
        "taxTypeId": taxTypeId
      };
      log("DELETE-TAX BODY ===> ${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.DELETE_TAX_TABLE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          // Map<String, dynamic> data = response.data as Map<String, dynamic>;
          // AddTaxResponseModel resp = AddTaxResponseModel.fromJson(data);
          return Resource(
              status: STATUS.SUCCESS,
              data: response.data['data'],
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> getEditInvoice(
      {required String jobId, required List<int> customerIds}) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      var body = {
        "TenantId": loginData!.tenantId,
        "UserId": userId,
        "JobId": jobId,
        "CustomerIds": customerIds
      };
      Utils().printMessage("GET-EDIT_INVOICE_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.GET_EDIT_INVOICE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      log("RESPONSE -- ${jsonEncode(response.toString())}");
      // Map<String, dynamic> data = response.data as Map<String, dynamic>;
      // GetEditInvoiceModel resp = GetEditInvoiceModel.fromJson(data);
      return Resource(
          status: STATUS.SUCCESS, data: response.data, message: 'message');
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //--------------------save-edit-invoice-------------------//
  Future<Resource> saveEditInvoice(
      {required Map<String, dynamic> saveEditJson}) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      Utils()
          .printMessage("SAVE-EDIT_INVOICE_BODY==>${jsonEncode(saveEditJson)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.SAVE_INVOICE,
          body: saveEditJson,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      log("RESPONSE -- ${jsonEncode(response.toString())}");
      // Map<String, dynamic> data = response.data as Map<String, dynamic>;
      // GetEditInvoiceModel resp = GetEditInvoiceModel.fromJson(data);
      return Resource(
          status: STATUS.SUCCESS,
          data: response.data,
          message: response.data['message']);
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //------------------------UPDATE-INVOICE-----------------------//
  Future<Resource> updateInvoice(
      {required Map<String, dynamic> updateJson}) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      Utils().printMessage("UPDATE_INVOICE_BODY==>${jsonEncode(updateJson)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.UPDATE_INVOICE,
          body: updateJson,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      log("RESPONSE -- ${jsonEncode(response.toString())}");
      // Map<String, dynamic> data = response.data as Map<String, dynamic>;
      // GetEditInvoiceModel resp = GetEditInvoiceModel.fromJson(data);
      return Resource(
          status: STATUS.SUCCESS,
          data: response.data,
          message: response.data['message']);
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //------------------GET-INVOICED-CUSTOMER-DATA-----------------//
  Future<Resource> getInvoicedCustomerData({required String jobId}) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();

      var body = {
        "tenantId": loginData!.tenantId,
        "userId": userId,
        "jobId": jobId
      };

      log("GET-INVOICED_CUSTOMER_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.GET_INVOICED_lIST,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      log("getInvoicedCustomerData_RESPONSE -- ${jsonEncode(response.toString())}");
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;
          InvoicedCustomerModel resp = InvoicedCustomerModel.fromJson(data);
          return Resource(
              status: STATUS.SUCCESS,
              data: resp,
              message: response.data["message"]);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //------------------------Getpdf-by-customer------------------------//
  Future<Resource> getInvoicePdfByCustomer(
      {required String jobId, required String customerId}) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();

      // var body = {
      //   "tenantId": loginData!.tenantId,
      //   "userId": userId,
      //   "jobId": jobId
      // };
      var body = {
        "TenantId": loginData!.tenantId,
        "UserId": userId,
        "JobId": jobId,
        "CustomerIds": [int.parse(customerId)]
      };

      log("GET-INVOICED_pdf_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.CREATE_INVOICE_PDF_BY_CUSTOMERS,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      log("getInvoicedCustomerData_RESPONSE -- ${(response.data)})}");

      if (response != null) {
        // if (response.data["success"] == true) {
        Map<String, dynamic> data = response.data as Map<String, dynamic>;

        CreateInvoicePdfModel resp = CreateInvoicePdfModel.fromJson(data);
        return Resource(status: STATUS.SUCCESS, data: resp, message: '');
        //   Map<String, dynamic> data = response.data as Map<String, dynamic>;
        //   InvoicedCustomerModel resp = InvoicedCustomerModel.fromJson(data);
        //   return Resource(
        //       status: STATUS.SUCCESS,
        //       data: resp,
        //       message: response.data["message"]);
        // } else {
        //   return Resource.error(message: response.data["message"].toString());
        // }
        // } else {
        //   if (response.data.toString() == "403") {
        //     return Resource.error(message: TOKEN_EXPIRED);
        //   } else {
        //     return Resource.error(message: response.message);
        //   }
      } else {
        return Resource.error(message: 'Something went wrong');
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> getWorkingHours() async {
    try {
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.GET_WORKING_HOURS,
          requestType: RequestType.GET,
          header: {"Authorization": "Bearer $token"});

      print('Response: ${response.data}');

      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;
          WorkingHoursResponseModel resp =
              WorkingHoursResponseModel.fromJson(data);
          return Resource(
              status: STATUS.SUCCESS,
              data: resp,
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> addWorkingHours(
      {required String startTime, required String endTime}) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      var body = {
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2],
        "tenantId": loginData!.tenantId,
        "start_time": startTime.trim(),
        "end_time": endTime.trim(),
        "userId": userId!,
        "fromDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      };
      log("Working Hours BODY ===> ${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.ADD_WORKING_HOURS,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response.data,
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> getTimeInterval() async {
    try {
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.GET_TIME_INTERVAL,
          requestType: RequestType.GET,
          header: {"Authorization": "Bearer $token"});

      print('Response: ${jsonEncode(response.data)}');

      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;
          return Resource(
              status: STATUS.SUCCESS,
              data: IntervalData.fromJson(data["data"][0]),
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> addTimeInterval({
    required String hours,
    required String minute,
  }) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      var body = {
        "userId": userId,
        "tenantId": loginData!.tenantId,
        "fromDate": DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1))),
        //   "interval": timeInterval,
        "interval": "$hours:$minute",
      };
      log("Add Time interval BODY ===> ${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.SAVE_TIME_INTERVAL,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});

      print(response.data);

      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response.data,
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> getMaxJobTask() async {
    try {
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.GET_MAX_JOB_TASK,
          requestType: RequestType.GET,
          header: {"Authorization": "Bearer $token"});

      print('Response: ${response.data}');

      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;
          return Resource(
              status: STATUS.SUCCESS,
              data: data['data'],
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> addMaxJobTask({required String maxTask}) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      var body = {
        "user": userId,
        "tenantId": loginData!.tenantId,
        "fromDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "maximumTask": maxTask
      };
      log("Add Max Job BODY ===> ${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.SAVE_MAX_JOB_TASK,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response.data,
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> getUserType() async {
    try {
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.USER_TYPE,
          requestType: RequestType.GET,
          header: {"Authorization": "Bearer $token"});

      print('User Type Response: ${response.data}');

      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;

          var resp = UserTypeResponseModel.fromJson(data);

          return Resource(
              status: STATUS.SUCCESS,
              data: resp,
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> getPrivilegeList({required String phoneNo}) async {
    try {
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }

      List<String> deviceDetails = await Utils.getDeviceDetails();

      OtpVerificationData? loginData = await GlobalHandler.getLoginData();

      log("Request: ${jsonEncode({
            "deviceId": deviceDetails[0],
            "deviceType": deviceDetails[1],
            "appVersion": deviceDetails[2],
            "tenantId": loginData!.tenantId,
            "phoneNumber": phoneNo
          })} ");
      var response = await ApiHelper().apiCall(
          url: Urls.GET_PRIVILEGE,
          requestType: RequestType.POST,
          body: {
            "deviceId": deviceDetails[0],
            "deviceType": deviceDetails[1],
            "appVersion": deviceDetails[2],
            "tenantId": loginData!.tenantId,
            "phoneNumber": phoneNo
          },
          header: {
            "Authorization": "Bearer $token"
          });

      print('Response: ${jsonEncode(response.data)}');

      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;

          PrivilegeResponseModel resp = PrivilegeResponseModel.fromJson(data);

          return Resource(
              status: STATUS.SUCCESS,
              data: resp,
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> addUserPrivilege(
      {required String privilegeList,
      required String type,
      required String phoneNumber}) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      var body = {
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2],
        "tenantId": loginData!.tenantId,
        "userId": userId,
        "userType": type,
        "priviledgeAssigned": privilegeList,
        "phoneNumber": phoneNumber
      };
      log("Add Privilege BODY ===> ${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.SAVE_PRIVILEGE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response.data,
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> getReminder() async {
    try {
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log(Urls.GET_REMINDER);
      log("GETTING TOKEN  :   ${token}");
      var response = await ApiHelper().apiCall(
          url: Urls.GET_REMINDER,
          requestType: RequestType.GET,
          header: {"Authorization": "Bearer $token"});

      print('Reminder List Response: ${response.data}');

      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;

          var resp = ReminderResponseModel.fromJson(data);

          return Resource(
              status: STATUS.SUCCESS,
              data: resp,
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> setReminder(
      {required Map<String,dynamic> reminder}) async {
    try {
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      /*var body = {
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2],
        "tenantId": loginData!.tenantId,
        "userId": userId,
        "userType": type,
        "priviledgeAssigned": privilegeList,
        "phoneNumber": phoneNumber
      }*/;
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      log("GETTING TOKEN  :   ${token}");
      log('Request: ${jsonEncode(reminder)}');
      var response = await ApiHelper().apiCall(
          url: Urls.SET_REMINDER,
          body: reminder,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response.data,
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }
}

class WorkingHoursResponseModel {
  bool? success;
  String? message;
  WorkingHours? data;

  WorkingHoursResponseModel({this.success, this.message, this.data});

  WorkingHoursResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? WorkingHours.fromJson(json['data']) : null;
  }
}

class WorkingHours {
  String? start;
  String? end;

  WorkingHours({this.start, this.end});

  WorkingHours.fromJson(Map<String, dynamic> json) {
    var startTime = json['start'];

    start = getTime(startTime/*'10:00:00'*/);

    var endTime = json['end'];

    end = getTime(endTime/*'18:30:00'*/);
  }

  String getTime(String startTime) {
    DateTime now = DateTime.now();

    var dt = DateTime(now.year, now.month, now.day, int.parse(startTime.split(":")[0]),
        int.parse(startTime.split(":")[1]));

    final format = DateFormat.jm();  //"6:00 AM"

    return format.format(dt);
  }
}

class UserTypeResponseModel {
  bool? success;
  String? message;
  List<UserType>? data;

  UserTypeResponseModel({this.success, this.message, this.data});

  UserTypeResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserType>[];
      json['data'].forEach((v) {
        data!.add(new UserType.fromJson(v));
      });
    }
  }
}

class UserType {
  String? userType;
  List<Users>? users;

  UserType({this.userType, this.users});

  UserType.fromJson(Map<String, dynamic> json) {
    userType = json['user_type'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }
}

class Users {
  int? userId;
  String? userName;
  String? phoneNumber;

  Users({this.userId, this.userName, this.phoneNumber});

  Users.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    phoneNumber = json['phoneNumber'];
  }
}

class PrivilegeResponseModel {
  bool? success;
  String? message;
  List<PrivilegeData>? data;

  PrivilegeResponseModel({this.success, this.message, this.data});

  PrivilegeResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PrivilegeData>[];
      json['data'].forEach((v) {
        data!.add(new PrivilegeData.fromJson(v));
      });
    }
  }
}

class PrivilegeData {
  int? type;
  List<PrivilegeList>? privilegeList;

  PrivilegeData({this.type, this.privilegeList});

  PrivilegeData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['list'] != null) {
      privilegeList = <PrivilegeList>[];
      json['list'].forEach((v) {
        privilegeList!.add(new PrivilegeList.fromJson(v));
      });
    }
  }
}

class PrivilegeList {
  List<Privilege>? privilege;
  String? title;

  PrivilegeList({this.privilege, this.title});

  PrivilegeList.fromJson(Map<String, dynamic> json) {
    if (json['privilege'] != null) {
      privilege = <Privilege>[];
      json['privilege'].forEach((v) {
        privilege!.add(new Privilege.fromJson(v));
      });
    }
    title = json['title'];
  }
}

class Privilege {
  int? id;
  String? type;
  bool? value;

  Privilege({this.id, this.type, this.value});

  Privilege.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    value = json['value'];
  }
}

class IntervalData {
  String? fromDate;
  String? interval;
  String? hour;
  String? minute;

  IntervalData({
    this.fromDate,
    this.interval,
    this.hour,
    this.minute,
  });

  IntervalData.fromJson(Map<String, dynamic> json) {
    fromDate = json['fromDate'];
    hour = json['interval'].toString().split(":")[0];
    minute = json['interval'].toString().split(":")[1];
  }
}

Map<String, dynamic> entityData = {
  "success": true,
  "message": "Human",
  "data": {
    "service_entity_items": [
      {
        "row_items": [
          {
            "row_question_id": 10,
            "row_answer": "",
            "type_id": 1,
            "row_question": "Weight",
            "items": null
          },
          {
            "row_question_id": 11,
            "row_answer": "",
            "type_id": 4,
            "row_question": "Height",
            "items": [
              "3.0",
              "3.1",
              "3.2",
              "3.3",
              "3.4",
              "3.5",
              "3.6",
              "3.7",
              "3.8",
              "3.9",
              "3.10",
              "3.11",
              "4.0",
              "4.1",
              "4.2",
              "4.3",
              "4.4",
              "4.5",
              "4.6",
              "4.7",
              "4.8",
              "4.9",
              "4.10",
              "4.11",
              "5.0",
              "5.1",
              "5.2",
              "5.3",
              "5.4",
              "5.5",
              "5.6",
              "5.7",
              "5.8",
              "5.9",
              "5.10",
              "5.11",
              "6.0",
              "6.1",
              "6.2",
              "6.3",
              "6.4",
              "6.5",
              "6.6",
              "6.7",
              "6.8",
              "6.9",
              "6.10",
              "6.11",
              "7.0",
              "7.1",
              "7.2",
              "7.3",
              "7.4",
              "7.5",
              "7.6",
              "7.7",
              "7.8",
              "7.9",
              "7.10",
              "7.11"
            ]
          }
        ],
        "question": "",
        "answer": "",
        "type_id": 11,
        "question_id": null,
        "items": null
      },
      {
        "row_items": [
          {
            "row_question_id": 12,
            "row_answer": "",
            "type_id": 1,
            "row_question": "Test/Choice",
            "items": null
          },
          {
            "row_question_id": 13,
            "row_answer": "",
            "type_id": 1,
            "row_question": "Style",
            "items": null
          }
        ],
        "question": "",
        "answer": "",
        "type_id": 11,
        "question_id": null,
        "items": null
      }
    ]
  }
};

class ReminderResponseModel {
  bool? success;
  String? message;
  ReminderData? data;

  ReminderResponseModel({this.success, this.message, this.data});

  ReminderResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ReminderData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ReminderData {
  List<Events>? events;

  ReminderData({this.events});

  ReminderData.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Events {
  List<Reminders>? reminders;
  int? eventId;
  String? eventName;

  Events({this.reminders, this.eventId, this.eventName});

  Events.fromJson(Map<String, dynamic> json) {
    if (json['reminders'] != null) {
      reminders = <Reminders>[];
      json['reminders'].forEach((v) {
        reminders!.add(new Reminders.fromJson(v));
      });
    }
    eventId = json['eventId'];
    eventName = json['eventName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reminders != null) {
      data['reminders'] = this.reminders!.map((v) => v.toJson()).toList();
    }
    data['eventId'] = this.eventId;
    data['eventName'] = this.eventName;
    return data;
  }
}

class Reminders {
  String? reminder;
  String? reminderId;
  bool? sms;
  bool? push;

  Reminders({this.reminder, this.reminderId, this.sms, this.push});

  Reminders.fromJson(Map<String, dynamic> json) {
    reminder = json['reminder'];
    reminderId = json['reminderId'];
    sms = json['sms'];
    push = json['push'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reminder'] = this.reminder;
    data['reminderId'] = this.reminderId;
    data['sms'] = this.sms;
    data['push'] = this.push;
    return data;
  }
}

class PostReminderModel {
  List<Reminders>? reminder;

  PostReminderModel({this.reminder});

  PostReminderModel.fromJson(Map<String, dynamic> json) {
    if (json['reminder'] != null) {
      reminder = <Reminders>[];
      json['reminder'].forEach((v) {
        reminder!.add(new Reminders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reminder != null) {
      data['reminder'] = this.reminder!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

