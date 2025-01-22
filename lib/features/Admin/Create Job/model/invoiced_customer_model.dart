class InvoicedCustomerModel {
  bool? success;
  String? message;
  List<InvoiceCustomerData>? data;

  InvoicedCustomerModel({this.success, this.message, this.data});

  InvoicedCustomerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InvoiceCustomerData>[];
      json['data'].forEach((v) {
        data!.add(new InvoiceCustomerData.fromJson(v));
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

class InvoiceCustomerData {
  String? jobId;
  String? customerFirstName;
  String? invoiceNumber;
  String? customerId;
  String? customerLastName;
  String? invoiceStatus;

  InvoiceCustomerData(
      {
      this.jobId,
      this.customerFirstName,
      this.invoiceNumber,
      this.customerId,
      this.customerLastName,
      this.invoiceStatus});

  InvoiceCustomerData.fromJson(Map<String, dynamic> json) {
    jobId = json['jobId'];
    customerFirstName = json['customerFirstName'];
    invoiceNumber = json['invoiceNumber'];
    customerId = json['customerId'];
    customerLastName = json['customerLastName'];
    invoiceStatus = json['invoiceStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jobId'] = this.jobId;
    data['customerFirstName'] = this.customerFirstName;
    data['invoiceNumber'] = this.invoiceNumber;
    data['customerId'] = this.customerId;
    data['customerLastName'] = this.customerLastName;
    data['invoiceStatus'] = this.invoiceStatus;
    return data;
  }
}
