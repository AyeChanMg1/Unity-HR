class SurveyModule {
  int id;
  String? traningSurveyFormId;
  String? traningSurveyId;
  String? employeeId;
  List answer;
  String? status;
  Training? training;
  Survey? survey;

  SurveyModule({
    required this.id,
    this.traningSurveyFormId,
    this.traningSurveyId,
    this.employeeId,
    required this.answer,
    this.status,
    this.training,
    this.survey,
  });

  factory SurveyModule.fromJson(Map<String, dynamic> json) => SurveyModule(
    id: json['id'],
    traningSurveyFormId: json['traning_survey_form_id'],
    traningSurveyId: json['traning_survey_id'],
    employeeId: json['employee_id'],
    answer: json['answer'] ?? [],
    status: json['status'],
    training: json['training'] != null
        ? Training.fromJson(json['training'])
        : null,
    survey: json['survey'] != null
        ? Survey.fromJson(json['survey'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'traning_survey_form_id': traningSurveyFormId,
    'traning_survey_id': traningSurveyId,
    'employee_id': employeeId,
    'answer': answer,
    'status': status,
    'training': training?.toJson(),
    'survey': survey?.toJson(),
  };
}

class Training {
  String? id;
  String? type;
  String dateFrom;
  String dateTo;
  String timeFrom;
  String timeTo;
  String title;
  String? detail;
  String? trainingBy;
  String? trainer;
  int? createdBy;
  String? status;
  int? updatedBy;

  Training({
    this.id,
    this.type,
    required this.dateFrom,
    required this.dateTo,
    required this.timeFrom,
    required this.timeTo,
    required this.title,
    this.detail,
    this.trainingBy,
    this.trainer,
    this.createdBy,
    this.status,
    this.updatedBy,
  });

  factory Training.fromJson(Map<String, dynamic> json) => Training(
    id: json['id'],
    type: json['type'],
    dateFrom: json['date_from'] ?? DateTime.now().toIso8601String(),
    dateTo: json['date_to'] ?? DateTime.now().toIso8601String(),
    timeFrom: json['time_from'] ?? DateTime.now().toIso8601String(),
    timeTo: json['time_to'] ?? DateTime.now().toIso8601String(),
    title: json['title'],
    detail: json['detail'],
    trainingBy: json['training_by'],
    trainer: json['trainer'],
    createdBy: json['created_by'],
    status: json['status'],
    updatedBy: json['updated_by'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'date_from': dateFrom,
    'date_to': dateTo,
    'time_from': timeFrom,
    'time_to': timeTo,
    'title': title,
    'detail': detail,
    'training_by': trainingBy,
    'trainer': trainer,
    'created_by': createdBy,
    'status': status,
    'updated_by': updatedBy,
  };
}

class Survey {
  int? id;
  String? name;
  String? status;
  List<Question>? questions;

  Survey({
    this.id,
    this.name,
    this.status,
    this.questions,
  });

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
    id: json['id'],
    name: json['name'],
    status: json['status'],
    questions: json['questions'] != null
        ? (json['questions'] as List)
        .map((e) => Question.fromJson(e))
        .toList()
        : [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'questions': questions?.map((e) => e.toJson()).toList(),
  };
}

class Question {
  int id;
  String? traningSurveryFormId;
  String? title;
  String? description;
  List<Answer>? answers;

  Question({
    required this.id,
    this.traningSurveryFormId,
    this.title,
    this.description,
    this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'],
    traningSurveryFormId: json['traning_survery_form_id'],
    title: json['title'],
    description: json['description'],
    answers: json['answers'] != null
        ? (json['answers'] as List)
        .map((e) => Answer.fromJson(e))
        .toList()
        : [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'traning_survery_form_id': traningSurveryFormId,
    'title': title,
    'description': description,
    'answers': answers?.map((e) => e.toJson()).toList(),
  };
}

class Answer {
  int id;
  String? traningSurveryId;
  String? answer;

  Answer({
    required this.id,
    this.traningSurveryId,
    this.answer,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    id: json['id'],
    traningSurveryId: json['traning_survery_id'],
    answer: json['answer'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'traning_survery_id': traningSurveryId,
    'answer': answer,
  };
}
