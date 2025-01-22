class GetProfileModel {
  bool? success;
  String? message;
  Data? data;

  GetProfileModel({this.success, this.message, this.data});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
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
  BusinessNameAndLogo? businessNameAndLogo;
  String? businessType;
  Marketing? marketing;
  String? companyStatus;
  String? businessContactPerson;
  String? primaryMobileNumber;
  String? primaryBusinessEmail;
  String? trustedBackupEmail;
  String? trustedBackupMobileNumber;
  String? registrationDate;
  List<SecurityQuestion>? securityQuestion;
  SubscriptionPlan? subscriptionPlan;
  String? fullAddress;

  Data(
      {this.businessNameAndLogo,
      this.businessType,
      this.marketing,
      this.companyStatus,
      this.businessContactPerson,
      this.primaryMobileNumber,
      this.primaryBusinessEmail,
      this.trustedBackupEmail,
      this.trustedBackupMobileNumber,
      this.registrationDate,
      this.securityQuestion,
      this.subscriptionPlan,
      this.fullAddress});

  Data.fromJson(Map<String, dynamic> json) {
    businessNameAndLogo = json['businessNameAndLogo'] != null
        ? new BusinessNameAndLogo.fromJson(json['businessNameAndLogo'])
        : null;
    businessType = json['businessType'];
    marketing = json['marketing'] != null
        ? new Marketing.fromJson(json['marketing'])
        : null;
    companyStatus = json['companyStatus'];
    businessContactPerson = json['businessContactPerson'];
    primaryMobileNumber = json['primaryMobileNumber'];
    primaryBusinessEmail = json['primaryBusinessEmail'];
    trustedBackupEmail = json['trustedBackupEmail'];
    trustedBackupMobileNumber = json['trustedBackupMobileNumber'];
    registrationDate = json['registrationDate'];
    if (json['securityQuestion'] != null) {
      securityQuestion = <SecurityQuestion>[];
      json['securityQuestion'].forEach((v) {
        securityQuestion!.add(new SecurityQuestion.fromJson(v));
      });
    }
    subscriptionPlan = json['subscriptionPlan'] != null
        ? new SubscriptionPlan.fromJson(json['subscriptionPlan'])
        : null;
    fullAddress = json['fullAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.businessNameAndLogo != null) {
      data['businessNameAndLogo'] = this.businessNameAndLogo!.toJson();
    }
    data['businessType'] = this.businessType;
    if (this.marketing != null) {
      data['marketing'] = this.marketing!.toJson();
    }
    data['companyStatus'] = this.companyStatus;
    data['businessContactPerson'] = this.businessContactPerson;
    data['primaryMobileNumber'] = this.primaryMobileNumber;
    data['primaryBusinessEmail'] = this.primaryBusinessEmail;
    data['trustedBackupEmail'] = this.trustedBackupEmail;
    data['trustedBackupMobileNumber'] = this.trustedBackupMobileNumber;
    data['registrationDate'] = this.registrationDate;
    if (this.securityQuestion != null) {
      data['securityQuestion'] =
          this.securityQuestion!.map((v) => v.toJson()).toList();
    }
    if (this.subscriptionPlan != null) {
      data['subscriptionPlan'] = this.subscriptionPlan!.toJson();
    }
    data['fullAddress'] = this.fullAddress;
    return data;
  }
}

class BusinessNameAndLogo {
  String? businessName;
  String? businessLogo;

  BusinessNameAndLogo({this.businessName, this.businessLogo});

  BusinessNameAndLogo.fromJson(Map<String, dynamic> json) {
    businessName = json['businessName'];
    businessLogo = json['businessLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessName'] = this.businessName;
    data['businessLogo'] = this.businessLogo;
    return data;
  }
}

class Marketing {
  String? marketingDescription;
  List<String>? addLocation;

  Marketing({this.marketingDescription, this.addLocation});

  Marketing.fromJson(Map<String, dynamic> json) {
    marketingDescription = json['marketingDescription'];
    addLocation = json['addLocation'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['marketingDescription'] = this.marketingDescription;
    data['addLocation'] = this.addLocation;
    return data;
  }
}

class SecurityQuestion {
  String? qUESTION;

  SecurityQuestion({this.qUESTION});

  SecurityQuestion.fromJson(Map<String, dynamic> json) {
    qUESTION = json['QUESTION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QUESTION'] = this.qUESTION;
    return data;
  }
}

class SubscriptionPlan {
  String? subscriptionCategoryDesc;
  String? subscriptionEndDate;
  int? subscriptionPlanId;
  String? subscriptionStartDate;

  SubscriptionPlan(
      {this.subscriptionCategoryDesc,
      this.subscriptionEndDate,
      this.subscriptionPlanId,
      this.subscriptionStartDate});

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    subscriptionCategoryDesc = json['subscriptionCategoryDesc'];
    subscriptionEndDate = json['subscriptionEndDate'];
    subscriptionPlanId = json['subscriptionPlanId'];
    subscriptionStartDate = json['subscriptionStartDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscriptionCategoryDesc'] = this.subscriptionCategoryDesc;
    data['subscriptionEndDate'] = this.subscriptionEndDate;
    data['subscriptionPlanId'] = this.subscriptionPlanId;
    data['subscriptionStartDate'] = this.subscriptionStartDate;
    return data;
  }
}
