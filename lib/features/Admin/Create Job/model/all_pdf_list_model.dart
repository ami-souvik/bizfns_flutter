class AllPdfListModel {
  bool? success;
  String? message;
  List<Data>? data;

  AllPdfListModel({this.success, this.message, this.data});

  AllPdfListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? invoice;
  String? customerName;

  Data({this.invoice, this.customerName});

  Data.fromJson(Map<String, dynamic> json) {
    invoice = json['Invoice'];
    customerName = json['CustomerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Invoice'] = this.invoice;
    data['CustomerName'] = this.customerName;
    return data;
  }
}
