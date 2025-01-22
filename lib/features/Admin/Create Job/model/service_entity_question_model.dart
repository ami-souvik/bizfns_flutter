import 'package:get/get.dart';

import '../../../../core/utils/Utils.dart';

class ServiceEntityQuestionModel {
  bool? success;
  String? message;
  ServiceEntityData? data;

  ServiceEntityQuestionModel({this.success, this.message, this.data});

  ServiceEntityQuestionModel.fromJson(Map<String, dynamic> json) {
    try{
      success = json['success'];
      message = json['message'];
      data =
      json['data'] != null ? ServiceEntityData.fromJson(json['data']) : null;
    }catch(e,stackTrace){
      Utils().printMessage('Stage Error1: $e $stackTrace');
    }
  }
}

class ServiceEntityData {
  List<ServiceEntityItems>? serviceEntityItems;

  ServiceEntityData({this.serviceEntityItems});

  ServiceEntityData.fromJson(Map<String, dynamic> json) {
    try{
      if (json['service_entity_items'] != null) {
        serviceEntityItems = <ServiceEntityItems>[];
        json['service_entity_items'].forEach((v) {
          serviceEntityItems!.add(new ServiceEntityItems.fromJson(v));
        });
      }
    }catch(e){
      Utils().printMessage('Stage Error2: $e');
    }
  }
}

class ServiceEntityItems {
  String? question;
  String? answer;
  int? typeId;
  int? questionId;
  List<String>? items;
  List<RowItems>? rowItems;

  ServiceEntityItems(
      {this.question,
        this.answer,
        this.typeId,
        this.questionId,
        this.items,
        this.rowItems});

  ServiceEntityItems.fromJson(Map<String, dynamic> json) {
    print(json['items']);
    try{
      question = json['question'];
      answer = json['answer'];
      typeId = json['type_id'];
      questionId = json['question_id'];
      if (json['items'] != null) {
        List<String> itemList = [];
        json['items'].forEach((v) {
          itemList.add(v.toString());
        });
        items = itemList;
      }
      if (json['row_items'] != null) {
        rowItems = <RowItems>[];
        json['row_items'].forEach((v) {
          rowItems!.add(RowItems.fromJson(v));
        });
      }

      print('Question ID: '+questionId.toString());
    }catch(e){
      Utils().printMessage('Stage Error3: $e $json');
    }
  }

  ServiceEntityItems copyWith({String? answer}){
    return ServiceEntityItems(
      typeId: typeId,
      question: question,
      questionId: questionId,
      items: items,
      rowItems: rowItems,
      answer: answer ?? this.answer,
    );
  }
}

class RowItems {
  List<String>? rowItems;
  int? rowQuestionId;
  String? rowAnswer;
  String? rowQuestion;
  int? rowTypeId;

  RowItems(
      {this.rowItems,
        this.rowQuestionId,
        this.rowAnswer,
        this.rowQuestion,
        this.rowTypeId});

  RowItems.fromJson(Map<String, dynamic> json) {
    try{
      if (json['items'] != null) {
        List<String> itemList = [];
        json['items'].forEach((v) {
          print(v);
          itemList.add(v.toString());
        });
        rowItems = itemList;
      }
      rowQuestionId = json['row_question_id'];
      rowAnswer = json['row_answer'];
      rowQuestion = json['row_question'];
      rowTypeId = json['type_id'];
    }catch(e){
      Utils().printMessage('Stage Error4: $e');
    }
  }
}
