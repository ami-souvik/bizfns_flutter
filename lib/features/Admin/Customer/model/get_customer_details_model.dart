class GetCustomerDetails {
  bool? success;
  String? message;
  CustomerDetailsData? response;

  GetCustomerDetails({this.success, this.message, this.response});

  GetCustomerDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new CustomerDetailsData.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class CustomerDetailsData {
  String? customerPhone;
  String? email;
  String? address;
  String? activeStatus;
  String? firstName;
  String? companyName;
  String? customerId;
  String? lastName;

  CustomerDetailsData(
      {this.customerPhone,
      this.email,
      this.address,
      this.activeStatus,
      this.firstName,
      this.companyName,
      this.customerId,
      this.lastName});

  CustomerDetailsData.fromJson(Map<String, dynamic> json) {
    customerPhone = json['customerPhone'];
    email = json['Email'];
    address = json['address'];
    activeStatus = json['activeStatus'];
    firstName = json['FirstName'];
    companyName = json['companyName'];
    customerId = json['customerId'];
    lastName = json['LastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerPhone'] = this.customerPhone;
    data['Email'] = this.email;
    data['address'] = this.address;
    data['activeStatus'] = this.activeStatus;
    data['FirstName'] = this.firstName;
    data['companyName'] = this.companyName;
    data['customerId'] = this.customerId;
    data['LastName'] = this.lastName;
    return data;
  }
}
