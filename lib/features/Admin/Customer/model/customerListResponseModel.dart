class CustomerListResponseModel {
  CustomerListResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<CustomerListData> data;

  CustomerListResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      success = json['success'];
      message = json['message'];
      data = List.from(json['response'])
          .map((e) => CustomerListData.fromJson(e))
          .toList();
    } catch (e) {
      print(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['message'] = message;
    _data['response'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class CustomerListData {
  CustomerListData({
    required this.companyName,
    required this.customerAddress,
    required this.customerPhoneNo,
    required this.customerFirstName,
    required this.customerEmail,
    required this.unpaidInvoice,
    required this.customerCreatedAt,
    required this.customerId,
    required this.lifetimeAmount,
    required this.activeStatus
  });
  late final String companyName;
  late final String customerAddress;
  late final String customerPhoneNo;
  late final String customerFirstName;
  late final String customerLastName;
  late final String customerEmail;
  late final List<UnpaidInvoice> unpaidInvoice;
  late final dynamic customerCreatedAt;
  late final int customerId;
  late final String lifetimeAmount;
  late final String activeStatus;

  CustomerListData.fromJson(Map<String, dynamic> json) {
    try {
      // companyName = json['companyName'];//
      customerAddress = json['customerAddress'];
      customerPhoneNo = json['customerPhoneNo'];
      customerFirstName = json['customerFirstName'];
      customerLastName = json['customerLastName'] ?? "";
      customerEmail = json['customerEmail'];
      unpaidInvoice = List.from(json['unpaidInvoice'])
          .map((e) => UnpaidInvoice.fromJson(e))
          .toList();
      customerCreatedAt = json['customerCreatedAt'];
      customerId = json['customerId'];
      lifetimeAmount = json['lifetimeAmount'];
      activeStatus = json['activeStatus'];
    } catch (e) {
      print(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['customerAddress'] = customerAddress;
    _data['customerPhoneNo'] = customerPhoneNo;
    _data['customerFirstName'] = customerFirstName;
    _data['customerLastName'] = customerLastName;
    _data['customerEmail'] = customerEmail;
    _data['unpaidInvoice'] = unpaidInvoice.map((e) => e.toJson()).toList();
    _data['customerCreatedAt'] = customerCreatedAt;
    _data['customerId'] = customerId;
    _data['lifetimeAmount'] = lifetimeAmount;
    _data['activeStatus'] = activeStatus;
    return _data;
  }
}

class UnpaidInvoice {
  UnpaidInvoice({
    required this.invoiceId,
    required this.invoiceAmount,
    required this.invoiceNo,
    required this.invoiceStatus,
  });
  late final String invoiceId;
  late final String invoiceAmount;
  late final String invoiceNo;
  late final String invoiceStatus;

  UnpaidInvoice.fromJson(Map<String, dynamic> json) {
    try {
      invoiceId = json['invoiceId'];
      invoiceAmount = json['invoiceAmount'];
      invoiceNo = json['invoiceNo'];
      invoiceStatus = json['invoiceStatus'];
    } catch (e) {
      print(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['invoiceId'] = invoiceId;
    _data['invoiceAmount'] = invoiceAmount;
    _data['invoiceNo'] = invoiceNo;
    _data['invoiceStatus'] = invoiceStatus;
    return _data;
  }
}
