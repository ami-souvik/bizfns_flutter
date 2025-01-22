class SignupOtpModel {
  bool? success;
  String? message;
  SignupOtpData? data;

  SignupOtpModel({this.success, this.message, this.data});

  SignupOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new SignupOtpData.fromJson(json['data']) : null;
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

class SignupOtpData {
  String? otpMessage;
  String? otp;

  SignupOtpData({this.otpMessage, this.otp});

  SignupOtpData.fromJson(Map<String, dynamic> json) {
    otpMessage = json['otp_message'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp_message'] = this.otpMessage;
    data['otp'] = this.otp;
    return data;
  }
}
