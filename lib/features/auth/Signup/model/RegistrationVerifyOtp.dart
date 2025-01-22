class RegistrationVerifyOtp {
  bool? success;
  String? message;
  Object? data;

  RegistrationVerifyOtp({this.success, this.message, this.data});

  RegistrationVerifyOtp.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = Object;
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data;
    }
    return data;
  }
}


