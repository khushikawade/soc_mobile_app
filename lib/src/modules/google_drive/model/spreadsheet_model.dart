class ResultSpreadsheet {
  String? id;
  String? name;
  String? pointsEarned;
  String? pointPossible;
  String? assessmentQuestionImg;
  String? grade;
  String? className;
  String? subject;
  String? learningStandard;
  String? nyNextGenerationLearningStandard;
  String? scoringRubric;
  String? customRubricImage;
  String? assessmentImage;

  ResultSpreadsheet(
      this.id,
      this.name,
      this.pointsEarned,
      this.pointPossible,
      this.assessmentQuestionImg,
      this.grade,
      this.className,
      this.subject,
      this.learningStandard,
      this.nyNextGenerationLearningStandard,
      this.scoringRubric,
      this.customRubricImage,
      this.assessmentImage);

  ResultSpreadsheet.fromList(
    List items,
  ) : this(items[0], items[1], items[2], items[3], items[4], items[5], items[6],
            items[7], items[8], items[9], items[10], items[11], items[12]);

  @override
  String toString() {
    return 'ResultSpreadsheet{id: $id, name: $name, pointsEarned: $pointsEarned,pointPossible: $pointPossible, assessmentQuestionImg: $assessmentQuestionImg, grade: $grade,className: $className,subject: $subject, learningStandard: $learningStandard,nyNextGenerationLearningStandard: $nyNextGenerationLearningStandard, ScoringRubric: $scoringRubric, CustomRubricImage: $customRubricImage,assessmentImage: $assessmentImage}';
  }
}
