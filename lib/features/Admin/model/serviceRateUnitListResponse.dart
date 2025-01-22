class ServiceRateUnitListResponse {
  bool? success;
  String? message;
  List<ServiceRateUnit>? data;

  ServiceRateUnitListResponse({this.success, this.message, this.data});

  ServiceRateUnitListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['response'] != null) {
      data = <ServiceRateUnit>[];
      json['response'].forEach((v) {
        data!.add(new ServiceRateUnit.fromJson(v));
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

class ServiceRateUnit {
  String? sTATUS;
  String? rATEUNITNAME;
  int? iD;

  ServiceRateUnit({this.sTATUS, this.rATEUNITNAME, this.iD});

  ServiceRateUnit.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    rATEUNITNAME = json['RATE_UNIT_NAME'];
    iD = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS'] = this.sTATUS;
    data['RATE_UNIT_NAME'] = this.rATEUNITNAME;
    data['ID'] = this.iD;
    return data;
  }
}
