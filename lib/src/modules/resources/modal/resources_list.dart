class ResourcesList {
  // SubAttributes? attributes;
  String? titleC;
  String? imageURLC;
  String? address;
  String? phone;
  String? rtfHTMLC;
  String? email;
  final geoLocation;
  String? webUrlC;
  String? id;
  final sortOredr;

  ResourcesList({
    this.titleC,
    this.imageURLC,
    this.address,
    this.phone,
    this.rtfHTMLC,
    this.email,
    this.geoLocation,
    this.webUrlC,
    this.id,
    this.sortOredr,
  });

  factory ResourcesList.fromJson(Map<String, dynamic> json) =>
      ResourcesList(
        titleC: json['Title__c'] as String?,
        imageURLC: json['Image_URL__c'] as String?,
        address: json['Contact_Address__c'] as String?,
        phone: json['Phone__c'] as String?,
        rtfHTMLC: json['RTF_HTML__c'] as String?,
        email: json['Email__c'] as String?,
        geoLocation: json['Contact_Office_Location__c'] ,
        webUrlC: json['Website_URL__c'] as String?,
        id: json['Id'] as String?,
        sortOredr: json['Sort_Order__c'],
      );
  Map<String, dynamic> toJson() => {
        'Title__c': titleC,
        'Image_URL__c': imageURLC,
        'Contact_Address__c': address,
        'Phone__c': phone,
        'RTF_HTML__c': rtfHTMLC,
        'Email__c': email,
        'Contact_Office_Location__c': geoLocation,
        'Website_URL__c': webUrlC,
        'Id': id,
        'Sort_Order__c': sortOredr,
      };
}
