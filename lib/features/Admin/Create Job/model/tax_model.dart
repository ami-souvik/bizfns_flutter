class TaxModel {
  bool? success;
  String? message;
  TaxData? data;

  TaxModel({this.success, this.message, this.data});

  TaxModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new TaxData.fromJson(json['data']) : null;
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

class TaxData {
  List<TaxTable>? taxTable;

  TaxData({this.taxTable});

  TaxData.fromJson(Map<String, dynamic> json) {
    if (json['TaxTable'] != null) {
      taxTable = <TaxTable>[];
      json['TaxTable'].forEach((v) {
        taxTable!.add(new TaxTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.taxTable != null) {
      data['TaxTable'] = this.taxTable!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaxTable {
  int? taxtypeid;
  String? taxtypename;
  double? taxrate;

  TaxTable({this.taxtypeid, this.taxtypename, this.taxrate});

  TaxTable.fromJson(Map<String, dynamic> json) {
    taxtypeid = json['taxtypeid'];
    taxtypename = json['taxtypename'];
    taxrate = json['taxrate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taxtypeid'] = this.taxtypeid;
    data['taxtypename'] = this.taxtypename;
    data['taxrate'] = this.taxrate;
    return data;
  }
}
