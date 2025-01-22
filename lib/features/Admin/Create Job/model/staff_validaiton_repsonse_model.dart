// class StaffValidationResponseModel {
//   bool? status;
//   String? message;
//   List<StaffValidationData>? data;

//   StaffValidationResponseModel({this.status, this.message, this.data});

//   StaffValidationResponseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <StaffValidationData>[];
//       json['data'].forEach((v) {
//         data!.add(StaffValidationData.fromJson(v));
//       });
//     }
//   }
// }

// class StaffValidationData {
//   String? uSERFIRSTNAME;
//   String? uSERLASTNAME;
//   int? status;

//   StaffValidationData({this.uSERFIRSTNAME, this.uSERLASTNAME, this.status});

//   StaffValidationData.fromJson(Map<String, dynamic> json) {
//     uSERFIRSTNAME = json['USER_FIRST_NAME'];
//     uSERLASTNAME = json['USER_LAST_NAME'];
//     status = json['status'] == null ? 0 : int.parse(json['status']);
//   }
// }


class StaffValidationResponseModel {
  bool? success;
  String? message;
  List<StaffValidationData>? data;

  StaffValidationResponseModel({this.success, this.message, this.data});

  StaffValidationResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StaffValidationData>[];
      json['data'].forEach((v) {
        data!.add(new StaffValidationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffValidationData {
  int? availability;
  String? userID;
  String? uSERFIRSTNAME;
  String? uSERLASTNAME;

  StaffValidationData({this.availability, this.userID, this.uSERFIRSTNAME, this.uSERLASTNAME});

  StaffValidationData.fromJson(Map<String, dynamic> json) {
    availability = json['Availability'];
    userID = json['User ID'];
    uSERFIRSTNAME = json['USER_FIRST_NAME'];
    uSERLASTNAME = json['USER_LAST_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Availability'] = this.availability;
    data['User ID'] = this.userID;
    data['USER_FIRST_NAME'] = this.uSERFIRSTNAME;
    data['USER_LAST_NAME'] = this.uSERLASTNAME;
    return data;
  }
}
