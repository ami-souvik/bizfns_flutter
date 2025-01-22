class ServiceListResponse {
  bool? success;
  String? message;
  List<ServiceListData>? data;

  ServiceListResponse({this.success, this.message, this.data});

  ServiceListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['response'] != null) {
      data = <ServiceListData>[];
      json['response'].forEach((v) {
        data!.add(new ServiceListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['response'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceListData {
  String ? activeInactiveStatus;
  int? serviceRate;
  int? serviceId;
  String? serviceName;

  ServiceListData({this.activeInactiveStatus,this.serviceRate, this.serviceId, this.serviceName});

  ServiceListData.fromJson(Map<String, dynamic> json) {
    serviceRate = json['serviceRate'];
    serviceId = json['serviceId'];
    serviceName = json['serviceName'];
    activeInactiveStatus = json['serviceActive/InactiveStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceActive/InactiveStatus'] = this.activeInactiveStatus;
    data['serviceRate'] = this.serviceRate;
    data['serviceId'] = this.serviceId;
    data['serviceName'] = this.serviceName;
    return data;
  }
}
