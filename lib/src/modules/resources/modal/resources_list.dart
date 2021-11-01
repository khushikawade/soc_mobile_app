class ResourcesList {
  String? titleC;
  String? id;
  String? appIconURLC;
  String? urlC;
  String? typeC;
  final statusc;
  final sortOrder;
  String? pdfURL;
  String? rtfHTMLC;
  String? calendarId;

  ResourcesList({
    this.titleC,
    this.id,
    this.appIconURLC,
    this.urlC,
    this.typeC,
    this.statusc,
    this.sortOrder,
    this.pdfURL,
    this.rtfHTMLC,
    this.calendarId,
  });

  factory ResourcesList.fromJson(Map<String, dynamic> json) => ResourcesList(
        titleC: json['Title__c'] as String?,
        appIconURLC: json['App_Icon_URL__c'] as String?,
        urlC: json['URL__c'] as String?,
        statusc: json['Active_Status__c'],
        typeC: json['Type__c'] as String?,
        id: json['Id'] as String?,
        sortOrder: json['Sort_Order__c'],
        pdfURL: json['PDF_URL__c'] as String?,
        rtfHTMLC: json['RTF_HTML__c'] as String?,
        calendarId: json['Calendar_Id__c'] as String?,
      );
  Map<String, dynamic> toJson() => {
        'Title__c': titleC,
        'App_Icon_URL__c': appIconURLC,
        'URL__c': urlC,
        'Active_Status__c': statusc,
        'Type__c': typeC,
        'Id': id,
        'Sort_Order__c': sortOrder,
        'RTF_HTML__c': rtfHTMLC,
        'Calendar_Id__c': calendarId,
        'PDF_URL__c': pdfURL,
      };
}
