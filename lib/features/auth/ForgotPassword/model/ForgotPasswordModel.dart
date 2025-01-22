class ForgotPasswordModel {
  bool? success;
  String? message;
  ForgotPasswordData? data;

  ForgotPasswordModel({this.success, this.message, this.data});

  ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new ForgotPasswordData.fromJson(json['data']) : null;
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

class ForgotPasswordData {
  String? otpMsg;
  int? otp;
  String? otpTimeStamp;

  ForgotPasswordData({this.otpMsg, this.otp, this.otpTimeStamp});

  ForgotPasswordData.fromJson(Map<String, dynamic> json) {
    otpMsg = json['otpMsg'];
    otp = json['otp'];
    otpTimeStamp = json['otpTimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otpMsg'] = this.otpMsg;
    data['otp'] = this.otp;
    data['otpTimeStamp'] = this.otpTimeStamp;
    return data;
  }
}

