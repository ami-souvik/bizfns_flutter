class ReccurrDateModel {
  bool? success;
  String? message;
  List<ReccurrData>? data;

  ReccurrDateModel({this.success, this.message, this.data});

  ReccurrDateModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ReccurrData>[];
      json['data'].forEach((v) {
        data!.add(ReccurrData.fromJson(v));
      });
    }
  }
}

class ReccurrData {
  String? startTime;
  String? endTime;
  int? status;

  ReccurrData({this.startTime, this.endTime});

  ReccurrData.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    status = json['status'] == null ? 0 : int.parse(json['status']);
  }
}
