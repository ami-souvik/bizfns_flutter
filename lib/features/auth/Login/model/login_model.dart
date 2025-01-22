class LoginModel {
  bool? success;
  String? message;
  LoginData? data;

  LoginModel({this.success, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
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

class LoginData {
  int? otp;
  String? otp_message;
  String? otpTimeStamp;
  String? token;

  LoginData({this.otp, this.otpTimeStamp, this.otp_message, this.token});

  LoginData.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    otp_message = json['otp_message'];
    otpTimeStamp = json['otpTimeStamp'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['otpTimeStamp'] = this.otpTimeStamp;
    data['token'] = this.token;
    return data;
  }
}
