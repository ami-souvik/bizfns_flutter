class ScheduleListResponseModel {
  bool? success;
  String? message;
  List<ScheduleData>? data;

  ScheduleListResponseModel({this.success, this.message, this.data});

  ScheduleListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ScheduleData>[];
      json['data'].forEach((v) {
        data!.add(ScheduleData.fromJson(v));
      });
    }
  }
}

class ScheduleData {
  List<ScheduleModel>? schedule;
  String? time;

  ScheduleData({this.schedule, this.time});

  ScheduleData.fromJson(Map<String, dynamic> json) {
    if (json['schedule'] != null) {
      schedule = <ScheduleModel>[];
      json['schedule'].forEach((v) {
        schedule!.add(ScheduleModel.fromJson(v));
      });
    }
    time = json['time'];
  }
}

class ScheduleModel {
  String? jOBLOCATION;
  String? jOBSTATUS;
  String? endDate;
  String? custInvoiceCreatedIds;
  String? pKJOBID;
  List<Null>? invoiceList;
  String? jOBSTARTTIME;
  List<CustomersList>? customersList;
  String? jOBNOTES;
  // String? jOBMATERIAL;
  List<JOBMATERIAL>? jOBMATERIAL;
  String? paymentDeposit;
  String? paymentDuration;
  String? jOBENDTIME;
  List<Services>? serviceList; 
  List<StaffList>? staffList;
  String? startDate;
  String? imageId;
  List<ImageList>? imageList;

  ScheduleModel(
      {this.jOBLOCATION,
      this.jOBSTATUS,
      this.endDate,
      this.custInvoiceCreatedIds,
      this.pKJOBID,
      this.invoiceList,
      this.jOBSTARTTIME,
      this.customersList,
      this.jOBNOTES,
      this.jOBMATERIAL,
      this.paymentDeposit,
      this.paymentDuration,
      this.jOBENDTIME,
      this.serviceList,
      this.staffList,
      this.startDate,
      this.imageId,
      this.imageList});

  ScheduleModel.fromJson(Map<String, dynamic> json) {
    jOBLOCATION = json['JOB_LOCATION'];
    jOBSTATUS = json['JOB_STATUS'];
    endDate = json['endDate'];
    custInvoiceCreatedIds = json['custInvoiceCreatedIds'];
    pKJOBID = json['PK_JOB_ID'];
    /*if (json['invoiceList'] != null) {
      invoiceList = <Null>[];
      json['invoiceList'].forEach((v) {
        invoiceList!.add(new Null.fromJson(v));
      });
    }*/
    jOBSTARTTIME = json['JOB_START_TIME'];
    if (json['CustomersList'] != null) {
      customersList = <CustomersList>[];
      json['CustomersList'].forEach((v) {
        customersList!.add(CustomersList.fromJson(v));
      });
    }
    jOBNOTES = json['JOB_NOTES'];
    if (json['JOB_MATERIAL'] != null) {
      jOBMATERIAL = <JOBMATERIAL>[];
      json['JOB_MATERIAL'].forEach((v) {
        jOBMATERIAL!.add(new JOBMATERIAL.fromJson(v));
      });
    }
    jOBENDTIME = json['JOB_END_TIME'];
    paymentDeposit = json['paymentDeposit'];
    if (json['serviceList'] != null) {
      serviceList = <Services>[];
      json['serviceList'].forEach((v) {
        serviceList!.add(Services.fromJson(v));
      });
    }
    paymentDuration = json['paymentDuration'];
    if (json['StaffList'] != null) {
      staffList = <StaffList>[];
      json['StaffList'].forEach((v) {
        staffList!.add(new StaffList.fromJson(v));
      });
    }
    if (json['imageList'] != null) {
      imageList = <ImageList>[];
      json['imageList'].forEach((v) {
        imageList!.add(new ImageList.fromJson(v));
      });
    }
    startDate = json['startDate'];
    imageId = json['ImageId'];
  }
}

class ImageList {
  String? fILENAME;
  int? pKMEDIAID;
  String? iMAGEID;

  ImageList({this.fILENAME, this.pKMEDIAID, this.iMAGEID});

  ImageList.fromJson(Map<String, dynamic> json) {
    fILENAME = json['FILE_NAME'];
    pKMEDIAID = json['PK_MEDIA_ID'];
    iMAGEID = json['IMAGE_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FILE_NAME'] = this.fILENAME;
    data['PK_MEDIA_ID'] = this.pKMEDIAID;
    data['IMAGE_ID'] = this.iMAGEID;
    return data;
  }
}

class CustomersList {
  String? cUSTOMERFIRSTNAME;
  String? cUSTOMERLASTNAME;
  int? pKCUSTOMERID;
  List<ServiceEntityList>? serviceEntityList;

  CustomersList(
      {this.cUSTOMERFIRSTNAME,
      this.cUSTOMERLASTNAME,
      this.pKCUSTOMERID,
      this.serviceEntityList});

  CustomersList.fromJson(Map<String, dynamic> json) {
    cUSTOMERFIRSTNAME = json['CUSTOMER_FIRST_NAME'];
    cUSTOMERLASTNAME = json['CUSTOMER_LAST_NAME'];
    pKCUSTOMERID = json['PK_CUSTOMER_ID'];
    if (json['ServiceEntityList'] != null) {
      serviceEntityList = <ServiceEntityList>[];
      json['ServiceEntityList'].forEach((v) {
        serviceEntityList!.add(new ServiceEntityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CUSTOMER_FIRST_NAME'] = this.cUSTOMERFIRSTNAME;
    data['CUSTOMER_LAST_NAME'] = this.cUSTOMERLASTNAME;
    data['PK_CUSTOMER_ID'] = this.pKCUSTOMERID;
    if (this.serviceEntityList != null) {
      data['ServiceEntityList'] =
          this.serviceEntityList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceEntityList {
  String? sERVICEENTITYNAME;
  int? pKSERVICEENTITY;

  ServiceEntityList({this.sERVICEENTITYNAME, this.pKSERVICEENTITY});

  ServiceEntityList.fromJson(Map<String, dynamic> json) {
    sERVICEENTITYNAME = json['SERVICE_ENTITY_NAME'];
    pKSERVICEENTITY = json['PK_SERVICE_ENTITY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SERVICE_ENTITY_NAME'] = this.sERVICEENTITYNAME;
    data['PK_SERVICE_ENTITY'] = this.pKSERVICEENTITY;
    return data;
  }
}

class JOBMATERIAL {
  int? pKMATERIALID;
  String? mATERIALNAME;
  String? rATE;
  String? mATERIALUNITNAME;

  JOBMATERIAL(
      {this.pKMATERIALID, this.mATERIALNAME, this.rATE, this.mATERIALUNITNAME});

  JOBMATERIAL.fromJson(Map<String, dynamic> json) {
    pKMATERIALID = json['PK_MATERIAL_ID'];
    mATERIALNAME = json['MATERIAL_NAME'];
    rATE = json['RATE'];
    mATERIALUNITNAME = json['MATERIAL_UNIT_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PK_MATERIAL_ID'] = this.pKMATERIALID;
    data['MATERIAL_NAME'] = this.mATERIALNAME;
    data['RATE'] = this.rATE;
    data['MATERIAL_UNIT_NAME'] = this.mATERIALUNITNAME;
    return data;
  }
}

class Services {
  int? iD;
  String? sERVICENAME;
  int? rATE;
  String? rATEUNITNAME;

  Services({this.iD, this.sERVICENAME, this.rATE, this.rATEUNITNAME});

  Services.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    sERVICENAME = json['SERVICE_NAME'];
    rATE = json['RATE'];
    rATEUNITNAME = json['RATE_UNIT_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['SERVICE_NAME'] = this.sERVICENAME;
    data['RATE'] = this.rATE;
    data['RATE_UNIT_NAME'] = this.rATEUNITNAME;
    return data;
  }
}

class StaffList {
  int? pKUSERID;
  String? uSERFIRSTNAME;
  String? uSERLASTNAME;

  StaffList({this.pKUSERID, this.uSERFIRSTNAME, this.uSERLASTNAME});

  StaffList.fromJson(Map<String, dynamic> json) {
    pKUSERID = json['PK_USER_ID'];
    uSERFIRSTNAME = json['USER_FIRST_NAME'];
    uSERLASTNAME = json['USER_LAST_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PK_USER_ID'] = this.pKUSERID;
    data['USER_FIRST_NAME'] = this.uSERFIRSTNAME;
    data['USER_LAST_NAME'] = this.uSERLASTNAME;
    return data;
  }
}
