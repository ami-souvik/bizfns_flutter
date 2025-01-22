class GetJobStatusResponse {
  bool? success;
  String? message;
  Data? data;

  GetJobStatusResponse({this.success, this.message, this.data});

  GetJobStatusResponse.fromJson(Map<String, dynamic> json) {
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
  int? jobId;
  String? statuses;

  Data({this.jobId, this.statuses});

  Data.fromJson(Map<String, dynamic> json) {
    jobId = json['jobId'];
    statuses = json['statuses'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jobId'] = this.jobId;
    data['statuses'] = this.statuses;
    return data;
  }
}
