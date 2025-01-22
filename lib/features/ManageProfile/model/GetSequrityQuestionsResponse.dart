class GetSequrityQuestionsResponse {
  bool? success;
  String? message;
  List<SequrityQuestion>? data;

  GetSequrityQuestionsResponse({this.success, this.message, this.data});

  GetSequrityQuestionsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SequrityQuestion>[];
      json['data'].forEach((v) {
        data!.add(new SequrityQuestion.fromJson(v));
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

class SequrityQuestion {
  String? answeer;
  int? pKQUESTIONID;
  String? qUESTION;

  SequrityQuestion({this.answeer, this.pKQUESTIONID, this.qUESTION});

  SequrityQuestion.fromJson(Map<String, dynamic> json) {
    answeer = json['answeer'];
    pKQUESTIONID = json['PK_QUESTION_ID'];
    qUESTION = json['QUESTION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answeer'] = this.answeer;
    data['PK_QUESTION_ID'] = this.pKQUESTIONID;
    data['QUESTION'] = this.qUESTION;
    return data;
  }
}
