class StaffListResponseModel {
  StaffListResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<StaffListData> data;

  StaffListResponseModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>StaffListData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class StaffListData {
  StaffListData({
    required this.staffFirstName,
    required this.staffCreatedAt,
    required this.staffLastName,
    required this.staffStatus,
    required this.staffEmail,
    required this.staffPhoneNo,
    required this.staffAddress,
    required this.jobList,
    required this.staffId,
    required this.activeStatus
  });
  late final String staffFirstName;
  late final String staffCreatedAt;
  late final String staffLastName;
  late final String staffStatus;
  late final String staffEmail;
  late final String staffPhoneNo;
  late final String staffAddress;
  late final List<dynamic> jobList;
  late final String staffId;
  late final String activeStatus;

  StaffListData.fromJson(Map<String, dynamic> json){
    staffFirstName = json['staffFirstName'];
    staffCreatedAt = json['staffCreatedAt'];
    staffLastName = json['staffLastName'];
    staffStatus = json['staffStatus'] ?? "";
    staffEmail = json['staffEmail'];
    staffPhoneNo = json['staffPhoneNo'];
    staffAddress = json['staffAddress'];
    jobList = List.castFrom<dynamic, dynamic>(json['jobList']);
    staffId = json['staffId'];
    activeStatus = json['activeStatus'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['staffFirstName'] = staffFirstName;
    _data['staffCreatedAt'] = staffCreatedAt;
    _data['staffLastName'] = staffLastName;
    _data['staffStatus'] = staffStatus;
    _data['staffEmail'] = staffEmail;
    _data['staffPhoneNo'] = staffPhoneNo;
    _data['staffAddress'] = staffAddress;
    _data['jobList'] = jobList;
    _data['staffId'] = staffId;
    return _data;
  }
}