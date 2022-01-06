class SchoolDirectoryList {
  // SubAttributes? attributes;
  String? titleC;
  String? imageUrlC;
  String? address;
  String? phoneC;
  String? rtfHTMLC;
  String? emailC;
  final geoLocation;
  String? urlC;
  String? id;
  final sortOrder;
  final statusC;

  SchoolDirectoryList(
      {this.titleC,
      this.imageUrlC,
      this.address,
      this.phoneC,
      this.rtfHTMLC,
      this.emailC,
      this.geoLocation,
      this.urlC,
      this.id,
      this.sortOrder,
      this.statusC});

  factory SchoolDirectoryList.fromJson(Map<String, dynamic> json) =>
      SchoolDirectoryList(
          titleC: json['Title__c'] as String?,
          imageUrlC: json['Image_URL__c'] as String?,
          address: json['Contact_Address__c'] as String?,
          phoneC: json['phoneC__c'] as String?,
          rtfHTMLC: json['RTF_HTML__c'] as String?,
          emailC: json['emailC__c'] as String?,
          geoLocation: json['Contact_Office_Location__c'],
          urlC: json['Website_URL__c'] as String?,
          id: json['Id'] as String?,
          sortOrder: json['Sort_Order__c'],
          statusC: json['Active_Status__c']);

  Map<String, dynamic> toJson() => {
        'Title__c': titleC,
        'Image_URL__c': imageUrlC,
        'Contact_Address__c': address,
        'phoneC__c': phoneC,
        'RTF_HTML__c': rtfHTMLC,
        'emailC__c': emailC,
        'Contact_Office_Location__c': geoLocation,
        'Website_URL__c': urlC,
        'Id': id,
        'Sort_Order__c': sortOrder,
        'Active_Status__c': statusC
      };
}
