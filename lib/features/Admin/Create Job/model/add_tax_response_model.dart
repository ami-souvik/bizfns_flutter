class AddTaxResponseModel {
  bool? success;
  String? message;
  Data? data;

  AddTaxResponseModel({this.success, this.message, this.data});

  AddTaxResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? taxMasterId;
  String? taxMasterName;

  Data({this.taxMasterId, this.taxMasterName});

  Data.fromJson(Map<String, dynamic> json) {
    taxMasterId = json['taxMasterId'];
    taxMasterName = json['taxMasterName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taxMasterId'] = this.taxMasterId;
    data['taxMasterName'] = this.taxMasterName;
    return data;
  }
}
