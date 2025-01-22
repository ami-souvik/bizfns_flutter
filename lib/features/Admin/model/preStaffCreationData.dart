class PreStaffCreationData {
  bool? success;
  String? message;
  StaffCreationData? data;

  PreStaffCreationData({this.success, this.message, this.data});

  PreStaffCreationData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['response'] != null ? new StaffCreationData.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['response'] = this.data!.toJson();
    }
    return data;
  }
}

class StaffCreationData {
  List<StaffTypeDetailsList>? staffTypeDetailsList;
  List<WageFrequencyDetailsList>? wageFrequencyDetailsList;

  StaffCreationData({this.staffTypeDetailsList, this.wageFrequencyDetailsList});

  StaffCreationData.fromJson(Map<String, dynamic> json) {
    if (json['staffTypeDetailsList'] != null) {
      staffTypeDetailsList = <StaffTypeDetailsList>[];
      json['staffTypeDetailsList'].forEach((v) {
        staffTypeDetailsList!.add(new StaffTypeDetailsList.fromJson(v));
      });
    }
    if (json['wageFrequencyDetailsList'] != null) {
      wageFrequencyDetailsList = <WageFrequencyDetailsList>[];
      json['wageFrequencyDetailsList'].forEach((v) {
        wageFrequencyDetailsList!.add(new WageFrequencyDetailsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.staffTypeDetailsList != null) {
      data['staffTypeDetailsList'] =
          this.staffTypeDetailsList!.map((v) => v.toJson()).toList();
    }
    if (this.wageFrequencyDetailsList != null) {
      data['wageFrequencyDetailsList'] =
          this.wageFrequencyDetailsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffTypeDetailsList {
  int? pKTYPEID;
  String? tYPENAME;

  StaffTypeDetailsList({this.pKTYPEID, this.tYPENAME});

  StaffTypeDetailsList.fromJson(Map<String, dynamic> json) {
    pKTYPEID = json['PK_TYPE_ID'];
    tYPENAME = json['TYPE_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PK_TYPE_ID'] = this.pKTYPEID;
    data['TYPE_NAME'] = this.tYPENAME;
    return data;
  }
}

class WageFrequencyDetailsList {
  int? pKFREQUENCYID;
  String? fREQUENCYTYPE;

  WageFrequencyDetailsList({this.pKFREQUENCYID, this.fREQUENCYTYPE});

  WageFrequencyDetailsList.fromJson(Map<String, dynamic> json) {
    pKFREQUENCYID = json['PK_FREQUENCY_ID'];
    fREQUENCYTYPE = json['FREQUENCY_TYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PK_FREQUENCY_ID'] = this.pKFREQUENCYID;
    data['FREQUENCY_TYPE'] = this.fREQUENCYTYPE;
    return data;
  }
}
