class ChangePasswordResponse {
  bool? success;
  String? message;
  ChangePasswordData? data;

  ChangePasswordResponse({this.success, this.message, this.data});

  ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new ChangePasswordData.fromJson(json['data']) : null;
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

class ChangePasswordData {
  String? oTP;
  String? otpTimeStamp;
  String? message;

  ChangePasswordData({this.oTP, this.otpTimeStamp, this.message});

  ChangePasswordData.fromJson(Map<String, dynamic> json) {
    oTP = json['OTP'];
    otpTimeStamp = json['otpTimeStamp'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OTP'] = this.oTP;
    data['otpTimeStamp'] = this.otpTimeStamp;
    data['message'] = this.message;
    return data;
  }
}
