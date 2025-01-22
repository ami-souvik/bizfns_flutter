class CustomerServiceEntityResponseModel {
  String? success;
  String? message;
  List<CustomerServiceEntityData>? data;

  CustomerServiceEntityResponseModel({this.success, this.message, this.data});

  CustomerServiceEntityResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CustomerServiceEntityData>[];
      json['data'].forEach((v) {
        data!.add(CustomerServiceEntityData.fromJson(v));
      });
    }
  }
}

class CustomerServiceEntityData {
  String? pkserviceentityid;
  String? serviceentityname;

  CustomerServiceEntityData({this.pkserviceentityid, this.serviceentityname});

  CustomerServiceEntityData.fromJson(Map<String, dynamic> json) {
    pkserviceentityid = json['pkserviceentityid'].toString();
    serviceentityname = json['serviceentityname'] == null ? 'Entity Name' : json['serviceentityname'] ;
  }
}
