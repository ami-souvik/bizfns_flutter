class CustomerListModel {
  String? success;
  String? failure;
  String? message;
  List<Data>? data;

  CustomerListModel({this.success, this.failure, this.message, this.data});

  CustomerListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    failure = json['failure'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['failure'] = failure;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? cUSTOMERSTATUS;
  int? cUSTOMERPHONENUMBER;
  int? iSOTPVERIFIED;
  String? cUSTOMERFIRSTNAME;
  int? fKCOMPANYID;
  String? cUSTOMERPASSWORD;
  String? cUSTOMERLASTNAME;
  String? cUSTOMEREMAIL;
  String? cOMPANYCREATEDAT;
  int? pKCUSTOMERID;
  String? cOMPANYUPDATEDAT;
  int? lASTOTP;

  Data(
      {this.cUSTOMERSTATUS,
        this.cUSTOMERPHONENUMBER,
        this.iSOTPVERIFIED,
        this.cUSTOMERFIRSTNAME,
        this.fKCOMPANYID,
        this.cUSTOMERPASSWORD,
        this.cUSTOMERLASTNAME,
        this.cUSTOMEREMAIL,
        this.cOMPANYCREATEDAT,
        this.pKCUSTOMERID,
        this.cOMPANYUPDATEDAT,
        this.lASTOTP});

  Data.fromJson(Map<String, dynamic> json) {
    cUSTOMERSTATUS = json['CUSTOMER_STATUS'];
    cUSTOMERPHONENUMBER = json['CUSTOMER_PHONE_NUMBER'];
    iSOTPVERIFIED = json['IS_OTP_VERIFIED'];
    cUSTOMERFIRSTNAME = json['CUSTOMER_FIRST_NAME'];
    fKCOMPANYID = json['FK_COMPANY_ID'];
    cUSTOMERPASSWORD = json['CUSTOMER_PASSWORD'];
    cUSTOMERLASTNAME = json['CUSTOMER_LAST_NAME'];
    cUSTOMEREMAIL = json['CUSTOMER_EMAIL'];
    cOMPANYCREATEDAT = json['COMPANY_CREATED_AT'];
    pKCUSTOMERID = json['PK_CUSTOMER_ID'];
    cOMPANYUPDATEDAT = json['COMPANY_UPDATED_AT'];
    lASTOTP = json['LAST_OTP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CUSTOMER_STATUS'] = cUSTOMERSTATUS;
    data['CUSTOMER_PHONE_NUMBER'] = cUSTOMERPHONENUMBER;
    data['IS_OTP_VERIFIED'] = iSOTPVERIFIED;
    data['CUSTOMER_FIRST_NAME'] = cUSTOMERFIRSTNAME;
    data['FK_COMPANY_ID'] = fKCOMPANYID;
    data['CUSTOMER_PASSWORD'] = cUSTOMERPASSWORD;
    data['CUSTOMER_LAST_NAME'] = cUSTOMERLASTNAME;
    data['CUSTOMER_EMAIL'] = cUSTOMEREMAIL;
    data['COMPANY_CREATED_AT'] = cOMPANYCREATEDAT;
    data['PK_CUSTOMER_ID'] = pKCUSTOMERID;
    data['COMPANY_UPDATED_AT'] = cOMPANYUPDATEDAT;
    data['LAST_OTP'] = lASTOTP;
    return data;
  }
}