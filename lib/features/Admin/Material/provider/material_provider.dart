import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/features/Admin/Material/model/material_unit_list_response.dart';
import 'package:bizfns/features/Admin/data/api/admin_api_client/admin_api_client_impl.dart';
import 'package:bizfns/features/Admin/model/materialListResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/Status.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../../core/model/dropdown_model.dart';
import '../../../../core/route/RouteConstants.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/utils/const.dart';
import '../../../../core/utils/route_function.dart';
import '../../../auth/Login/model/login_otp_verification_model.dart';
import '../model/get_material_details_model.dart';
import '../model/materialCategoryListResponse.dart';
import '../repo/material_repo_impl.dart';

class MaterialProvider extends ChangeNotifier {
  final MaterialRepoImpl materialRepoImpl =
      MaterialRepoImpl(apiClient: AdminApiClientImpl());
  bool loading = false;
  List<int> selectedIndex = [];

  List<DropdownModel> materialUnitList = [
    DropdownModel(id: "-1", name: "Select Unit", dependentid: "-1")
  ];
  List<DropdownModel> categoryList = [
    DropdownModel(id: "-1", name: "Select One", dependentid: "-1")
  ];
  List<DropdownModel> subcategoryList = [
    DropdownModel(id: "-1", name: "Select One", dependentid: "-1")
  ];

  List<Data>? catList = [];

  var selectedUnit =
      DropdownModel(id: "-1", name: "Select Unit", dependentid: "-1");
  var selectedCategory =
      DropdownModel(id: "-1", name: "Select One", dependentid: "-1");
  var selectedsubCategory =
      DropdownModel(id: "-1", name: "Select One", dependentid: "-1");
  var subSelectedCategory =
      DropdownModel(id: "-1", name: "Select One", dependentid: "-1");

  List<MaterialData> materialList = [];

  clearCategoryListData() {
    categoryList = [
      DropdownModel(id: "-1", name: "Select One", dependentid: "-1")
    ];
    selectedCategory = categoryList.first;
  }

  clearSubcategoryListData() {
    subcategoryList = [
      DropdownModel(id: "-1", name: "Select One", dependentid: "-1")
    ];
    selectedsubCategory = subcategoryList.first;
  }

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

  ///Call Api for get material category
  getMaterialCategoryListApi(BuildContext context, int? activeStatus,
      [String? categoryId, String? subCategoryId, String? unitId]) async {
    Utils().printMessage("==getMaterialCategoryList Api Call==");
    loading = true;
    EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    String? companyId = await GlobalHandler.getCompanyId();
    Utils().printMessage("CompanyId ==>" + companyId!);
    var body = {
      "userId": userId,
      "tenantId": companyId,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2]
    };
    materialRepoImpl.getMaterialCategory(body: body).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        try {
          MaterialCategoryListResponse materialCategoryListResponse =
              value.data;
          if (materialCategoryListResponse != null) {
            catList = materialCategoryListResponse!.data;
            if (catList != null && catList!.isNotEmpty) {
              categoryList.clear();
              categoryList.add(DropdownModel(
                  id: "-1", name: "Select One", dependentid: "-1"));

              for (int i = 0; i < catList!.length; i++) {
                categoryList.add(DropdownModel(
                  id: catList![i].pKCATEGORYID!.toString(),
                  dependentid: catList![i].pKCATEGORYID!.toString(),
                  name: catList![i].cATEGORYNAME!.toString(),
                ));
              }
              log("Category id: ${categoryId}");
              if (categoryId != null && categoryId != "-1") {
                selectedCategory = categoryList.firstWhere((element) =>
                    int.parse(element.id.toString()) == int.parse(categoryId));
                onChange(subCategoryId);
                notifyListeners();
              } else {
                selectedCategory = categoryList.first;
              }

              //
              // subcategoryList.clear();
              // subcategoryList.add(DropdownModel(
              //     id: "-1", name: "Select One", dependentid: "-1"));
              // selectedsubCategory = subcategoryList.first;
              // print("catList!.length : ${catList!.length}");
              // for (int i = 0; i < catList!.length; i++) {
              //   if (selectedCategory.id ==
              //       catList![i].pKCATEGORYID.toString()) {
              //     for (var k = 0; k < catList![i].subCategory!.length; k++) {
              //       subcategoryList.add(DropdownModel(
              //           id: (catList![i].subCategory![k].pkSubcategoryId)
              //               .toString(),
              //           name: catList![i].subCategory![k].pkSubcategoryName));
              //     }
              //   }
              //   // if (sub) {

              //   // }
              // }

              if (subCategoryId != null) {
                selectedsubCategory = subcategoryList.firstWhere((element) =>
                    int.parse(element.id.toString()) ==
                    int.parse(subCategoryId));
                notifyListeners();
              } else {
                selectedsubCategory = subcategoryList.first;
              }

              if (selectedsubCategory != subcategoryList.first) {
                if (unitId != null) {
                  getMaterialUnitListApi(context, unitId);
                }
              }
            }
          } else {}

          loading = false;
          notifyListeners();
        } catch (e, stackTrace) {
          loading = false;
          Utils().printMessage(
              "STATUS Failure ==>>> ${stackTrace}" + e.toString());
        }
        notifyListeners();
      } else {
        loading = false;
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    // notifyListeners();
  }

  getMaterialAndSubCategoryData() async {
    loading = true;
    EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    String? companyId = await GlobalHandler.getCompanyId();

    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "userId": userId,
      "tenantId": companyId
    };
    materialRepoImpl.getMaterialCategory(body: body).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        try {
          MaterialCategoryListResponse materialCategoryListResponse =
              value.data;
          if (materialCategoryListResponse != null) {
            catList = materialCategoryListResponse!.data;
            loading = false;
            EasyLoading.dismiss();
            notifyListeners();
          } else {
            catList = [];
            loading = false;
            EasyLoading.dismiss();
            notifyListeners();
          }
        } catch (e) {
          loading = false;
          EasyLoading.dismiss();
          notifyListeners();
        }
      } else {
        loading = false;
        EasyLoading.dismiss();
        notifyListeners();
      }
    });
  }

  //--------------------------------add-subcategory------------------------------//
  Future addMaterialSubCategory(
      {required String subCategoryName,
      required String categoryID,
      required BuildContext context}) async {
    loading = true;
    EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    try {
      await materialRepoImpl
          .addMaterialSubCategory(
              subCategoryName: subCategoryName, categoryId: categoryID)
          .then((value) {
        if (value.status == STATUS.SUCCESS) {
          getMaterialAndSubCategoryData();
          Utils().ShowSuccessSnackBar(context, "Success",
              value.message ?? "Successfully SUbCategory Added",
              duration: Duration(seconds: 2));
          loading = false;
          EasyLoading.dismiss();
          notifyListeners();
        } else {
          Utils().ShowErrorSnackBar(
              context, "Error", value.message ?? "Sub-Category adding failed");
        }
      });
    } catch (e) {
      Utils().ShowErrorSnackBar(
          context, "Error", e.toString() ?? "Sub-Category adding failed");
      loading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  //-----------------ADD-MATERIAL-CATEGORY------------------//
  Future addMaterialCategory(
      {required String categoryName, required BuildContext context}) async {
    loading = true;
    EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    try {
      await materialRepoImpl
          .addMaterialCategory(categoryName: categoryName)
          .then((value) {
        if (value.status == STATUS.SUCCESS) {
          getMaterialAndSubCategoryData();
          Utils().ShowSuccessSnackBar(context, "Success",
              value.message ?? "Successfully Category Added",
              duration: Duration(seconds: 2));
          loading = false;
          EasyLoading.dismiss();
          notifyListeners();
        } else {
          Utils().ShowErrorSnackBar(
              context, "Error", value.message ?? "Category adding failed");
        }
      });
    } catch (e) {
      Utils().ShowErrorSnackBar(
          context, "Error", e.toString() ?? "Category adding failed");
      loading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  //----------------DELETE-CATEGORY-SUBCATEGORY-DATA----------------//
  Future deleteCategoryAndSubcategory(
      {required String categoryId,
      required String subcategoryId,
      required BuildContext context}) async {
    loading = true;
    EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    try {
      await materialRepoImpl
          .deleteCategoryAndSubcategory(
              categoryId: categoryId, subcategoryId: subcategoryId)
          .then((value) {
        if (value.status == STATUS.SUCCESS) {
          getMaterialAndSubCategoryData();
          Utils().ShowSuccessSnackBar(
              context, "Success", value.message ?? "Successfully Deleted",
              duration: Duration(seconds: 2));
          loading = false;
          EasyLoading.dismiss();
          notifyListeners();
        } else {
          Utils().ShowErrorSnackBar(
              context, "Error", value.message ?? "Delete failed");
        }
      });
    } catch (e) {
      Utils()
          .ShowErrorSnackBar(context, "Error", e.toString() ?? "Delete failed");
      loading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  onChange([value]) {
    print("GETTING VSL : ${value}");
    // if (value == null) {
    subcategoryList.clear();
    subcategoryList
        .add(DropdownModel(id: "-1", name: "Select One", dependentid: "-1"));
    // selectedsubCategory = subcategoryList.first;
    print("catList!.length : ${catList!.length}");
    for (int i = 0; i < catList!.length; i++) {
      if (selectedCategory.id == catList![i].pKCATEGORYID.toString()) {
        for (var k = 0; k < catList![i].subCategory!.length; k++) {
          subcategoryList.add(DropdownModel(
              id: (catList![i].subCategory![k].pkSubcategoryId).toString(),
              name: catList![i].subCategory![k].pkSubcategoryName));
        }
      }
      // if (sub) {

      // }
    }
    // }

    if (value != null) {
      selectedsubCategory = subcategoryList.firstWhere(
          (element) => int.parse(element.id.toString()) == int.parse(value));
      notifyListeners();
    } else {
      selectedsubCategory = subcategoryList.first;
    }
  }

  ///Call Api for get material Unit
  getMaterialUnitListApi(BuildContext context, [unitId]) async {
    log("==getMaterialUnitList Api Call==${unitId}");
    loading = true;
    EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    String? companyId = await GlobalHandler.getCompanyId();
    Utils().printMessage("CompanyId ==>" + companyId!);
    var body = {
      "userId": userId,
      "tenantId": companyId,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "category_id": selectedCategory.id,
    };
    materialRepoImpl.getMaterialUnit(body: body).then((value) async {
      print('Response from material unit: $value');

      if (value.status == STATUS.SUCCESS) {
        try {
          MaterialUnitResponse materialUnit = value.data;
          if (materialUnit != null) {
            List<UnitData>? unitList = materialUnit.data!;
            if (unitList != null && unitList.isNotEmpty) {
              materialUnitList.clear();
              materialUnitList.add(DropdownModel(
                  id: "-1", name: "Select One", dependentid: "-1"));
              selectedUnit = materialUnitList.first;
              for (int i = 0; i < unitList.length; i++) {
                materialUnitList.add(
                  DropdownModel(
                    id: unitList[i].unitId!.toString(),
                    dependentid: unitList[i].unitName!,
                    name: unitList[i].unitName!.toString(),
                  ),
                );
              }
              if (unitId != null) {
                selectedUnit = materialUnitList.firstWhere((element) =>
                    int.parse(element.id.toString()) == int.parse(unitId));
              }
            }
          } else {}

          loading = false;
          notifyListeners();
        } catch (e) {
          loading = false;
          Utils().printMessage("STATUS Failure ==>>> " + e.toString());
        }
        notifyListeners();
      } else {
        loading = false;
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    // notifyListeners();
  }

  getMaterialDetails(
      {required int? materialId, required BuildContext context}) {
    log("GETTTTTTTTTTTTMATTTTTTTTTTTTTTDETTTTTTTTTT");
    loading = true;
    // notifyListeners();
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    materialRepoImpl!
        .getMaterialDetails(materialId: materialId.toString())
        .then((value) {
      if (value.status == STATUS.SUCCESS) {
        loading = false;
        EasyLoading.dismiss();
        if (value.data != null) {
          try {
            MaterialDetailsData materialDetailsData = value.data;
            notifyListeners();
            GoRouter.of(context).pushNamed('admin-add-material', extra: {
              'isEdit': true,
              'materialName': materialDetailsData.materialName,
              'categoryId': materialDetailsData.categoryId.toString(),
              'subCategoryId': materialDetailsData.subcategoryId.toString(),
              'rate': materialDetailsData.materialRate,
              'unitId': materialDetailsData.materialRateUnitId.toString(),
              'activeStatus': materialDetailsData.activeStatus,
              'materialType': materialDetailsData.materialType,
              'materialId': materialDetailsData.materialId.toString()
            }).then((value) {
              getMaterialListApi(context);
            });
          } catch (e) {
            Utils().printMessage(e.toString());
            loading = false;
            // EasyLoading.dismiss();
          }
        }
      } else {
        Utils()
            .ShowErrorSnackBar(context, "Failed", value.message ?? "Failure");
        loading = false;
        // EasyLoading.dismiss();
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
      }
    });
  }

  validity(
      {required BuildContext context,
      required String material_name,
      required String rate,
      required bool? isEdit,
      required String? materialId,
      required String? materialType}) {
    if (material_name.isEmpty) {
      Utils().ShowWarningSnackBar(context, "Opps", "Enter material Name");
    } else if (selectedUnit.id == '-1') {
      Utils().ShowWarningSnackBar(context, "Opps", "Select Unit");
    }
    //  else if (selectedCategory.id == "-1") {
    //   Utils().ShowWarningSnackBar(
    //       context, "Opps", "Enter Please choose a category");
    // }
    else if (rate.isEmpty) {
      Utils().ShowWarningSnackBar(context, "Opps", "Enter a rate");
    } else {
      if (isEdit == null) {
        addMaterial(context, material_name, rate);
      } else if (isEdit != null && isEdit == true) {
        activeInactiveCustomer(materialID: materialId!, context: context);
        editMaterialDetails(
            materialName: material_name,
            materialRateUnitId: selectedUnit.id!,
            materialId: materialId!,
            categoryId: selectedCategory.id!,
            subCategoryId: selectedsubCategory.id!,
            materialRate: rate,
            materialType: materialType!,
            context: context);
      } else {
        addMaterial(context, material_name, rate);
      }
    }
  }

  materialUnitValidity({
    required BuildContext context,
    required String unitName,
  }) {
    if (unitName.isEmpty) {
      GoRouter.of(context).pop();
      Utils().ShowWarningSnackBar(context, "Opps", "Enter Material Unit");
    } else {
      saveMaterialUnit(context: context, unitName: unitName);
    }
  }

  void addMaterial(
      BuildContext context, String material_name, String rate) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);

    AdminApiClientImpl adminApiClientImpl = new AdminApiClientImpl();
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "materialData": {
        "categoryId": selectedCategory.id != '-1' ? selectedCategory.id : "",
        "subcategoryId":
            selectedsubCategory.id != '-1' ? selectedsubCategory.id : "",
        "materialName": material_name,
        "materialRate": rate,
        "materialType": "a",
        "materialRateUnitId": selectedUnit.id,
      }
    };
    print("AllMAterial Body json===>${jsonEncode(body)}");
    materialRepoImpl!.addMaterial(body: body).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        EasyLoading.dismiss();
        Utils().ShowSuccessSnackBar(
            context, "Success", value.message ?? "Successfully material added",
            duration: Duration(seconds: 2));

        await Future.delayed(Duration(seconds: 2));

        if (GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
            '/home/schedule') {
          Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        }
        GoRouter.of(context).pop();
        //Navigate.NavigateAndReplace(context, material_list, params: {});
        notifyListeners();
      } else {
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(
            context, "Failed", value.message ?? "Failed to material add");
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
      }
    }, onError: (err) {
      Utils().printMessage("ADD_CUSTOMER_ERROR==>$err");
      EasyLoading.dismiss();
      Utils().ShowErrorSnackBar(context, "Failed", err.toString());
      notifyListeners();
    });
  }

  ///Call Api for get material list
  getMaterialListApi(BuildContext context) async {
    Utils().printMessage("==getMaterialList Api Call==");
    loading = true;
    EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    String? companyId = await GlobalHandler.getCompanyId();
    Utils().printMessage("CompanyId ==>" + companyId!);
    var body = {
      "userId": userId,
      "tenantId": companyId,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2]
    };
    materialRepoImpl.getMaterial(body: body).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        try {
          if (value.data != null) {
            try {
              var list = value.data!;
              if (list != null) {
                materialList.clear();
                materialList = List<MaterialData>.from(
                    list.map((model) => MaterialData.fromJson(model)));
                notifyListeners();
              }
            } catch (e) {
              Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
            }
          }

          loading = false;
          notifyListeners();
        } catch (e) {
          loading = false;
          Utils().printMessage("STATUS Failure ==>>> " + e.toString());
        }
        notifyListeners();
      } else {
        loading = false;
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    // notifyListeners();
  }

  //----------------EDIT-MATERIAL-----------------//
  editMaterialDetails(
      {required String materialName,
      required String materialRateUnitId,
      required String materialId,
      required String categoryId,
      required String subCategoryId,
      required String materialRate,
      required String materialType,
      required BuildContext context}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    await materialRepoImpl
        .editMaterialDetails(
            materialName: materialName,
            materialRateUnitId: materialRateUnitId,
            materialId: materialId,
            categoryId: categoryId,
            subCategoryId: subCategoryId,
            materialRate: materialRate,
            materialType: materialType,
            materialActiveStatus: '')
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        EasyLoading.dismiss();
        Utils().ShowSuccessSnackBar(
            context, "Success", value.message ?? "Successfully material added",
            duration: Duration(seconds: 2));

        await Future.delayed(Duration(seconds: 2));

        if (GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
            '/home/schedule') {
          Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        }
        GoRouter.of(context).pop();
        //Navigate.NavigateAndReplace(context, material_list, params: {});
        notifyListeners();
      }
    });
  }

  //----------------------DELETE MATERIAL---------------------//
  deleteMaterial(
      {required String materialId, required BuildContext context}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    await materialRepoImpl
        .deleteMaterial(materialId: materialId)
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        getMaterialListApi(context);
        EasyLoading.dismiss();
        loading = false;

        Utils().ShowSuccessSnackBar(context, "Success",
            value.message ?? "Successfully material Deleted",
            duration: Duration(seconds: 2));

        // await Future.delayed(Duration(seconds: 2));

        // if (GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
        //     '/home/schedule') {
        //   Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        // }
        GoRouter.of(context).pop();
        //Navigate.NavigateAndReplace(context, material_list, params: {});
        notifyListeners();
      }
    });
  }

  //---------------------ACTIVE-INACTIVE MATERIAL---------------------//
  activeInactiveCustomer(
      {required String materialID, required BuildContext context}) async {
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    await materialRepoImpl!
        .activeInactiveMaterial(
            activeStatus: isSwitched ? '1' : '0', materialID: materialID)
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        // getMaterialListApi(context);
        EasyLoading.dismiss();
        loading = false;
        // Utils().ShowSuccessSnackBar(context, "Success",
        //     value.message ?? "Successfully Customer Activated",
        //     duration: Duration(seconds: 2));
        // GoRouter.of(context).pop();
        notifyListeners();
      }
    });
  }

  //---------------------------ADD-UNIT--------------------------------//
  saveMaterialUnit(
      {required BuildContext context, required String unitName}) async {
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    await materialRepoImpl!
        .saveMaterialUnit(unitName: unitName)
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        getMaterialUnitListApi(context);
        EasyLoading.dismiss();
        loading = false;
        Utils().ShowSuccessSnackBar(
            context, "Success", value.message ?? "Successfully Unit Added",
            duration: Duration(seconds: 2));
        GoRouter.of(context).pop();
        notifyListeners();
      } else {
        Utils().ShowErrorSnackBar(context, "Failed", value.message.toString());
        EasyLoading.dismiss();
        // loading = false;
      }
    });
  }
}
