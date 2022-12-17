class StepModel{
  dynamic id;
  dynamic stepName;
  dynamic instruction;
  dynamic personalTouch;
  dynamic photo;

  StepModel(
      {this.id,
      this.stepName,
      this.instruction,
      this.personalTouch,
      this.photo});

  StepModel.fromJson(dynamic json) {
    id = json['id'];
    stepName = json['stepName'];
    instruction = json['instruction'];
    personalTouch = json['personalTouch'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['stepName'] = stepName;
    map['instruction'] = instruction;
    map['personalTouch'] = personalTouch;
    map['photo'] = photo;
    return map;
  }
}