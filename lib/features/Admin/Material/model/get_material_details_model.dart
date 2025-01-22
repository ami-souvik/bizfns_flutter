class GetMaterialDetailsModel {
  bool? success;
  String? message;
  MaterialDetailsData? response;

  GetMaterialDetailsModel({this.success, this.message, this.response});

  GetMaterialDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    response = json['data'] != null
        ? new MaterialDetailsData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['data'] = this.response!.toJson();
    }
    return data;
  }
}

class MaterialDetailsData {
  int? materialId;
  String? materialName;
  String? materialRate;
  String? activeStatus;
  String? materialType;
  int? subcategoryId;
  int? materialRateUnitId;
  int? categoryId;

  MaterialDetailsData(
      {this.materialName,
      this.materialRate,
      this.activeStatus,
      this.materialType,
      this.subcategoryId,
      this.materialRateUnitId,
      this.categoryId,
      this.materialId
      });

  MaterialDetailsData.fromJson(Map<String, dynamic> json) {
    materialId = json['materialId'];
    materialName = json['materialName'];
    materialRate = json['materialRate'];
    activeStatus = json['activeStatus'];
    materialType = json['materialType'];
    subcategoryId = json['subcategoryId'];
    materialRateUnitId = json['materialRateUnitId'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['materialId'] = this.materialId;
    data['materialName'] = this.materialName;
    data['materialRate'] = this.materialRate;
    data['activeStatus'] = this.activeStatus;
    data['materialType'] = this.materialType;
    data['subcategoryId'] = this.subcategoryId;
    data['materialRateUnitId'] = this.materialRateUnitId;
    data['categoryId'] = this.categoryId;
    return data;
  }
}
