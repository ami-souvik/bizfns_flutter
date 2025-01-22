class SaveJobStatusResponse {
  bool? success;
  String? message;
  Data? data;

  SaveJobStatusResponse({this.success, this.message, this.data});

  SaveJobStatusResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String? jobId;
  String? jobStatus;

  Data({this.jobId, this.jobStatus});

  Data.fromJson(Map<String, dynamic> json) {
    jobId = json['jobId'];
    jobStatus = json['jobStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jobId'] = this.jobId;
    data['jobStatus'] = this.jobStatus;
    return data;
  }
}
