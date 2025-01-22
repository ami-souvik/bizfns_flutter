class ForgotBusinessIdResponse {
  bool? success;
  String? message;
  List<ForgotBusinessIdData>? data;

  ForgotBusinessIdResponse({this.success, this.message, this.data});

  ForgotBusinessIdResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ForgotBusinessIdData>[];
      json['data'].forEach((v) {
        data!.add(new ForgotBusinessIdData.fromJson(v));
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

class ForgotBusinessIdData {
  String? sCHEMANAME;
  String? bUSINESSNAME;

  ForgotBusinessIdData({this.sCHEMANAME, this.bUSINESSNAME});

  ForgotBusinessIdData.fromJson(Map<String, dynamic> json) {
    sCHEMANAME = json['SCHEMA_NAME'];
    bUSINESSNAME = json['BUSINESS_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SCHEMA_NAME'] = this.sCHEMANAME;
    data['BUSINESS_NAME'] = this.bUSINESSNAME;
    return data;
  }
}
