import 'package:bizfns/features/Admin/Create%20Job/api-client/schedule_api_client_implementation.dart';
import 'package:bizfns/features/Admin/Create%20Job/repo/schedule_repo_implementaiton.dart';
import 'package:bizfns/features/Admin/Customer/model/customer_service_entity_response_model.dart';
import 'package:bizfns/features/Admin/data/api/add_user_api_client/add_user_api_client_impl.dart';
import 'package:bizfns/features/Admin/model/staffListResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/Status.dart';
import '../../../../../core/route/RouteConstants.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/utils/const.dart';
import '../../../../core/utils/route_function.dart';
import '../../../auth/Login/model/login_otp_verification_model.dart';
import '../../Create Job/model/add_schedule_model.dart';
import '../model/customerListResponseModel.dart';
import '../model/get_customer_details_model.dart';
import '../repo/customer_repo_impl.dart';

///CustomerProvider is the Provider to mange all the functions related to customer
///
///
///

class CustomerProvider extends ChangeNotifier {
  final CustomerRepoImpl? addCustomerRepository =
      CustomerRepoImpl(apiClient: AddUserApiClientImpl());
  final ScheduleRepoImplementation? scheduleRepo =
      ScheduleRepoImplementation(apiClient: ScheduleAPIClientImpl());
  bool loading = false;
  List<CustomerListData>? customerList = [];
  List<CustomerServiceEntityData> customerServiceEntity = [];
  final AddScheduleModel model = AddScheduleModel.addSchedule;

  bool isSwitched = false;

  toggleSwitch(bool value) {
    isSwitched = value;
    print("isSwitched : ${isSwitched}");
    notifyListeners();
  }

  initializeSwith({required int? activeStatus}) {
    if (activeStatus != null) {
      if (activeStatus == 1) {
        isSwitched = true;
        // notifyListeners();
      } else {
        isSwitched = false;
        // notifyListeners();
      }
    }
  }

  validity(
      {required BuildContext context,
      required String firstName,
      required String lastName,
      required String email,
      required String phone,
      required Map<String, dynamic> serviceEntity,
      required bool? isEdit,
      required String? customerId,
      required String customerAddress,
      required String custCompanyName}) {
    // if (firstName.isEmpty) {
    //   Utils().ShowWarningSnackBar(context, "Opps", "Enter First Name");
    // } else
    if (lastName.isEmpty) {
      Utils().ShowWarningSnackBar(context, "Opps", "Enter Last Name");
    }
    /*else if(email.isEmpty){
      Utils().ShowWarningSnackBar(context,"Opps",  "Enter Email Address");
    }*/ /*else if(Utils.IsValidEmail(email)){
      Utils().show_snackbar(context, "Enter Email Address", Colors.black);
    } */
    else if (phone.isEmpty) {
      Utils().ShowWarningSnackBar(context, "Opps", "Enter Phone Number");
    } else if (phone.length < 10) {
      Utils()
          .ShowWarningSnackBar(context, "Opps", "Enter a valid phone number");
    } else {
      if (isEdit == null) {
        addCustomer(
            context: context,
            custAddress: customerAddress,
            custCompanyName: custCompanyName,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            serviceEntity: serviceEntity
            // context,
            // firstName,
            // lastName,
            // email,
            // phone,
            // serviceEntity,
            );
      } else if (isEdit != null && isEdit == true) {
        activeInactiveCustomer(customerId: customerId!, context: context);
        editCustomerDetails(
            customerId: customerId!,
            firstName: firstName,
            lastName: lastName,
            companyName: custCompanyName,
            address: customerAddress,
            email: email,
            customerPhone: phone,
            context: context);
      }
    }
  }

  void addCustomer(
      {required BuildContext context,
      required String firstName,
      required String lastName,
      required String email,
      required String phone,
      required String custAddress,
      required String custCompanyName,
      required Map<String, dynamic> serviceEntity}) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    addCustomerRepository!
        .addCustomer(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      serviceEntity: serviceEntity,
      custAddress: custAddress,
      custCompanyName: custCompanyName,
    )
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowSuccessSnackBar(
            context, "Success", "Successfully customer added",
            duration: Duration(seconds: 2));
        Utils().printMessage("STATUS SUCCESS");

        await Future.delayed(Duration(seconds: 2));
        // Navigator.pop(context);
        Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        GoRouter.of(context).pop();
        //Navigate.NavigateAndReplace(context, customer_list, params: {});
        notifyListeners();
      } else {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(
            context, "Failed", value.message ?? "Failed to customer add");
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("ADD_CUSTOMER_ERROR==>$err");
      EasyLoading.dismiss();
      Utils().ShowErrorSnackBar(context, "Failed", err.toString());
      notifyListeners();
    });
  }

  addServiceEntity(BuildContext context, String customerID) async {
    EasyLoading.show(
        status: "Loading",
        indicator: const CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    scheduleRepo!.addServiceEntity(customerID).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowSuccessSnackBar(context, "Success",
            value.message ?? "Successfully service entity added");
        Utils().printMessage("ADD_CUSTOMER_DATA==>${value.data}");
        Utils().printMessage("STATUS SUCCESS");
        // Navigator.pop(context);
        GoRouter.of(context).pop();
        //Navigate.NavigateAndReplace(context, customer_list, params: {});
        notifyListeners();
      } else {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(
            context, "Failed", value.message ?? "Failed to service entity add");
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("ADD_CUSTOMER_ERROR==>$err");
      EasyLoading.dismiss();
      Utils().ShowErrorSnackBar(context, "Failed", err.toString());
      notifyListeners();
    });
  }

  //-------------------UPDATE-SERVCE-ENTITY-----------------//
  updateServiceEntity({
    required BuildContext context,
    required String customerID,
    required String serviceEntityId,
  }) async {
    EasyLoading.show(
        status: "Loading",
        indicator: const CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    scheduleRepo!
        .updateServiceEntity(
            customerID: customerID, serviceEntityId: serviceEntityId)
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        customerServiceEntity.clear();
        // getCustomerServiceEntity(context, customerID: customerID);
        // notifyListeners();
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowSuccessSnackBar(context, "Success",
            value.message ?? "Successfully service entity added");
        Utils().printMessage("ADD_CUSTOMER_DATA==>${value.data}");
        Utils().printMessage("STATUS SUCCESS");
        // Navigator.pop(context);
        GoRouter.of(context).pop();
        //Navigate.NavigateAndReplace(context, customer_list, params: {});
        notifyListeners();
      } else {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(
            context, "Failed", value.message ?? "Failed to service entity add");
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("ADD_CUSTOMER_ERROR==>$err");
      EasyLoading.dismiss();
      Utils().ShowErrorSnackBar(context, "Failed", err.toString());
      notifyListeners();
    });
  }

  //-----------------------------DELETE-SERVICE-OBJECT----------------------------//
  deleteServiceEntity({
    required BuildContext context,
    required String customerID,
    required String serviceEntityId,
  }) async {
    EasyLoading.show(
        status: "Loading",
        indicator: const CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    await scheduleRepo!
        .deleteServiceEntity(
            customerID: customerID, serviceEntityId: serviceEntityId)
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        // getCustomerServiceEntity(context,customerID: customerID);
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowSuccessSnackBar(context, "Success",
            value.message ?? "Successfully service entity Deleted");
        Utils().printMessage("SERVICE_ENTITY_DELETE_DATA==>${value.data}");
        Utils().printMessage("STATUS SUCCESS");
        Future.delayed(Duration(seconds: 3));
        // Navigator.pop(context);
        // GoRouter.of(context).pop();
        //Navigate.NavigateAndReplace(context, customer_list, params: {});
        notifyListeners();
      } else {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(context, "Failed",
            value.message ?? "Failed to Delete Service Entity");
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("DELETE_SERVICE_ENTITY_ERROR==>$err");
      EasyLoading.dismiss();
      Utils().ShowErrorSnackBar(context, "Failed", err.toString());
      notifyListeners();
    });
  }

  String searchText = '';

  void searchCustomer(context, String text) {
    searchText = text;
    notifyListeners();
  }

  ///get all the customer list for a specific business
  ///
  ///
  ///

  getCustomerList(BuildContext context, {bool? searchRefresh}) {
    //loading = searchRefresh == null ? true : false;
    addCustomerRepository!.getCustomerList(context).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        loading = false;
        EasyLoading.dismiss();
        customerList!.clear();
        try {
          customerList!.addAll(value.data);
        } catch (e) {
          Utils().ShowSuccessSnackBar(
              context, "Failure", value.message ?? SomethingWentWrong);
        }
        notifyListeners();
      } else {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(
            context, "Failed", value.message ?? "Failed to customer add");
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      EasyLoading.dismiss();
      Utils().ShowErrorSnackBar(context, "Failed", err.toString());
      notifyListeners();
    });
  }

  //---------------------GET-CUSTOMER-DETAILS--------------------//
  getCustomerDetails(
      {required String customerID, required BuildContext context}) {
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    model.serviceEntity = null;
    getCustomerServiceEntity(context, customerID: customerID.toString());
    Future.delayed(Duration(seconds: 2));
    addCustomerRepository!
        .getCustomerDetails(customerId: customerID)
        .then((value) {
      if (value.status == STATUS.SUCCESS) {
        loading = false;
        EasyLoading.dismiss();
        if (value.data != null) {
          try {
            CustomerDetailsData data = value.data;

            print("DATA COMPANY NAMe : ${data.companyName}");

            // staffDetailsData.add(data);
            // log("====${staffTypeList.where((element) => element.id == "2")}");
            // staffTypeList.where((element) => element.id == "2");
            // print(staffTypeList.firstWhere(
            //     (element) => element.id!.contains(data.stafftype.toString())));
            // selectedStaffType = staffTypeList.firstWhere((element) => element.id!.contains(data.stafftype.toString()));
            notifyListeners();
            GoRouter.of(context).pushNamed('parent-add-customer', extra: {
              'isEdit': true,
              'firstName': data.firstName,
              'lastName': data.lastName,
              'email': data.email,
              'mobile': data.customerPhone,
              'activeStatus': int.parse(data.activeStatus.toString()),
              'customerId': int.parse(customerID),
              'companyAdress': data.address,
              'companyName': data.companyName
            }).then((value) async {
              await getCustomerList(context);
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

  ///geg the list of service entity for a specific customer
  ///
  ///

  getCustomerServiceEntity(BuildContext context, {String? customerID}) async {
    loading = true;
    customerServiceEntity.clear();
    await addCustomerRepository!
        .getCustomerServiceEntity(customerID: customerID!)
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        loading = false;
        EasyLoading.dismiss();
        try {
          customerServiceEntity.addAll(value.data);
          notifyListeners();
        } catch (e) {
          Utils().ShowWarningSnackBar(
              context, "Failure", value.message ?? SomethingWentWrong);
        }
        notifyListeners();
      } else {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowWarningSnackBar(
            context, "Failed", value.message ?? "Failed to customer add");
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      EasyLoading.dismiss();
      Utils().ShowWarningSnackBar(context, "Failed", 'No service entity found');
      notifyListeners();
    });
  }

  //-----------------------------DELETE-CUSTOMER-------------------------//
  deleteCustomer(
      {required String customerId, required BuildContext context}) async {
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    await addCustomerRepository!
        .deleteCustomer(customerId: customerId)
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        getCustomerList(context);
        EasyLoading.dismiss();
        loading = false;
        Utils().ShowSuccessSnackBar(context, "Success",
            value.message ?? "Successfully Customer Deleted",
            duration: Duration(seconds: 2));
        GoRouter.of(context).pop();
        notifyListeners();
      }
    });
  }

  //---------------------------UPDATE-CUSTOMER-------------------------//
  editCustomerDetails(
      {required String customerId,
      required String firstName,
      required String lastName,
      required String companyName,
      required String address,
      required String email,
      required String customerPhone,
      required BuildContext context}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);

    await addCustomerRepository!
        .updateCustomer(
            customerId: customerId,
            firstName: firstName,
            lastName: lastName,
            companyName: companyName,
            address: address,
            email: email,
            customerPhone: customerPhone)
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowSuccessSnackBar(
            context, "Success", "Successfully customer Edited",
            duration: Duration(seconds: 2));
        Utils().printMessage("STATUS SUCCESS");

        await Future.delayed(Duration(seconds: 2));
        // Navigator.pop(context);
        Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        GoRouter.of(context).pop();
        //Navigate.NavigateAndReplace(context, customer_list, params: {});
        notifyListeners();
      } else {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(
            context, "Failed", value.message ?? "Failed to customer Edit");
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
      }
    });
  }

  //----------------------ACTIVE-INACTIVE STATUS-------------------//
  activeInactiveCustomer(
      {required String customerId, required BuildContext context}) async {
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    await addCustomerRepository!
        .activeInactiveCustomer(
            activeStatus: isSwitched ? '1' : '0', customerId: customerId)
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        getCustomerList(context);
        EasyLoading.dismiss();
        loading = false;
        Utils().ShowSuccessSnackBar(context, "Success",
            value.message ?? "Successfully Customer Activated",
            duration: Duration(seconds: 2));
        GoRouter.of(context).pop();
        notifyListeners();
      }
    });
  }
}
