class MaterialListResponse {
  bool? success;
  String? message;
  List<MaterialData>? data;

  MaterialListResponse({this.success, this.message, this.data});

  MaterialListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MaterialData>[];
      json['data'].forEach((v) {
        data!.add(new MaterialData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MaterialData {
  String? materialName;
  String? materialRate;
  String? materialType;
  int? materialId;
  int? materialCategory;
  String? activeStatus;

  MaterialData(
      {this.materialName,
        this.materialRate,
        this.materialType,
        this.materialId,
        this.materialCategory,
        this.activeStatus
        });

  MaterialData.fromJson(Map<String, dynamic> json) {
    materialName = json['materialName'];
    materialRate = json['materialRate'];
    materialType = json['materialType'];
    materialId = json['materialId'];
    materialCategory = json['materialCategory'];
    activeStatus = json['activeStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['materialName'] = this.materialName;
    data['materialRate'] = this.materialRate;
    data['materialType'] = this.materialType;
    data['materialId'] = this.materialId;
    data['materialCategory'] = this.materialCategory;
    data['activeStatus'] = this.activeStatus;
    return data;
  }
}
