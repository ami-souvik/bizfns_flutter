class BusinessType {
  String? typeId;
  String? typeName;
  String? categoryId;

  BusinessType({this.typeId, this.typeName, this.categoryId});

  BusinessType.fromJson(Map<String, dynamic> json) {
    typeId = json['typeId'];
    typeName = json['typeName'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeId'] = this.typeId;
    data['typeName'] = this.typeName;
    data['categoryId'] = this.categoryId;
    return data;
  }
}
