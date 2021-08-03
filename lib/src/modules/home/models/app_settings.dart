import 'attributes.dart';

class AppSettings {
	Attributes? attributes;
	String? id;
	String? ownerId;
	bool? isDeleted;
	String? name;
	String? createdDate;
	String? createdById;
	String? lastModifiedDate;
	String? lastModifiedById;
	String? systemModstamp;
	dynamic lastActivityDate;
	String? lastViewedDate;
	String? lastReferencedDate;
	String? schoolNameC;
	String? contactNameC;
	String? appIconC;
	dynamic splashScreenC;
	String? primaryColorC;
	String? backgroundColorC;
	String? secondaryColorC;
	dynamic appLogoC;
	dynamic fullLogoC;
	String? bottomNavigationC;
	String? appBuildStatusC;
	String? appInformationC;
	String? contactImageC;
	String? contactEmailC;
	String? contactPhoneC;
	String? contactAddressC;
	double? contactOfficeLocationLatitudeS;
	double? contactOfficeLocationLongitudeS;

	AppSettings({
		this.attributes, 
		this.id, 
		this.ownerId, 
		this.isDeleted, 
		this.name, 
		this.createdDate, 
		this.createdById, 
		this.lastModifiedDate, 
		this.lastModifiedById, 
		this.systemModstamp, 
		this.lastActivityDate, 
		this.lastViewedDate, 
		this.lastReferencedDate, 
		this.schoolNameC, 
		this.contactNameC, 
		this.appIconC, 
		this.splashScreenC, 
		this.primaryColorC, 
		this.backgroundColorC, 
		this.secondaryColorC, 
		this.appLogoC, 
		this.fullLogoC, 
		this.bottomNavigationC, 
		this.appBuildStatusC, 
		this.appInformationC, 
		this.contactImageC, 
		this.contactEmailC, 
		this.contactPhoneC, 
		this.contactAddressC, 
		this.contactOfficeLocationLatitudeS, 
		this.contactOfficeLocationLongitudeS, 
	});

	factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
				attributes: json['attributes'] == null
						? null
						: Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
				id: json['Id'] as String?,
				ownerId: json['OwnerId'] as String?,
				isDeleted: json['IsDeleted'] as bool?,
				name: json['Name'] as String?,
				createdDate: json['CreatedDate'] as String?,
				createdById: json['CreatedById'] as String?,
				lastModifiedDate: json['LastModifiedDate'] as String?,
				lastModifiedById: json['LastModifiedById'] as String?,
				systemModstamp: json['SystemModstamp'] as String?,
				lastActivityDate: json['LastActivityDate'],
				lastViewedDate: json['LastViewedDate'] as String?,
				lastReferencedDate: json['LastReferencedDate'] as String?,
				schoolNameC: json['School_Name__c'] as String?,
				contactNameC: json['Contact_Name__c'] as String?,
				appIconC: json['App_Icon__c'] as String?,
				splashScreenC: json['Splash_Screen__c'],
				primaryColorC: json['Primary_Color__c'] as String?,
				backgroundColorC: json['Background_Color__c'] as String?,
				secondaryColorC: json['Secondary_Color__c'] as String?,
				appLogoC: json['App_Logo__c'],
				fullLogoC: json['Full_Logo__c'],
				bottomNavigationC: json['Bottom_Navigation__c'] as String?,
				appBuildStatusC: json['App_Build_Status__c'] as String?,
				appInformationC: json['App_Information__c'] as String?,
				contactImageC: json['Contact_Image__c'] as String?,
				contactEmailC: json['Contact_Email__c'] as String?,
				contactPhoneC: json['Contact_Phone__c'] as String?,
				contactAddressC: json['Contact_Address__c'] as String?,
				contactOfficeLocationLatitudeS: json['Contact_Office_Location__Latitude__s'] as double?,
				contactOfficeLocationLongitudeS: json['Contact_Office_Location__Longitude__s'] as double?,
			);

	Map<String, dynamic> toJson() => {
				'attributes': attributes?.toJson(),
				'Id': id,
				'OwnerId': ownerId,
				'IsDeleted': isDeleted,
				'Name': name,
				'CreatedDate': createdDate,
				'CreatedById': createdById,
				'LastModifiedDate': lastModifiedDate,
				'LastModifiedById': lastModifiedById,
				'SystemModstamp': systemModstamp,
				'LastActivityDate': lastActivityDate,
				'LastViewedDate': lastViewedDate,
				'LastReferencedDate': lastReferencedDate,
				'School_Name__c': schoolNameC,
				'Contact_Name__c': contactNameC,
				'App_Icon__c': appIconC,
				'Splash_Screen__c': splashScreenC,
				'Primary_Color__c': primaryColorC,
				'Background_Color__c': backgroundColorC,
				'Secondary_Color__c': secondaryColorC,
				'App_Logo__c': appLogoC,
				'Full_Logo__c': fullLogoC,
				'Bottom_Navigation__c': bottomNavigationC,
				'App_Build_Status__c': appBuildStatusC,
				'App_Information__c': appInformationC,
				'Contact_Image__c': contactImageC,
				'Contact_Email__c': contactEmailC,
				'Contact_Phone__c': contactPhoneC,
				'Contact_Address__c': contactAddressC,
				'Contact_Office_Location__Latitude__s': contactOfficeLocationLatitudeS,
				'Contact_Office_Location__Longitude__s': contactOfficeLocationLongitudeS,
			};

		AppSettings copyWith({
		Attributes? attributes,
		String? id,
		String? ownerId,
		bool? isDeleted,
		String? name,
		String? createdDate,
		String? createdById,
		String? lastModifiedDate,
		String? lastModifiedById,
		String? systemModstamp,
		dynamic lastActivityDate,
		String? lastViewedDate,
		String? lastReferencedDate,
		String? schoolNameC,
		String? contactNameC,
		String? appIconC,
		dynamic splashScreenC,
		String? primaryColorC,
		String? backgroundColorC,
		String? secondaryColorC,
		dynamic appLogoC,
		dynamic fullLogoC,
		String? bottomNavigationC,
		String? appBuildStatusC,
		String? appInformationC,
		String? contactImageC,
		String? contactEmailC,
		String? contactPhoneC,
		String? contactAddressC,
		double? contactOfficeLocationLatitudeS,
		double? contactOfficeLocationLongitudeS,
	}) {
		return AppSettings(
			attributes: attributes ?? this.attributes,
			id: id ?? this.id,
			ownerId: ownerId ?? this.ownerId,
			isDeleted: isDeleted ?? this.isDeleted,
			name: name ?? this.name,
			createdDate: createdDate ?? this.createdDate,
			createdById: createdById ?? this.createdById,
			lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
			lastModifiedById: lastModifiedById ?? this.lastModifiedById,
			systemModstamp: systemModstamp ?? this.systemModstamp,
			lastActivityDate: lastActivityDate ?? this.lastActivityDate,
			lastViewedDate: lastViewedDate ?? this.lastViewedDate,
			lastReferencedDate: lastReferencedDate ?? this.lastReferencedDate,
			schoolNameC: schoolNameC ?? this.schoolNameC,
			contactNameC: contactNameC ?? this.contactNameC,
			appIconC: appIconC ?? this.appIconC,
			splashScreenC: splashScreenC ?? this.splashScreenC,
			primaryColorC: primaryColorC ?? this.primaryColorC,
			backgroundColorC: backgroundColorC ?? this.backgroundColorC,
			secondaryColorC: secondaryColorC ?? this.secondaryColorC,
			appLogoC: appLogoC ?? this.appLogoC,
			fullLogoC: fullLogoC ?? this.fullLogoC,
			bottomNavigationC: bottomNavigationC ?? this.bottomNavigationC,
			appBuildStatusC: appBuildStatusC ?? this.appBuildStatusC,
			appInformationC: appInformationC ?? this.appInformationC,
			contactImageC: contactImageC ?? this.contactImageC,
			contactEmailC: contactEmailC ?? this.contactEmailC,
			contactPhoneC: contactPhoneC ?? this.contactPhoneC,
			contactAddressC: contactAddressC ?? this.contactAddressC,
			contactOfficeLocationLatitudeS: contactOfficeLocationLatitudeS ?? this.contactOfficeLocationLatitudeS,
			contactOfficeLocationLongitudeS: contactOfficeLocationLongitudeS ?? this.contactOfficeLocationLongitudeS,
		);
	}
}
