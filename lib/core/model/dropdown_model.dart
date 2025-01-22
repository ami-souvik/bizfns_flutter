class DropdownModel {
  String? dependentid;
  String? id;
  String? name;
  String? desc;

  DropdownModel({this.id, this.dependentid, this.name, this.desc});

  DropdownModel.fromJson(Map<String, dynamic> json) {
    dependentid = json['dependentid'];
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dependentid'] = this.dependentid;
    data['id'] = this.id;
    data['name'] = this.name;
    data['desc'] = this.desc;
    return data;
  }
}
