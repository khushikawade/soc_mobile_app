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
  String? answerKey;
  String? studentResponseKey;
  String? presentationURL;

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
      this.assessmentImage,
      this.answerKey,
      this.presentationURL,
      this.studentResponseKey);

  ResultSpreadsheet.fromList(
    List items, //bool? isStandalone
  ) : this(
            items[0],
            items[1],
            items[2],
            items[3],
            // isStandalone! ? items[12] :
            items[4],
            items[5],
            items[6],
            items[7],
            items[8],
            items[9],
            items[10],
            items[11],
            // isStandalone ? items[4] :
            items[12],
            items[13],
            items[14],
            items[15]);

  @override
  String toString() {
    return 'ResultSpreadsheet{id: $id, name: $name, pointsEarned: $pointsEarned,pointPossible: $pointPossible, assessmentQuestionImg: $assessmentQuestionImg, grade: $grade,className: $className,subject: $subject, learningStandard: $learningStandard,nyNextGenerationLearningStandard: $nyNextGenerationLearningStandard, ScoringRubric: $scoringRubric, CustomRubricImage: $customRubricImage,assessmentImage: $assessmentImage,answerKey:$answerKey,studentResponseKey:$studentResponseKey,presentationURL:$presentationURL }';
  }
}
