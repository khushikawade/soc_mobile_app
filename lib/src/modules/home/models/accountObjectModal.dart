class AccountObjectModal {
  Attributes? attributes;
  String? id;
  String? isDeleted;
  String? masterRecordId;
  String? name;
  String? type;
  String? parentId;
  String? billingStreet;
  String? billingCity;
  String? billingState;
  String? billingPostalCode;
  String? billingCountry;
  String? billingLatitude;
  String? billingLongitude;
  String? billingGeocodeAccuracy;
  String? billingAddress;
  String? shippingStreet;
  String? shippingCity;
  String? shippingState;
  String? shippingPostalCode;
  String? shippingCountry;
  String? shippingLatitude;
  String? shippingLongitude;
  String? shippingGeocodeAccuracy;
  String? shippingAddress;
  String? phone;
  String? website;
  String? photoUrl;
  String? industry;
  String? numberOfEmployees;
  String? description;
  String? ownerId;
  String? createdDate;
  String? createdById;
  String? lastModifiedDate;
  String? lastModifiedById;
  String? systemModstamp;
  String? lastActivityDate;
  String? lastViewedDate;
  String? lastReferencedDate;
  String? jigsaw;
  String? jigsawCompanyId;
  String? accountSource;
  String? sicDesc;
  String? connectionReceivedId;
  String? connectionSentId;
  String? tdcTswSMSOptOutC;
  String? formstackLinkC;
  String? blueCardC;
  String? appC;
  String? dataDashboardC;
  String? eLACoachingC;
  String? mathCoachingC;
  String? formsC;
  String? graduationTrackerC;
  String? marketingDesignC;
  String? merchandiseC;
  String? eventsC;
  String? learningPlatformC;
  String? totalServicesC;
  String? pushNotificationOptOutC;
  String? appStartDateC;
  String? schoolSFIDC;
  String? dBNC;
  String? schoolDistrictC;
  String? appEndDateC;
  String? emailC;
  String? primaryContactC;
  String? updateC;
  String? emailOpensFromMailchimpC;
  String? gRADEDPremiumC;
  String? totalPushMessagesSentC;
  String? successfulPushDeliveriesPerPushC;
  String? websitesC;
  String? gradedC;
  String? promoVideoC;
  String? otherCoachingC;
  String? oneSignalPushesSentBeforeIntegC;
  String? enrollmentC;
  String? gradebandC;
  String? nYCDOESchoolsLookupC;
  String? nYCDOESchoolsLookupURLC;
  String? newestPushMessageC;
  String? formsStartedC;
  String? newestPushDateC;
  String? formsCompletedC;
  String? completedC;
  String? superintendentC;
  String? administrativeDistrictC;
  String? boroughC;
  String? principalC;
  String? gradesC;
  String? slackChannelEmailC;

  AccountObjectModal(
      {this.attributes,
      this.id,
      this.isDeleted,
      this.masterRecordId,
      this.name,
      this.type,
      this.parentId,
      this.billingStreet,
      this.billingCity,
      this.billingState,
      this.billingPostalCode,
      this.billingCountry,
      this.billingLatitude,
      this.billingLongitude,
      this.billingGeocodeAccuracy,
      this.billingAddress,
      this.shippingStreet,
      this.shippingCity,
      this.shippingState,
      this.shippingPostalCode,
      this.shippingCountry,
      this.shippingLatitude,
      this.shippingLongitude,
      this.shippingGeocodeAccuracy,
      this.shippingAddress,
      this.phone,
      this.website,
      this.photoUrl,
      this.industry,
      this.numberOfEmployees,
      this.description,
      this.ownerId,
      this.createdDate,
      this.createdById,
      this.lastModifiedDate,
      this.lastModifiedById,
      this.systemModstamp,
      this.lastActivityDate,
      this.lastViewedDate,
      this.lastReferencedDate,
      this.jigsaw,
      this.jigsawCompanyId,
      this.accountSource,
      this.sicDesc,
      this.connectionReceivedId,
      this.connectionSentId,
      this.tdcTswSMSOptOutC,
      this.formstackLinkC,
      this.blueCardC,
      this.appC,
      this.dataDashboardC,
      this.eLACoachingC,
      this.mathCoachingC,
      this.formsC,
      this.graduationTrackerC,
      this.marketingDesignC,
      this.merchandiseC,
      this.eventsC,
      this.learningPlatformC,
      this.totalServicesC,
      this.pushNotificationOptOutC,
      this.appStartDateC,
      this.schoolSFIDC,
      this.dBNC,
      this.schoolDistrictC,
      this.appEndDateC,
      this.emailC,
      this.primaryContactC,
      this.updateC,
      this.emailOpensFromMailchimpC,
      this.gRADEDPremiumC,
      this.totalPushMessagesSentC,
      this.successfulPushDeliveriesPerPushC,
      this.websitesC,
      this.gradedC,
      this.promoVideoC,
      this.otherCoachingC,
      this.oneSignalPushesSentBeforeIntegC,
      this.enrollmentC,
      this.gradebandC,
      this.nYCDOESchoolsLookupC,
      this.nYCDOESchoolsLookupURLC,
      this.newestPushMessageC,
      this.formsStartedC,
      this.newestPushDateC,
      this.formsCompletedC,
      this.completedC,
      this.superintendentC,
      this.administrativeDistrictC,
      this.boroughC,
      this.principalC,
      this.gradesC,
      this.slackChannelEmailC});

  AccountObjectModal.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
    id = json['Id'];
    isDeleted = json['IsDeleted'];
    masterRecordId = json['MasterRecordId'];
    name = json['Name'];
    type = json['Type'];
    parentId = json['ParentId'];
    billingStreet = json['BillingStreet'];
    billingCity = json['BillingCity'];
    billingState = json['BillingState'];
    billingPostalCode = json['BillingPostalCode'];
    billingCountry = json['BillingCountry'];
    billingLatitude = json['BillingLatitude'];
    billingLongitude = json['BillingLongitude'];
    billingGeocodeAccuracy = json['BillingGeocodeAccuracy'];
    billingAddress = json['BillingAddress'];
    shippingStreet = json['ShippingStreet'];
    shippingCity = json['ShippingCity'];
    shippingState = json['ShippingState'];
    shippingPostalCode = json['ShippingPostalCode'];
    shippingCountry = json['ShippingCountry'];
    shippingLatitude = json['ShippingLatitude'];
    shippingLongitude = json['ShippingLongitude'];
    shippingGeocodeAccuracy = json['ShippingGeocodeAccuracy'];
    shippingAddress = json['ShippingAddress'];
    phone = json['Phone'];
    website = json['Website'];
    photoUrl = json['PhotoUrl'];
    industry = json['Industry'];
    numberOfEmployees = json['NumberOfEmployees'];
    description = json['Description'];
    ownerId = json['OwnerId'];
    createdDate = json['CreatedDate'];
    createdById = json['CreatedById'];
    lastModifiedDate = json['LastModifiedDate'];
    lastModifiedById = json['LastModifiedById'];
    systemModstamp = json['SystemModstamp'];
    lastActivityDate = json['LastActivityDate'];
    lastViewedDate = json['LastViewedDate'];
    lastReferencedDate = json['LastReferencedDate'];
    jigsaw = json['Jigsaw'];
    jigsawCompanyId = json['JigsawCompanyId'];
    accountSource = json['AccountSource'];
    sicDesc = json['SicDesc'];
    connectionReceivedId = json['ConnectionReceivedId'];
    connectionSentId = json['ConnectionSentId'];
    tdcTswSMSOptOutC = json['tdc_tsw__SMS_Opt_out__c'];
    formstackLinkC = json['Formstack_Link__c'];
    blueCardC = json['Blue_Card__c'];
    appC = json['App__c'];
    dataDashboardC = json['Data_Dashboard__c'];
    eLACoachingC = json['ELA_Coaching__c'];
    mathCoachingC = json['Math_Coaching__c'];
    formsC = json['Forms__c'];
    graduationTrackerC = json['Graduation_Tracker__c'];
    marketingDesignC = json['Marketing_Design__c'];
    merchandiseC = json['Merchandise__c'];
    eventsC = json['Events__c'];
    learningPlatformC = json['Learning_Platform__c'];
    totalServicesC = json['Total_Services__c'];
    pushNotificationOptOutC = json['Push_Notification_Opt_Out__c'];
    appStartDateC = json['App_Start_Date__c'];
    schoolSFIDC = json['School_SF_ID__c'];
    dBNC = json['DBN__c'];
    schoolDistrictC = json['School_District__c'];
    appEndDateC = json['App_End_Date__c'];
    emailC = json['Email__c'];
    primaryContactC = json['Primary_Contact__c'];
    updateC = json['Update__c'];
    emailOpensFromMailchimpC = json['Email_opens_from_Mailchimp__c'];
    gRADEDPremiumC = json['GRADED_Premium__c'];
    totalPushMessagesSentC = json['Total_Push_Messages_Sent__c'];
    successfulPushDeliveriesPerPushC =
        json['Successful_Push_Deliveries_per_Push__c'];
    websitesC = json['Websites__c'];
    gradedC = json['Graded__c'];
    promoVideoC = json['Promo_Video__c'];
    otherCoachingC = json['Other_Coaching__c'];
    oneSignalPushesSentBeforeIntegC =
        json['OneSignal_pushes_sent_before_integ__c'];
    enrollmentC = json['Enrollment__c'];
    gradebandC = json['Gradeband__c'];
    nYCDOESchoolsLookupC = json['NYC_DOE_Schools_Lookup__c'];
    nYCDOESchoolsLookupURLC = json['NYC_DOE_Schools_Lookup_URL__c'];
    newestPushMessageC = json['Newest_Push_Message__c'];
    formsStartedC = json['Forms_Started__c'];
    newestPushDateC = json['Newest_Push_Date__c'];
    formsCompletedC = json['Forms_Completed__c'];
    completedC = json['Completed__c'];
    superintendentC = json['Superintendent__c'];
    administrativeDistrictC = json['Administrative_District__c'];
    boroughC = json['Borough__c'];
    principalC = json['Principal__c'];
    gradesC = json['Grades__c'];
    slackChannelEmailC = json['Slack_Channel_Email__c'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    data['Id'] = this.id;
    data['IsDeleted'] = this.isDeleted;
    data['MasterRecordId'] = this.masterRecordId;
    data['Name'] = this.name;
    data['Type'] = this.type;
    data['ParentId'] = this.parentId;
    data['BillingStreet'] = this.billingStreet;
    data['BillingCity'] = this.billingCity;
    data['BillingState'] = this.billingState;
    data['BillingPostalCode'] = this.billingPostalCode;
    data['BillingCountry'] = this.billingCountry;
    data['BillingLatitude'] = this.billingLatitude;
    data['BillingLongitude'] = this.billingLongitude;
    data['BillingGeocodeAccuracy'] = this.billingGeocodeAccuracy;
    data['BillingAddress'] = this.billingAddress;
    data['ShippingStreet'] = this.shippingStreet;
    data['ShippingCity'] = this.shippingCity;
    data['ShippingState'] = this.shippingState;
    data['ShippingPostalCode'] = this.shippingPostalCode;
    data['ShippingCountry'] = this.shippingCountry;
    data['ShippingLatitude'] = this.shippingLatitude;
    data['ShippingLongitude'] = this.shippingLongitude;
    data['ShippingGeocodeAccuracy'] = this.shippingGeocodeAccuracy;
    data['ShippingAddress'] = this.shippingAddress;
    data['Phone'] = this.phone;
    data['Website'] = this.website;
    data['PhotoUrl'] = this.photoUrl;
    data['Industry'] = this.industry;
    data['NumberOfEmployees'] = this.numberOfEmployees;
    data['Description'] = this.description;
    data['OwnerId'] = this.ownerId;
    data['CreatedDate'] = this.createdDate;
    data['CreatedById'] = this.createdById;
    data['LastModifiedDate'] = this.lastModifiedDate;
    data['LastModifiedById'] = this.lastModifiedById;
    data['SystemModstamp'] = this.systemModstamp;
    data['LastActivityDate'] = this.lastActivityDate;
    data['LastViewedDate'] = this.lastViewedDate;
    data['LastReferencedDate'] = this.lastReferencedDate;
    data['Jigsaw'] = this.jigsaw;
    data['JigsawCompanyId'] = this.jigsawCompanyId;
    data['AccountSource'] = this.accountSource;
    data['SicDesc'] = this.sicDesc;
    data['ConnectionReceivedId'] = this.connectionReceivedId;
    data['ConnectionSentId'] = this.connectionSentId;
    data['tdc_tsw__SMS_Opt_out__c'] = this.tdcTswSMSOptOutC;
    data['Formstack_Link__c'] = this.formstackLinkC;
    data['Blue_Card__c'] = this.blueCardC;
    data['App__c'] = this.appC;
    data['Data_Dashboard__c'] = this.dataDashboardC;
    data['ELA_Coaching__c'] = this.eLACoachingC;
    data['Math_Coaching__c'] = this.mathCoachingC;
    data['Forms__c'] = this.formsC;
    data['Graduation_Tracker__c'] = this.graduationTrackerC;
    data['Marketing_Design__c'] = this.marketingDesignC;
    data['Merchandise__c'] = this.merchandiseC;
    data['Events__c'] = this.eventsC;
    data['Learning_Platform__c'] = this.learningPlatformC;
    data['Total_Services__c'] = this.totalServicesC;
    data['Push_Notification_Opt_Out__c'] = this.pushNotificationOptOutC;
    data['App_Start_Date__c'] = this.appStartDateC;
    data['School_SF_ID__c'] = this.schoolSFIDC;
    data['DBN__c'] = this.dBNC;
    data['School_District__c'] = this.schoolDistrictC;
    data['App_End_Date__c'] = this.appEndDateC;
    data['Email__c'] = this.emailC;
    data['Primary_Contact__c'] = this.primaryContactC;
    data['Update__c'] = this.updateC;
    data['Email_opens_from_Mailchimp__c'] = this.emailOpensFromMailchimpC;
    data['GRADED_Premium__c'] = this.gRADEDPremiumC;
    data['Total_Push_Messages_Sent__c'] = this.totalPushMessagesSentC;
    data['Successful_Push_Deliveries_per_Push__c'] =
        this.successfulPushDeliveriesPerPushC;
    data['Websites__c'] = this.websitesC;
    data['Graded__c'] = this.gradedC;
    data['Promo_Video__c'] = this.promoVideoC;
    data['Other_Coaching__c'] = this.otherCoachingC;
    data['OneSignal_pushes_sent_before_integ__c'] =
        this.oneSignalPushesSentBeforeIntegC;
    data['Enrollment__c'] = this.enrollmentC;
    data['Gradeband__c'] = this.gradebandC;
    data['NYC_DOE_Schools_Lookup__c'] = this.nYCDOESchoolsLookupC;
    data['NYC_DOE_Schools_Lookup_URL__c'] = this.nYCDOESchoolsLookupURLC;
    data['Newest_Push_Message__c'] = this.newestPushMessageC;
    data['Forms_Started__c'] = this.formsStartedC;
    data['Newest_Push_Date__c'] = this.newestPushDateC;
    data['Forms_Completed__c'] = this.formsCompletedC;
    data['Completed__c'] = this.completedC;
    data['Superintendent__c'] = this.superintendentC;
    data['Administrative_District__c'] = this.administrativeDistrictC;
    data['Borough__c'] = this.boroughC;
    data['Principal__c'] = this.principalC;
    data['Grades__c'] = this.gradesC;
    data['Slack_Channel_Email__c'] = this.slackChannelEmailC;
    return data;
  }
}

class Attributes {
  String? type;
  String? url;

  Attributes({this.type, this.url});

  Attributes.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}
