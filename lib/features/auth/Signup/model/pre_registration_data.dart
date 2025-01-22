class PreRegistrationData {
  bool? success;
  String? message;
  Data? data;

  PreRegistrationData({this.success, this.message, this.data});

  PreRegistrationData.fromJson(Map<String, dynamic> json) {
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
  List<BusinessCategoryType>? businessCategoryType;
  List<PlanList>? planList;
  String? termsAndCondition;

  Data({this.businessCategoryType, this.planList, this.termsAndCondition});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['businessCategoryAndType'] != null) {
      businessCategoryType = <BusinessCategoryType>[];
      json['businessCategoryAndType'].forEach((v) {
        businessCategoryType!.add(new BusinessCategoryType.fromJson(v));
      });
    }
    if (json['planList'] != null) {
      planList = <PlanList>[];
      json['planList'].forEach((v) {
        planList!.add(new PlanList.fromJson(v));
      });
    }
    termsAndCondition = json['termsAndCondition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.businessCategoryType != null) {
      data['businessCategoryAndType'] =
          this.businessCategoryType!.map((v) => v.toJson()).toList();
    }
    if (this.planList != null) {
      data['planList'] = this.planList!.map((v) => v.toJson()).toList();
    }
    data['termsAndCondition'] = this.termsAndCondition;
    return data;
  }
}

class BusinessCategoryType {
  int? pKCATEGORYID;
  int? pKBUSINESSTYPEID;
  String? bUSINESSTYPEENTITY;
  String? cATEGORYNAME;
  String? CATEGORYDESCRIPTION;

  BusinessCategoryType(
      {this.pKCATEGORYID,
        this.pKBUSINESSTYPEID,
        this.bUSINESSTYPEENTITY,
        this.CATEGORYDESCRIPTION,
        this.cATEGORYNAME});

  BusinessCategoryType.fromJson(Map<String, dynamic> json) {
    pKCATEGORYID = json['PK_CATEGORY_ID'];
    pKBUSINESSTYPEID = json['PK_BUSINESS_TYPE_ID'];
    bUSINESSTYPEENTITY = json['BUSINESS_TYPE_ENTITY'];
    CATEGORYDESCRIPTION = json['CATEGORY_DESCRIPTION'];
    cATEGORYNAME = json['CATEGORY_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PK_CATEGORY_ID'] = this.pKCATEGORYID;
    data['PK_BUSINESS_TYPE_ID'] = this.pKBUSINESSTYPEID;
    data['BUSINESS_TYPE_ENTITY'] = this.bUSINESSTYPEENTITY;
    data['CATEGORY_DESCRIPTION'] = this.CATEGORYDESCRIPTION;
    data['CATEGORY_NAME'] = this.cATEGORYNAME;
    return data;
  }
}

class PlanList {
  int? userCount;
  String? planName;
  String? description;
  String? price;
  int? planId;

  PlanList({this.userCount, this.planName, this.description, this.planId});

  PlanList.fromJson(Map<String, dynamic> json) {
    userCount = json['userCount'];
    planName = json['planName'];
    description = json['description'];
    planId = json['planId'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userCount'] = this.userCount;
    data['planName'] = this.planName;
    data['description'] = this.description;
    data['planId'] = this.planId;
    data['price'] = this.price;
    return data;
  }
}
