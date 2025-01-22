class TimeSheetByBillNoAndStaffModel {
  bool? success;
  String? message;
  Data? data;

  TimeSheetByBillNoAndStaffModel({this.success, this.message, this.data});

  TimeSheetByBillNoAndStaffModel.fromJson(Map<String, dynamic> json) {
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
  String? timesheetBillNo;
  double? totalOvertimeHour;
  double? totalRegularCost;
  List<TimeSheetData>? timeSheetData;
  StaffDetails? staffDetails;
  double? totalPayableCost;
  int? weekNumber;
  int? timesheetId;
  double? totalRegularHour;
  String? weekStartDate;
  double? totalOvertimeCost;
  String? weekEndDate;
  String? timeSheetStatus;

  Data(
      {this.timesheetBillNo,
      this.totalOvertimeHour,
      this.totalRegularCost,
      this.timeSheetData,
      this.staffDetails,
      this.totalPayableCost,
      this.weekNumber,
      this.timesheetId,
      this.totalRegularHour,
      this.weekStartDate,
      this.totalOvertimeCost,
      this.weekEndDate,
      this.timeSheetStatus});

  Data.fromJson(Map<String, dynamic> json) {
    timesheetBillNo = json['timesheetBillNo'];
    totalOvertimeHour = json['totalOvertimeHour'];
    totalRegularCost = json['totalRegularCost'];
    if (json['timeSheetData'] != null) {
      timeSheetData = <TimeSheetData>[];
      json['timeSheetData'].forEach((v) {
        timeSheetData!.add(new TimeSheetData.fromJson(v));
      });
    }
    staffDetails = json['staffDetails'] != null
        ? new StaffDetails.fromJson(json['staffDetails'])
        : null;
    totalPayableCost = json['totalPayableCost'];
    weekNumber = json['weekNumber'];
    timesheetId = json['timesheetId'];
    totalRegularHour = json['totalRegularHour'];
    weekStartDate = json['weekStartDate'];
    totalOvertimeCost = json['totalOvertimeCost'];
    weekEndDate = json['weekEndDate'];
    timeSheetStatus = json['timeSheetStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timesheetBillNo'] = this.timesheetBillNo;
    data['totalOvertimeHour'] = this.totalOvertimeHour;
    data['totalRegularCost'] = this.totalRegularCost;
    if (this.timeSheetData != null) {
      data['timeSheetData'] =
          this.timeSheetData!.map((v) => v.toJson()).toList();
    }
    if (this.staffDetails != null) {
      data['staffDetails'] = this.staffDetails!.toJson();
    }
    data['totalPayableCost'] = this.totalPayableCost;
    data['weekNumber'] = this.weekNumber;
    data['timesheetId'] = this.timesheetId;
    data['totalRegularHour'] = this.totalRegularHour;
    data['weekStartDate'] = this.weekStartDate;
    data['totalOvertimeCost'] = this.totalOvertimeCost;
    data['weekEndDate'] = this.weekEndDate;
    data['timeSheetStatus'] = this.timeSheetStatus;
    return data;
  }
}

class TimeSheetData {
  String? jobEvents;
  double? regularHour;
  String? dateOfWeek;
  double? overtimeHour;

  TimeSheetData(
      {this.jobEvents, this.regularHour, this.dateOfWeek, this.overtimeHour});

  TimeSheetData.fromJson(Map<String, dynamic> json) {
    jobEvents = json['jobEvents'];
    regularHour = json['regularHour'];
    dateOfWeek = json['dateOfWeek'];
    overtimeHour = json['overtimeHour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jobEvents'] = this.jobEvents;
    data['regularHour'] = this.regularHour;
    data['dateOfWeek'] = this.dateOfWeek;
    data['overtimeHour'] = this.overtimeHour;
    return data;
  }
}

class StaffDetails {
  String? staffName;
  String? staffId;
  String? staffPhoneNo;

  StaffDetails({this.staffName, this.staffId, this.staffPhoneNo});

  StaffDetails.fromJson(Map<String, dynamic> json) {
    staffName = json['staffName'];
    staffId = json['staffId'];
    staffPhoneNo = json['staffPhoneNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staffName'] = this.staffName;
    data['staffId'] = this.staffId;
    data['staffPhoneNo'] = this.staffPhoneNo;
    return data;
  }
}
