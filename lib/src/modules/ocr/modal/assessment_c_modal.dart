// class AssessmentCModal {
//   String? ownerId;
//   String? isDeleted;
//   String? name;
//   String? createdDate;
//   String? createdById;
//   String? lastModifiedDate;
//   String? lastModifiedById;
//   String? systemModstamp;
//   String? lastViewedDate;
//   String? lastReferencedDate;
//   String? connectionReceivedId;
//   String? connectionSentId;
//   String? dateC;
//   String? nameC;
//   String? rubricC;
//   String? schoolC;
//   String? schoolYearC;
//   String? standardC;
//   String? subjectC;
//   String? teacherC;
//   String? typeC;
//   String? assessmentId;
//   String? id;
//   String? googleFileId;
//   String? sessionId;
//   String? teacherContactId;
//   String? teacherEmail;
//   String? createdAsPremium;
//   String? domainC;
//   String? subDomainC;
//   String? gradeC;
//   String? assessmentQueImageC;
//   String? answerKey;
//   String? assessmentType;
//   String? classroomCourseId;
//   String? classroomCourseWorkId;

//   AssessmentCModal(
//       {this.ownerId,
//       this.isDeleted,
//       this.name,
//       this.createdDate,
//       this.createdById,
//       this.lastModifiedDate,
//       this.lastModifiedById,
//       this.systemModstamp,
//       this.lastViewedDate,
//       this.lastReferencedDate,
//       this.connectionReceivedId,
//       this.connectionSentId,
//       this.dateC,
//       this.nameC,
//       this.rubricC,
//       this.schoolC,
//       this.schoolYearC,
//       this.standardC,
//       this.subjectC,
//       this.teacherC,
//       this.typeC,
//       this.assessmentId,
//       this.id,
//       this.googleFileId,
//       this.sessionId,
//       this.teacherContactId,
//       this.teacherEmail,
//       this.createdAsPremium,
//       this.domainC,
//       this.subDomainC,
//       this.gradeC,
//       this.assessmentQueImageC,
//       this.answerKey,
//       this.assessmentType,
//       this.classroomCourseId,
//       this.classroomCourseWorkId});

//   AssessmentCModal.fromJson(Map<String, dynamic> json) {
//     ownerId = json['OwnerId'] ?? '';
//     isDeleted = json['IsDeleted'] ?? '';
//     name = json['Name'] ?? '';
//     createdDate = json['CreatedDate'] ?? '';
//     createdById = json['CreatedById'] ?? '';
//     lastModifiedDate = json['LastModifiedDate'] ?? '';
//     lastModifiedById = json['LastModifiedById'] ?? '';
//     systemModstamp = json['SystemModstamp'] ?? '';
//     lastViewedDate = json['LastViewedDate'] ?? '';
//     lastReferencedDate = json['LastReferencedDate'] ?? '';
//     connectionReceivedId = json['ConnectionReceivedId'] ?? '';
//     connectionSentId = json['ConnectionSentId'] ?? '';
//     dateC = json['Date__c'] ?? '';
//     nameC = json['Name__c'] ?? '';
//     rubricC = json['Rubric__c'] ?? '';
//     schoolC = json['School__c'] ?? '';
//     schoolYearC = json['School_year__c'] ?? '';
//     standardC = json['Standard__c'] ?? '';
//     subjectC = json['Subject__c'] ?? '';
//     teacherC = json['Teacher__c'] ?? '';
//     typeC = json['Type__c'] ?? '';
//     assessmentId = json['Assessment_Id'] ?? '';
//     id = json['Id'] ?? '';
//     googleFileId = json['Google_File_Id'] ?? '';
//     sessionId = json['Session_Id'] ?? '';
//     teacherContactId = json['Teacher_Contact_Id'] ?? '';
//     teacherEmail = json['Teacher_Email'] ?? '';
//     createdAsPremium = json['Created_As_Premium'] ?? '';
//     domainC = json['Domain__c'] ?? '';
//     subDomainC = json['Sub_Domain__c'] ?? '';
//     gradeC = json['Grade__c'] ?? '';
//     assessmentQueImageC = json['Assessment_Que_Image__c'] ?? '';
//     answerKey = json['Answer_Key'] ?? '';
//     assessmentType = json['Assessment_Type'] ?? '';
//     classroomCourseId = json['Classroom_Course_Id'] ?? '';
//     classroomCourseWorkId = json['Classroom_Course_Work_Id'] ?? '';
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['OwnerId'] = this.ownerId;
//     data['IsDeleted'] = this.isDeleted;
//     data['Name'] = this.name;
//     data['CreatedDate'] = this.createdDate;
//     data['CreatedById'] = this.createdById;
//     data['LastModifiedDate'] = this.lastModifiedDate;
//     data['LastModifiedById'] = this.lastModifiedById;
//     data['SystemModstamp'] = this.systemModstamp;
//     data['LastViewedDate'] = this.lastViewedDate;
//     data['LastReferencedDate'] = this.lastReferencedDate;
//     data['ConnectionReceivedId'] = this.connectionReceivedId;
//     data['ConnectionSentId'] = this.connectionSentId;
//     data['Date__c'] = this.dateC;
//     data['Name__c'] = this.nameC;
//     data['Rubric__c'] = this.rubricC;
//     data['School__c'] = this.schoolC;
//     data['School_year__c'] = this.schoolYearC;
//     data['Standard__c'] = this.standardC;
//     data['Subject__c'] = this.subjectC;
//     data['Teacher__c'] = this.teacherC;
//     data['Type__c'] = this.typeC;
//     data['Assessment_Id'] = this.assessmentId;
//     data['Id'] = this.id;
//     data['Google_File_Id'] = this.googleFileId;
//     data['Session_Id'] = this.sessionId;
//     data['Teacher_Contact_Id'] = this.teacherContactId;
//     data['Teacher_Email'] = this.teacherEmail;
//     data['Created_As_Premium'] = this.createdAsPremium;
//     data['Domain__c'] = this.domainC;
//     data['Sub_Domain__c'] = this.subDomainC;
//     data['Grade__c'] = this.gradeC;
//     data['Assessment_Que_Image__c'] = this.assessmentQueImageC;
//     data['Answer_Key'] = this.answerKey;
//     data['Assessment_Type'] = this.assessmentType;
//     data['Classroom_Course_Id'] = this.classroomCourseId;
//     data['Classroom_Course_Work_Id'] = this.classroomCourseWorkId;
//     return data;
//   }
// }
