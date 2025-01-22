import 'dart:convert';

import 'package:bizfns/features/Admin/Service/repo/service_repo_impl.dart';
import 'package:bizfns/features/Admin/data/api/add_user_api_client/add_user_api_client_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/Status.dart';
import '../../../../../core/route/RouteConstants.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../../core/model/dropdown_model.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/utils/const.dart';
import '../../../../core/utils/route_function.dart';
import '../../../auth/Login/model/login_otp_verification_model.dart';
import '../../data/api/admin_api_client/admin_api_client_impl.dart';
import '../../model/ServiceListResponse.dart';
import '../../model/get_service_details_model.dart';
import '../../model/serviceRateUnitListResponse.dart';

class ServiceProvider extends ChangeNotifier {
  final ServiceRepoImpl? serviceRepoImpl =
      ServiceRepoImpl(apiClient: AdminApiClientImpl());

  List<DropdownModel> unitList = [
    DropdownModel(id: "-1", name: "Select Unit", dependentid: "-1")
  ];
  List<ServiceListData> allServiceList = [];
  bool isRecurring = false;

  var selectedUnit =
      DropdownModel(id: "-1", name: "Select Unit", dependentid: "-1");
  bool loading = false;
  List<int> selectedIndex = [];

  getPreServiceCreationData() {}

  bool isSwitched = false;

  toggleSwitch(bool value) {
    isSwitched = value;
    print("isSwitched : ${isSwitched}");
    notifyListeners();
  }

  ///Api call for service unit list for populate the dropdown of the rate.
  getServiceUnitList(BuildContext context, int? activeStatus,
      [String? unitId]) async {
    Utils().printMessage("==GetServiceUnitList==");
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    // loading = true;
    List<String> deviceDetails = await Utils.getDeviceDetails();
    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2]
    };
    if (activeStatus != null) {
      if (activeStatus == 1) {
        isSwitched = true;
        notifyListeners();
      } else {
        isSwitched = false;
        notifyListeners();
      }
    }
    serviceRepoImpl!.getServiceRateUnit(body: body).then((value) async {
      // loading = false;
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        EasyLoading.dismiss();
        try {
          Utils().printMessage("gfhgfhfhfhfh ==>>>" + jsonEncode(value.data));
          // List<ServiceRateUnit> data = (json.decode(value.data) as List).map((i) =>ServiceRateUnit.fromJson(i)).toList();

          List<ServiceRateUnit> data = List<ServiceRateUnit>.from(
              value.data.map((model) => ServiceRateUnit.fromJson(model)));
          // data.data = customerList;

          // List<ServiceRateUnit> data = List<ServiceRateUnit>.from(l.map((model)=> ServiceRateUnit.fromJson(model)));
          if (data.isNotEmpty) {
            int i = 0;
            unitList.clear();
            unitList.add(DropdownModel(
                id: "-1", name: "Select Unit", dependentid: "-1"));
            for (var item in data) {
              if (item.sTATUS == "1") {
                unitList.add(DropdownModel(
                    id: item.iD!.toString(),
                    name: item.rATEUNITNAME!.toString(),
                    dependentid: item.iD!.toString()));
              }
              i++;
            }
          }
          if (unitId != null) {
            print("unitId --> ${unitId}");
            selectedUnit = unitList.firstWhere((element) =>
                int.parse(element.id.toString()) == int.parse(unitId));
            notifyListeners();
          } else if (unitList.isNotEmpty) {
            selectedUnit = unitList[0];
            notifyListeners();
          } else {
            selectedUnit = unitList[0];
            notifyListeners();
          }

          Utils().printMessage("STATUS SUCCESS");
        } catch (e) {
          if (context != null)
            Utils().ShowErrorSnackBar(context!, "Failed", SomethingWentWrong);
          Utils().printMessage(e.toString());
        }
      } else {
        EasyLoading.dismiss();
        if (context != null)
          Utils()
              .ShowErrorSnackBar(context, "Failed", value.message ?? "Failure");

        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      EasyLoading.dismiss();
      loading = false;
      if (context != null)
        Utils()
            .ShowSuccessSnackBar(context, "Failed", err.message ?? "Failure");
      notifyListeners();
      Utils().printMessage("STATUS ERROR->$err");
    });
    notifyListeners();
  }

  /// Validation before submit data in api for add new service
  validity({
    required BuildContext context,
    required String serviceName,
    required String serviceRate,
    required String? serviceId,
    required String rateUnit,
    required bool? isEdit,
  }) {
    if (serviceName.isEmpty) {
      Utils().ShowWarningSnackBar(context, "Opps", "Enter Service Name");
    } else if (serviceRate.isEmpty) {
      Utils().ShowWarningSnackBar(context, "Opps", "Enter Rate");
    } else if (rateUnit.isEmpty) {
      Utils().ShowWarningSnackBar(context, "Opps", "Choose Unit");
    } else {
      if (isEdit == null) {
        addService(context, serviceName, serviceRate, rateUnit);
      } else if (isEdit != null && isEdit == true) {
        editServiceDetails(
          serviceName: serviceName,
          rateUnit: rateUnit,
          serviceId: serviceId!,
          serviceRate: serviceRate,
          context: context,
        );
      } else {
        addService(context, serviceName, serviceRate, rateUnit);
      }
      // isEdit
      //     ?
      //     :
    }
  }

  ///Api call for Add new service
  void addService(BuildContext context, String serviceName, String rate,
      String unit) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "userId": userId,
      "tenantId": loginData!.tenantId!,
      "serviceName": serviceName,
      "rate": rate,
      "rateUnit": selectedUnit.id
    };

    serviceRepoImpl!.addService(body: body).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        EasyLoading.dismiss();
        loading = false;

        Utils().printMessage("ADD_SERVICE_DATA==>${value.data}");
        Utils().printMessage("STATUS SUCCESS");

        Utils().ShowSuccessSnackBar(
            context, "Success", value.message ?? "Successfully Service added",
            duration: Duration(seconds: 2));

        await Future.delayed(Duration(seconds: 2));

        if (GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
            '/home/schedule') {
          Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        }

        // Navigator.pop(context);
        GoRouter.of(context).pop();
        //Navigate.NavigateAndReplace(context, service_list, params: {});
        notifyListeners();
      } else {
        EasyLoading.dismiss();
        loading = false;
        Utils().ShowErrorSnackBar(
            context, "Failed", value.message ?? "Failed to Service add");
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
      }
    }, onError: (err) {
      Utils().printMessage("ADD_CUSTOMER_ERROR==>$err");
      EasyLoading.dismiss();
      loading = false;
      Utils().ShowErrorSnackBar(context, "Failed", err.toString());
      notifyListeners();
    });
  }

  ///Api call for service list for populate list.
  getServiceList(BuildContext context) async {
    Utils().printMessage("==GetServiceUnitList==");
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    String? tenantId = await GlobalHandler.getCompanyId();
    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "userId": userId,
      "tenantId": tenantId
    };

    serviceRepoImpl!.getServiceList(body: body).then((value) async {
      loading = false;
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        EasyLoading.dismiss();
        try {
          List<ServiceListData> data = List<ServiceListData>.from(
              value.data.map((model) => ServiceListData.fromJson(model)));
          // data.data = customerList;

          // List<ServiceRateUnit> data = List<ServiceRateUnit>.from(l.map((model)=> ServiceRateUnit.fromJson(model)));
          if (data.isNotEmpty) {
            int i = 0;
            allServiceList.clear();
            allServiceList.addAll(data);
            notifyListeners();
          } else {
            allServiceList.clear();
            notifyListeners();
          }

          Utils().printMessage("STATUS SUCCESS");
        } catch (e) {
          if (context != null)
            Utils().ShowErrorSnackBar(context!, "Failed", SomethingWentWrong);
          Utils().printMessage(e.toString());
        }
      } else {
        EasyLoading.dismiss();
        if (context != null)
          Utils()
              .ShowErrorSnackBar(context, "Failed", value.message ?? "Failure");

        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      EasyLoading.dismiss();
      loading = false;
      if (context != null)
        Utils()
            .ShowSuccessSnackBar(context, "Failed", err.message ?? "Failure");
      notifyListeners();
      Utils().printMessage("STATUS ERROR->$err");
    });
    notifyListeners();
  }

  getServiceDetails(
      {required String serviceId, required BuildContext context}) async {
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    serviceRepoImpl!.getServiceDetails(serviceId: serviceId).then((value) {
      if (value.status == STATUS.SUCCESS) {
        loading = false;
        EasyLoading.dismiss();
        if (value.data != null) {
          try {
            ServiceDetailsData serviceDetailsData = value.data;
            notifyListeners();
            GoRouter.of(context).pushNamed('admin-add-service', extra: {
              'isEdit': true,
              'serviceName': serviceDetailsData.sERVICENAME,
              'serviceRate': serviceDetailsData.rATE.toString(),
              'serviceUnit': serviceDetailsData.rATEUNIT.toString(),
              'serviceId': serviceDetailsData.iD.toString(),
              'activeStatus': int.parse(serviceDetailsData.sTATUS.toString())
            }).then((value) async {
              await getServiceList(context);
            });
          } catch (e) {
            Utils().printMessage(e.toString());
            loading = false;
            EasyLoading.dismiss();
          }
        }
      } else {
        Utils()
            .ShowErrorSnackBar(context, "Failed", value.message ?? "Failure");
        loading = false;
        EasyLoading.dismiss();
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
      }
    });
  }

  editServiceDetails(
      {required String serviceName,
      required String rateUnit,
      required String serviceId,
      required String serviceRate,
      required BuildContext context}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    await serviceRepoImpl!
        .ediServiceDetails(
            serviceName: serviceName,
            rateUnit: rateUnit,
            serviceId: serviceId,
            serviceRate: serviceRate,
            serviceActiveStatus: isSwitched ? '1' : '0')
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        EasyLoading.dismiss();
        loading = false;

        Utils().printMessage("EDIT_SERVICE_DATA==>${value.data}");
        Utils().printMessage("STATUS SUCCESS");

        Utils().ShowSuccessSnackBar(
            context, "Success", value.message ?? "Service Edited Successfully",
            duration: Duration(seconds: 2));

        await Future.delayed(Duration(seconds: 2));

        if (GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
            '/home/schedule') {
          Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        }

        // Navigator.pop(context);
        GoRouter.of(context).pop();
        //Navigate.NavigateAndReplace(context, service_list, params: {});
        notifyListeners();
      }
    });
  }

  //-----------------------------DELETE-SERVICE-----------------------------//
  deleteService(
      {required String serviceId, required BuildContext context}) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    try {
      await serviceRepoImpl!
          .deleteService(serviceId: serviceId)
          .then((value) async {
        if (value.status == STATUS.SUCCESS) {
          getServiceList(context);
          EasyLoading.dismiss();
          Utils().ShowSuccessSnackBar(context, "Success",
              value.message ?? "Successfully Service Deleted",
              duration: Duration(seconds: 2));
          GoRouter.of(context).pop();
          notifyListeners();
        } else {
          Utils().ShowErrorSnackBar(context, "Success",
              value.message ?? "Successfully Service Deleted",
              duration: Duration(seconds: 2));
        }
      });
    } catch (e) {
      Utils().ShowErrorSnackBar(context, "Success", e.toString(),
          duration: Duration(seconds: 2));
    }
  }
}
