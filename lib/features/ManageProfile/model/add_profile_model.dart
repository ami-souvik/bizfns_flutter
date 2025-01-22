class AddProfileModel {
  BusinessNameAndLogo? businessNameAndLogo;
  Marketing? marketing;
  String? address;
  String? businessContactPerson;
  String? trustedBackupMobileNumber;
  String? trustedBackupEmail;
  String? businessEmail;

  static final AddProfileModel addProfile = AddProfileModel._internal();
  AddProfileModel._internal();

  factory AddProfileModel({
    // String? userId,
    // String? tenantId,
    BusinessNameAndLogo? businessNameAndLogo,
    Marketing? marketing,
    String? address,
    String? businessContactPerson,
    String? trustedBackupMobileNumber,
    String? trustedBackupEmail,
    String? businessEmail,
  }) {
    addProfile.businessNameAndLogo = businessNameAndLogo;
    addProfile.marketing = marketing;
    addProfile.address = address;
    addProfile.businessContactPerson = businessContactPerson;
    addProfile.trustedBackupMobileNumber = trustedBackupMobileNumber;
    addProfile.businessEmail = businessEmail;

    return addProfile;
  }

  clearData(){
    addProfile.businessNameAndLogo = null;
    addProfile.marketing = null;
  }
}



class BusinessNameAndLogo {
  String? businessName;
  String? businessLogo;

  BusinessNameAndLogo({this.businessName, this.businessLogo});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['businessName'] = businessName;
    data['businessLogo'] = businessLogo;
    return data;
  }
}

class Marketing {
  String? marketingDescription;
  List<String>? addLocation;

  Marketing({this.marketingDescription, this.addLocation});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['marketingDescription'] = marketingDescription;
    data['addLocation'] = addLocation;
    return data;
  }
}

class Root {
  String? userId;
  String? tenantId;
  BusinessNameAndLogo? businessNameAndLogo;
  Marketing? marketing;
  String? address;
  String? businessContactPerson;
  String? trustedBackupMobileNumber;
  String? trustedBackupEmail;
  String? businessEmail;

  Root(
      {this.userId,
      this.tenantId,
      this.businessNameAndLogo,
      this.marketing,
      this.address,
      this.businessContactPerson,
      this.trustedBackupMobileNumber,
      this.trustedBackupEmail,
      this.businessEmail});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userId'] = userId;
    data['tenantId'] = tenantId;
    data['businessNameAndLogo'] = businessNameAndLogo!.toJson();
    data['marketing'] = marketing!.toJson();
    data['address'] = address;
    data['businessContactPerson'] = businessContactPerson;
    data['trustedBackupMobileNumber'] = trustedBackupMobileNumber;
    data['trustedBackupEmail'] = trustedBackupEmail;
    data['businessEmail'] = businessEmail;
    return data;
  }
}
