class ProbationAssessmentScore {
  String id;
  int formId;
  String status;
  String? resultStatus;
  double? resultPercentage;
  List<Judge>? judges;
  List<dynamic>? approvers;
  String name;
  String position;
  String department;
  String joinDate;
  String date;
  List<HrUser>? hrUsers;
  List<ScorePolicy> scorePolicies;
  FormData? formData;
  List<ScoreValue> scoreValue;

  ProbationAssessmentScore({
    required this.id,
    required this.formId,
    required this.status,
     this.resultStatus,
     this.resultPercentage,
     this.judges,
     this.approvers,
    required this.name,
    required this.position,
    required this.department,
    required this.joinDate,
    required this.date,
     this.hrUsers,
    required this.scorePolicies,
     this.formData,
    required this.scoreValue,
  });

  factory ProbationAssessmentScore.fromJson(Map<String, dynamic> json) {
    return ProbationAssessmentScore(
      id: json['id'],
      formId: json['form_id'],
      status: json['status'],
      resultStatus: json['result_status'],
      resultPercentage: json['result_percentage'],
      judges: json['judges'] == null ? null: List<Judge>.from(json['judges'].map((x) => Judge.fromJson(x))),
      approvers: json['approvers'] == null ? null : List<dynamic>.from(json['approvers']),
      name: json['name'],
      position: json['position'],
      department: json['department'],
      joinDate: json['join_date'],
      date: json['date'],
      hrUsers: json['hr_users'] == null ? null : List<HrUser>.from(json['hr_users'].map((x) => HrUser.fromJson(x))),
      scorePolicies: List<ScorePolicy>.from(json['score_policies'].map((x) => ScorePolicy.fromJson(x))),
      formData: json['form_data'] == null ? null : FormData.fromJson(json['form_data']),
      scoreValue: List<ScoreValue>.from(json['score_value'].map((x) => ScoreValue.fromJson(x))),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'form_id': formId,
  //     'status': status,
  //     'result_status': resultStatus,
  //     'result_percentage': resultPercentage,
  //     'judges': List<dynamic>.from(judges!.map((x) => x.toJson())),
  //     'approvers': List<dynamic>.from(approvers),
  //     'name': name,
  //     'position': position,
  //     'department': department,
  //     'join_date': joinDate,
  //     'date': date,
  //     'hr_users': List<dynamic>.from(hrUsers.map((x) => x.toJson())),
  //     'score_policies': List<dynamic>.from(scorePolicies.map((x) => x.toJson())),
  //     'form_data': formData.toJson(),
  //     'score_value': List<dynamic>.from(scoreValue.map((x) => x.toJson())),
  //   };
  // }
}

class Judge {
  int id;
  String name;

  Judge({
    required this.id,
    required this.name,
  });

  factory Judge.fromJson(Map<String, dynamic> json) {
    return Judge(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class HrUser {
  int id;
  String name;

  HrUser({
    required this.id,
    required this.name,
  });

  factory HrUser.fromJson(Map<String, dynamic> json) {
    return HrUser(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ScorePolicy {
  int scoreFrom;
  int scoreTo;
  String color;
  String remark;

  ScorePolicy({
    required this.scoreFrom,
    required this.scoreTo,
    required this.color,
    required this.remark,
  });

  factory ScorePolicy.fromJson(Map<String, dynamic> json) {
    return ScorePolicy(
      scoreFrom: json['score_from'],
      scoreTo: json['score_to'],
      color: json['color'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score_from': scoreFrom,
      'score_to': scoreTo,
      'color': color,
      'remark': remark,
    };
  }
}

class FormData {
  String? code;
  int? percentage;
  int? scoreFrom;
  int? scoreTo;
  String? hrUsers;

  FormData({
     this.code,
     this.percentage,
     this.scoreFrom,
     this.scoreTo,
     this.hrUsers,
  });

  factory FormData.fromJson(Map<String, dynamic> json) {
    return FormData(
      code: json['code'],
      percentage: json['percentage'],
      scoreFrom: json['score_from'],
      scoreTo: json['score_to'],
      hrUsers: json['hr_users'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'percentage': percentage,
      'score_from': scoreFrom,
      'score_to': scoreTo,
      'hr_users': hrUsers,
    };
  }
}

class ScoreValue {
  int? inputId;
  String label;
  String type;
  String value;

  ScoreValue({
     this.inputId,
    required this.label,
    required this.type,
    required this.value,
  });

  factory ScoreValue.fromJson(Map<String, dynamic> json) {
    return ScoreValue(
      inputId: json['input_id'],
      label: json['label'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'input_id': inputId,
      'label': label,
      'type': type,
      'value': value,
    };
  }
}
