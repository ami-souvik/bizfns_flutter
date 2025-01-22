class ScheduleListResponse {
  bool? success;
  String? message;
  List<JobScheduleData>? data;

  ScheduleListResponse({this.success, this.message, this.data});

  ScheduleListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <JobScheduleData>[];
      json['data'].forEach((v) {
        data!.add(JobScheduleData.fromJson(v));
      });
    }
  }
}

class JobScheduleData {
  String? date;
  List<ScheduleList>? jobList;

  JobScheduleData({this.date, this.jobList});

  JobScheduleData.fromJson(Map<String, dynamic> json) {
    try {
      date = json['date'];
      if (json['schedule_list'] != null) {
        jobList = <ScheduleList>[];
        json['schedule_list'].forEach((v) {
          jobList!.add(ScheduleList.fromJson(v));
        });
      }
    } catch (e) {
      print('Catch1: $e');
    }
  }
}

class ScheduleList {
  List<Schedule>? schedule;
  String? time;

  ScheduleList({this.schedule, this.time});

  ScheduleList.fromJson(Map<String, dynamic> json) {
    try {
      if (json['schedule'] != null) {
        schedule = <Schedule>[];
        json['schedule'].forEach((v) {
          schedule!.add(new Schedule.fromJson(v));
        });
      }
      time = json['time'];
    } catch (e) {
      print('Catch1a: $e');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.schedule != null) {
      data['schedule'] = this.schedule!.map((v) => v.toJson()).toList();
    }
    data['time'] = this.time;
    return data;
  }
}

class Schedule {
  String? startTime;

  //String? jobStatus;
  String? jobId;
  String? materialID;
  String? jobNo;
  String? endTime;
  List<Staff>? staff;
  List<ServiceId>? serviceID;
  List<Customer>? customer;
  int? jobStatus;
  String? serviceEntityID;

  Schedule({
    this.jobId,
    this.jobNo,
    this.staff,
    this.customer,
    this.materialID,
    this.serviceID,
    this.startTime,
    this.endTime,
    this.jobStatus,
    this.serviceEntityID,
  });

  Schedule.fromJson(Map<String, dynamic> json) {
    try {
      jobId = json['job_id'];
      materialID = json['matId'];
      //serviceID = json['serviceId'];
      startTime = json['start_time'] ?? '10:00:00';
      endTime = json['end_time'] ?? '17:00:00';
      jobNo = json['job_no'];
      serviceEntityID = json['service_entity_id'] ?? '';
      jobStatus = json['job_status'] == null
          ? 0
          : json["job_status"] == "Created"
              ? 0
              : int.parse(json["job_status"].toString());
      if (json['serviceId'] != null) {
        try {
          serviceID = <ServiceId>[];
          json['serviceId'].forEach((v) {
            serviceID!.add(ServiceId.fromJson(v));
          });
        } catch (e) {
          print('Catch to get services: $e');
        }
      }
      if (json['staff'] != null) {
        staff = <Staff>[];
        json['staff'].forEach((v) {
          staff!.add(new Staff.fromJson(v));
        });
      }
      if (json['customer'] != null) {
        customer = <Customer>[];
        json['customer'].forEach((v) {
          customer!.add(new Customer.fromJson(v));
        });
      }
    } catch (e) {
      print('catch3: $e');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_id'] = this.jobId;
    data['job_no'] = this.jobNo;
    if (this.staff != null) {
      data['staff'] = this.staff!.map((v) => v.toJson()).toList();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Staff {
  String? staffName;
  String? staffId;

  Staff({this.staffName, this.staffId});

  Staff.fromJson(Map<String, dynamic> json) {
    staffName = json['staff_name'];
    staffId = json['staff_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_name'] = this.staffName;
    data['staff_id'] = this.staffId;
    return data;
  }
}

class ServiceId {
  String? sERVICENAME;
  String? serviceId;

  ServiceId({this.sERVICENAME, this.serviceId});

  ServiceId.fromJson(Map<String, dynamic> json) {
    sERVICENAME = json['SERVICE_NAME'];
    serviceId = json['serviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SERVICE_NAME'] = this.sERVICENAME;
    data['serviceId'] = this.serviceId;
    return data;
  }
}

class Customer {
  String? customerName;
  String? customerId;

  Customer({this.customerName, this.customerId});

  Customer.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_Name'];
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_Name'] = this.customerName;
    data['customer_id'] = this.customerId;
    return data;
  }
}
