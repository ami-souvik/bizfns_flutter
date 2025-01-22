class ServiceEntityQuestionAnswerModel {
  String? item;
  List<ServiceEntityItemData>? data;

  ServiceEntityQuestionAnswerModel({this.item, this.data});

  ServiceEntityQuestionAnswerModel.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    if (json['data'] != null) {
      data = <ServiceEntityItemData>[];
      json['data'].forEach((v) {
        data!.add(ServiceEntityItemData.fromJson(v));
      });
    }
  }
}

class ServiceEntityItemData {
  String? questionId;
  String? question;
  String? answer;

  ServiceEntityItemData({this.questionId, this.question, this.answer});

  ServiceEntityItemData.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    question = json['question'];
    answer = json['answer'];
  }
}
