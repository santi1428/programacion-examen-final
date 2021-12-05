class SurveyData {
  int? id;
  String? date;
  String? email;
  int? qualification;
  String? theBest;
  String? theWorst;
  String? remarks;

  SurveyData(
      {this.id,
      this.date,
      this.email,
      this.qualification,
      this.theBest,
      this.theWorst,
      this.remarks});

  SurveyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    email = json['email'];
    qualification = json['qualification'];
    theBest = json['theBest'];
    theWorst = json['theWorst'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['email'] = email;
    data['qualification'] = qualification;
    data['theBest'] = theBest;
    data['theWorst'] = theWorst;
    data['remarks'] = remarks;
    return data;
  }
}
