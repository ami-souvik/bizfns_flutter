// class CustomerServiceHistoryModel {
//   CustomerServiceHistoryModel({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   final bool? success;
//   final String? message;
//   final List<List<Datum>> data;

//   factory CustomerServiceHistoryModel.fromJson(Map<String, dynamic> json) {
//     return CustomerServiceHistoryModel(
//       success: json["success"],
//       message: json["message"],
//       data: json["data"] == null
//           ? []
//           : List<List<Datum>>.from(json["data"]!.map((x) => x == null
//               ? []
//               : List<Datum>.from(x!.map((x) => Datum.fromJson(x))))),
//     );
//   }
// }

// class Datum {
//   Datum({
//     required this.jobs,
//     required this.customerId,
//     required this.customerName,
//   });

//   final List<Job> jobs;
//   final int? customerId;
//   final String? customerName;

//   factory Datum.fromJson(Map<String, dynamic> json) {
//     return Datum(
//       jobs: json["jobs"] == null
//           ? []
//           : List<Job>.from(json["jobs"]!.map((x) => Job.fromJson(x))),
//       customerId: json["customerId"],
//       customerName: json["customerName"],
//     );
//   }
// }

// class Job {
//   Job({
//     required this.date,
//     required this.jobId,
//     required this.images,
//     required this.notes,
//     required this.services,
//   });

//   final int? date;
//   final int? jobId;
//   final List<String> images;
//   final String? notes;
//   final List<String> services;

//   factory Job.fromJson(Map<String, dynamic> json) {
//     return Job(
//       date: json["date"],
//       jobId: json["jobId"],
//       images: json["images"] == null
//           ? []
//           : List<String>.from(json["images"]!.map((x) => x)),
//       notes: json["notes"],
//       services: json["services"] == null
//           ? []
//           : List<String>.from(json["services"]!.map((x) => x)),
//     );
//   }
// }

// class Hist {
//   String? date;
//   int? jobId;
//   List<String>? images;
//   String? notes;
//   List<String>? services;

//   Hist({this.date, this.jobId, this.images, this.notes, this.services});

//   Hist.fromJson(Map<String, dynamic> json) {
//     date = json['date'];
//     jobId = json['jobId'];
//     images = json['images'].cast<String>();
//     notes = json['notes'];
//     services = json['services'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['date'] = this.date;
//     data['jobId'] = this.jobId;
//     data['images'] = this.images;
//     data['notes'] = this.notes;
//     data['services'] = this.services;
//     return data;
//   }
// }

class Hist {
  String? date;
  int? jobId;
  List<String>? images;
  String? notes;
  int? customerId;
  List<String>? services;
  String? customerName;

  Hist(
      {this.date,
      this.jobId,
      this.images,
      this.notes,
      this.customerId,
      this.services,
      this.customerName});

  Hist.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    jobId = json['jobId'];
    images = json['images'].cast<String>();
    notes = json['notes'];
    customerId = json['customerId'];
    services = json['services'].cast<String>();
    customerName = json['customerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['jobId'] = this.jobId;
    data['images'] = this.images;
    data['notes'] = this.notes;
    data['customerId'] = this.customerId;
    data['services'] = this.services;
    data['customerName'] = this.customerName;
    return data;
  }
}

