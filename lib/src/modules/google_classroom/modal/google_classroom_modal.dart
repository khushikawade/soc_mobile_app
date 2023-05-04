class GoogleClassroomCourseworkModal {
  int? statusCode;
  String? courseWorkId;
  String? courseWorkURL;
  String? workType;
  List<Body>? body;

  GoogleClassroomCourseworkModal(
      {this.statusCode,
      this.courseWorkId,
      this.courseWorkURL,
      this.workType,
      this.body});

  GoogleClassroomCourseworkModal.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'] ?? '';
    courseWorkId = json['courseWorkId'] ?? '';
    courseWorkURL = json['courseWorkURL'] ?? '';
    workType = json['workType'] ?? '';
    if (json['body'] != null) {
      body = <Body>[];
      json['body'].forEach((v) {
        body!.add(new Body.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['courseWorkId'] = this.courseWorkId;
    data['courseWorkURL'] = this.courseWorkURL;
    data['workType'] = this.workType;
    if (this.body != null) {
      data['body'] = this.body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Body {
  String? submissionId;
  String? userId;
  String? assessmentImage;
  int? earnedPoint;

  Body(
      {this.submissionId, this.userId, this.assessmentImage, this.earnedPoint});

  Body.fromJson(Map<String, dynamic> json) {
    submissionId = json['submissionId'] ?? '';
    userId = json['userId'] ?? '';
    assessmentImage = json['assessmentImage'] ?? '';
    earnedPoint = json['EarnedPoint'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['submissionId'] = this.submissionId;
    data['userId'] = this.userId;
    data['assessmentImage'] = this.assessmentImage;
    data['EarnedPoint'] = this.earnedPoint;
    return data;
  }
}
