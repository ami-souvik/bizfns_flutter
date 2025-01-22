class GetJobNumberByDateModel {
  bool? success;
  String? message;
  GetJobNumberByData? data;

  GetJobNumberByDateModel({this.success, this.message, this.data});

  GetJobNumberByDateModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new GetJobNumberByData.fromJson(json['data']) : null;
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

class GetJobNumberByData {
  List<JobDetails>? jobDetails;

  GetJobNumberByData({this.jobDetails});

  GetJobNumberByData.fromJson(Map<String, dynamic> json) {
    if (json['jobDetails'] != null) {
      jobDetails = <JobDetails>[];
      json['jobDetails'].forEach((v) {
        jobDetails!.add(new JobDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jobDetails != null) {
      data['jobDetails'] = this.jobDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobDetails {
  int? jobId;
  String? jobNumber;

  JobDetails({this.jobId, this.jobNumber});

  JobDetails.fromJson(Map<String, dynamic> json) {
    jobId = json['jobId'];
    jobNumber = json['jobNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jobId'] = this.jobId;
    data['jobNumber'] = this.jobNumber;
    return data;
  }
}
