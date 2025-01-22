// class GetEditInvoiceModel {
//   Services? services;
//   int? deposit;
//   double? tripTravelCharge;
//   SpecialCharges? specialCharges;
//   List<int>? customerIds;
//   Discount? discount;
//   double? laborCharge;
//   Materials? materials;
//   String? paymentDuration;
//   String? jobId;
//   int? customersDataMatched;

//   GetEditInvoiceModel(
//       {this.services,
//       this.deposit,
//       this.tripTravelCharge,
//       this.specialCharges,
//       this.customerIds,
//       this.discount,
//       this.laborCharge,
//       this.materials,
//       this.paymentDuration,
//       this.jobId,
//       this.customersDataMatched});

//   GetEditInvoiceModel.fromJson(Map<String, dynamic> json) {
//     services = json['Services'] != null
//         ? new Services.fromJson(json['Services'])
//         : null;
//     deposit = json['Deposit'];
//     tripTravelCharge = json['TripTravelCharge'];
//     specialCharges = json['SpecialCharges'] != null
//         ? new SpecialCharges.fromJson(json['SpecialCharges'])
//         : null;
//     customerIds = json['CustomerIds'].cast<int>();
//     discount = json['Discount'] != null
//         ? new Discount.fromJson(json['Discount'])
//         : null;
//     laborCharge = json['LaborCharge'];
//     materials = json['Materials'] != null
//         ? new Materials.fromJson(json['Materials'])
//         : null;
//     paymentDuration = json['paymentDuration'];
//     jobId = json['JobId'];
//     customersDataMatched = json['CustomersDataMatched'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.services != null) {
//       data['Services'] = this.services!.toJson();
//     }
//     data['Deposit'] = this.deposit;
//     data['TripTravelCharge'] = this.tripTravelCharge;
//     if (this.specialCharges != null) {
//       data['SpecialCharges'] = this.specialCharges!.toJson();
//     }
//     data['CustomerIds'] = this.customerIds;
//     if (this.discount != null) {
//       data['Discount'] = this.discount!.toJson();
//     }
//     data['LaborCharge'] = this.laborCharge;
//     if (this.materials != null) {
//       data['Materials'] = this.materials!.toJson();
//     }
//     data['paymentDuration'] = this.paymentDuration;
//     data['JobId'] = this.jobId;
//     data['CustomersDataMatched'] = this.customersDataMatched;
//     return data;
//   }
// }

// class Services {
//   int? demoService03;
//   int? demoService02;
//   int? room;

//   Services({this.demoService03, this.demoService02, this.room});

//   Services.fromJson(Map<String, dynamic> json) {
//     demoService03 = json['demo service 03'];
//     demoService02 = json['demoService02'];
//     room = json['room'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['demo service 03'] = this.demoService03;
//     data['demoService02'] = this.demoService02;
//     data['room'] = this.room;
//     return data;
//   }
// }

// class SpecialCharges {
//   int? sc1;
//   int? sc2;

//   SpecialCharges({this.sc1, this.sc2});

//   SpecialCharges.fromJson(Map<String, dynamic> json) {
//     sc1 = json['sc1'];
//     sc2 = json['sc2'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['sc1'] = this.sc1;
//     data['sc2'] = this.sc2;
//     return data;
//   }
// }

// class Discount {
//   String? discountMethod;
//   double? discountValue;

//   Discount({this.discountMethod, this.discountValue});

//   Discount.fromJson(Map<String, dynamic> json) {
//     discountMethod = json['DiscountMethod'];
//     discountValue = json['DiscountValue'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['DiscountMethod'] = this.discountMethod;
//     data['DiscountValue'] = this.discountValue;
//     return data;
//   }
// }

// class Materials {
//   int? mat05;
//   int? bottle;
//   int? cup;

//   Materials({this.mat05, this.bottle, this.cup});

//   Materials.fromJson(Map<String, dynamic> json) {
//     mat05 = json['mat05'];
//     bottle = json['bottle'];
//     cup = json['cup'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['mat05'] = this.mat05;
//     data['bottle'] = this.bottle;
//     data['cup'] = this.cup;
//     return data;
//   }
// }

class GetEditInvoiceModel {
  Map<String, int> services;
  double deposit;
  double tripTravelCharge;
  Map<String, double> specialCharges;
  List<int> customerIds;
  Discount discount;
  double laborCharge;
  Map<String, double> materials;
  String paymentDuration;
  String invoiceDate;
  String dueDate;
  String jobId;
  int customersDataMatched;

  GetEditInvoiceModel({
    required this.services,
    required this.deposit,
    required this.tripTravelCharge,
    required this.specialCharges,
    required this.customerIds,
    required this.discount,
    required this.laborCharge,
    required this.materials,
    required this.paymentDuration,
    required this.invoiceDate,
    required this.dueDate,
    required this.jobId,
    required this.customersDataMatched,
  });

  factory GetEditInvoiceModel.fromJson(Map<String, dynamic> json) {
    return GetEditInvoiceModel(
      services: Map<String, int>.from(json['Services']),
      deposit: json['Deposit'].toDouble(),
      tripTravelCharge: json['TripTravelCharge'].toDouble(),
      specialCharges: Map<String, double>.from(json['SpecialCharges']),
      customerIds: List<int>.from(json['CustomerIds']),
      discount: Discount.fromJson(json['Discount']),
      laborCharge: json['LaborCharge'].toDouble(),
      materials: Map<String, double>.from(json['Materials']),
      paymentDuration: json['paymentDuration'] ?? '',
      invoiceDate: json['invoiceDate'],
      dueDate: json['dueDate'],
      jobId: json['JobId'] ?? '',
      customersDataMatched: json['CustomersDataMatched'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Services': services,
      'Deposit': deposit,
      'TripTravelCharge': tripTravelCharge,
      'SpecialCharges': specialCharges,
      'CustomerIds': customerIds,
      'Discount': discount.toJson(),
      'LaborCharge': laborCharge,
      'Materials': materials,
      'paymentDuration': paymentDuration,
      'JobId': jobId,
      'CustomersDataMatched': customersDataMatched,
    };
  }
}

class Discount {
  String discountMethod;
  double discountValue;

  Discount({
    required this.discountMethod,
    required this.discountValue,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      discountMethod: json['DiscountMethod'] ?? '',
      discountValue: json['DiscountValue'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DiscountMethod': discountMethod,
      'DiscountValue': discountValue,
    };
  }
}
