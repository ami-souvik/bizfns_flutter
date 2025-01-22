class MaterialUnitResponse {
  bool? success;
  String? message;
  List<UnitData>? data;

  MaterialUnitResponse({this.success, this.message, this.data});

  MaterialUnitResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UnitData>[];
      json['data'].forEach((v) {
        data!.add(UnitData.fromJson(v));
      });
    }
  }
}

class UnitData {
  int? unitId;
  String? unitName;

  UnitData({this.unitId, this.unitName});

  UnitData.fromJson(Map<String, dynamic> json) {
    unitId = json['unit_id'];
    unitName = json['unit_name'];
  }
}
