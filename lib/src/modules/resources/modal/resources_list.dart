class ResourcesList {
  String? titleC;
  String? id;
  String? appIconURLC;
  String? urlC;
  final statusc;
  final sortOrder;

  ResourcesList({
    this.titleC,
    this.id,
    this.appIconURLC,
    this.urlC,
    this.statusc,
    this.sortOrder,
  });

  factory ResourcesList.fromJson(Map<String, dynamic> json) => ResourcesList(
        titleC: json['Title__c'] as String?,
        appIconURLC: json['App_Icon_URL__c'] as String?,
        urlC: json['URL__c'] as String?,
        statusc: json['Active_Status__c'],
        id: json['Id'] as String?,
        sortOrder: json['Sort_Order__c'],
      );
  Map<String, dynamic> toJson() => {
        'Title__c': titleC,
        'App_Icon_URL__c': appIconURLC,
        'URL__c': urlC,
        'Active_Status__c': statusc,
        'Id': id,
        'Sort_Order__c': sortOrder,
      };
}
