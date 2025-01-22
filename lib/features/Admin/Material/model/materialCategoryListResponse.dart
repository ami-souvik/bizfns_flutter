// class MaterialCategoryListResponse {
//   bool? success;
//   String? message;
//   List<MaterialCategoryData>? data;

//   MaterialCategoryListResponse({this.success, this.message, this.data});

//   MaterialCategoryListResponse.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <MaterialCategoryData>[];
//       json['data'].forEach((v) {
//         data!.add(new MaterialCategoryData.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class MaterialCategoryData {
//   int? categoryParentId;
//   String? categoryName;
//   int? categoryId;

//   MaterialCategoryData({this.categoryParentId, this.categoryName, this.categoryId});

//   MaterialCategoryData.fromJson(Map<String, dynamic> json) {
//     categoryParentId = json['categoryParentId'];
//     categoryName = json['categoryName'];
//     categoryId = json['categoryId'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['categoryParentId'] = this.categoryParentId;
//     data['categoryName'] = this.categoryName;
//     data['categoryId'] = this.categoryId;
//     return data;
//   }
// }


class MaterialCategoryListResponse {
  bool? success;
  String? message;
  List<Data>? data;

  MaterialCategoryListResponse({this.success, this.message, this.data});

  MaterialCategoryListResponse.fromJson(Map<String, dynamic> json) {
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
  int? pKCATEGORYID;
  List<SubCategory>? subCategory;
  String? cATEGORYNAME;

  Data({this.pKCATEGORYID, this.subCategory, this.cATEGORYNAME});

  Data.fromJson(Map<String, dynamic> json) {
    pKCATEGORYID = json['PK_CATEGORY_ID'];
    if (json['SubCategory'] != null) {
      subCategory = <SubCategory>[];
      json['SubCategory'].forEach((v) {
        subCategory!.add(new SubCategory.fromJson(v));
      });
    }
    cATEGORYNAME = json['CATEGORY_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PK_CATEGORY_ID'] = this.pKCATEGORYID;
    if (this.subCategory != null) {
      data['SubCategory'] = this.subCategory!.map((v) => v.toJson()).toList();
    }
    data['CATEGORY_NAME'] = this.cATEGORYNAME;
    return data;
  }
}

class SubCategory {
  String? pkSubcategoryName;
  int? pkSubcategoryId;

  SubCategory({this.pkSubcategoryName, this.pkSubcategoryId});

  SubCategory.fromJson(Map<String, dynamic> json) {
    pkSubcategoryName = json['pk_subcategory_name'];
    pkSubcategoryId = json['pk_subcategory_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pk_subcategory_name'] = this.pkSubcategoryName;
    data['pk_subcategory_id'] = this.pkSubcategoryId;
    return data;
  }
}
