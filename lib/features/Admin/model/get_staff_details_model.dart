class GetStaffDetailsModel {
  bool? success;
  String? message;
  StaffDetailsData? response;

  GetStaffDetailsModel({this.success, this.message, this.response});

  GetStaffDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new StaffDetailsData.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class StaffDetailsData {
  String? stafffirstname;
  String? stafflastname;
  int? staffid;
  String? staffemail;
  String? staffmobile;
  int? stafftype;
  int? companyid;
  double? chargerate;
  int? chargefrequency;
  String? staffactiveinactivestatus;

  StaffDetailsData(
      {this.stafffirstname,
      this.stafflastname,
      this.staffid,
      this.staffemail,
      this.staffmobile,
      this.stafftype,
      this.companyid,
      this.chargerate,
      this.chargefrequency,
      this.staffactiveinactivestatus});

  StaffDetailsData.fromJson(Map<String, dynamic> json) {
    stafffirstname = json['stafffirstname'];
    stafflastname = json['stafflastname'];
    staffid = json['staffid'];
    staffemail = json['staffemail'];
    staffmobile = json['staffmobile'];
    stafftype = json['stafftype'];
    companyid = json['companyid'];
    chargerate = json['chargerate'];
    chargefrequency = json['chargefrequency'];
    staffactiveinactivestatus = json['staffactiveinactivestatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stafffirstname'] = this.stafffirstname;
    data['stafflastname'] = this.stafflastname;
    data['staffid'] = this.staffid;
    data['staffemail'] = this.staffemail;
    data['staffmobile'] = this.staffmobile;
    data['stafftype'] = this.stafftype;
    data['companyid'] = this.companyid;
    data['chargerate'] = this.chargerate;
    data['chargefrequency'] = this.chargefrequency;
    data['staffactiveinactivestatus'] = this.staffactiveinactivestatus;
    return data;
  }
}
