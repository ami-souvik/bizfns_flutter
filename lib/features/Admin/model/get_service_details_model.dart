class GetServiceDetailsModel {
  bool? success;
  String? message;
  ServiceDetailsData? response;

  GetServiceDetailsModel({this.success, this.message, this.response});

  GetServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    response = json['data'] != null
        ? new ServiceDetailsData.fromJson(json['data'])
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

class ServiceDetailsData {
  int? iD;
  String? sERVICENAME;
  int? rATE;
  String? sTATUS;
  int? rATEUNIT;

  ServiceDetailsData({this.iD, this.sERVICENAME, this.rATE, this.sTATUS, this.rATEUNIT});

  ServiceDetailsData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    sERVICENAME = json['SERVICE_NAME'];
    rATE = json['RATE'];
    sTATUS = json['STATUS'];
    rATEUNIT = json['RATE_UNIT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['SERVICE_NAME'] = this.sERVICENAME;
    data['RATE'] = this.rATE;
    data['STATUS'] = this.sTATUS;
    data['RATE_UNIT'] = this.rATEUNIT;
    return data;
  }
}
