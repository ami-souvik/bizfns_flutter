class LoginOtpVerificationModel {
  bool? success;
  String? message;
  List<OtpVerificationData>? data;

  LoginOtpVerificationModel({this.success, this.message, this.data});

  LoginOtpVerificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OtpVerificationData>[];
      json['data'].forEach((v) {
        data!.add(new OtpVerificationData.fromJson(v));
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

class OtpVerificationData {
  String? userTypeId;
  String? cOMPANYBACKUPPHONENUMBER;
  String? isSequrityQuestionAnswered;
  String? sTAFFBACKUPPHONENUMBER;
  String? bUSINESSNAME;
  String? logoAddress;
  String? tenantId;
  String? businessLogo;
  String? cOMPANYBACKUPEMAIL;
  String? userType;
  int? cOMPANYID;
  String? token;

  OtpVerificationData(
      {this.userTypeId,
      this.cOMPANYBACKUPPHONENUMBER,
      this.isSequrityQuestionAnswered,
      this.sTAFFBACKUPPHONENUMBER,
      this.bUSINESSNAME,
      this.logoAddress,
      this.tenantId,
      this.businessLogo,
      this.cOMPANYBACKUPEMAIL,
      this.userType,
      this.cOMPANYID,
      this.token});

  OtpVerificationData.fromJson(Map<String, dynamic> json) {
    print(
        "json['STAFF_BACKUP_PHONE_NUMBER'] : ${json['STAFF_BACKUP_PHONE_NUMBER']}");
    userTypeId = json['userTypeId'];
    cOMPANYBACKUPPHONENUMBER = json['COMPANY_BACKUP_PHONE_NUMBER'];
    isSequrityQuestionAnswered = json['isSequrityQuestionAnswered'];
    sTAFFBACKUPPHONENUMBER = json['STAFF_BACKUP_PHONE_NUMBER'] ?? "";
    bUSINESSNAME = json['BUSINESS_NAME'];
    logoAddress = json['logoAddress'];
    tenantId = json['tenantId'];
    businessLogo = json['businessLogo'];
    cOMPANYBACKUPEMAIL = json['COMPANY_BACKUP_EMAIL'];
    userType = json['userType'];
    cOMPANYID = json['COMPANY_ID'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userTypeId'] = this.userTypeId;
    data['COMPANY_BACKUP_PHONE_NUMBER'] = this.cOMPANYBACKUPPHONENUMBER;
    data['isSequrityQuestionAnswered'] = this.isSequrityQuestionAnswered;
    data['STAFF_BACKUP_PHONE_NUMBER'] = this.sTAFFBACKUPPHONENUMBER;
    data['BUSINESS_NAME'] = this.bUSINESSNAME;
    data['logoAddress'] = this.logoAddress;
    data['tenantId'] = this.tenantId;
    data['businessLogo'] = this.businessLogo;
    data['COMPANY_BACKUP_EMAIL'] = this.cOMPANYBACKUPEMAIL;
    data['userType'] = this.userType;
    data['COMPANY_ID'] = this.cOMPANYID;
    data['token'] = this.token;
    return data;
  }
}
