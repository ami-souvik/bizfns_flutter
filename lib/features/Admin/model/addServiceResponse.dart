class AddServiceResponse {
  bool? success;
  String? message;
  ServiceData? data;

  AddServiceResponse({this.success, this.message, this.data});

  AddServiceResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new ServiceData.fromJson(json['data']) : null;
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

class ServiceData {
  int? serviceId;
  String? serviceName;

  ServiceData({this.serviceId, this.serviceName});

  ServiceData.fromJson(Map<String, dynamic> json) {
    serviceId = json['serviceId'];
    serviceName = json['serviceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceId'] = this.serviceId;
    data['serviceName'] = this.serviceName;
    return data;
  }
}
