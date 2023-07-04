import 'package:hive/hive.dart';
part 'pbis_plus_common_behavior_modal.g.dart';

@HiveType(typeId: 54)
class PBISPlusCommonBehaviorModal {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? activeStatusC;
  @HiveField(2)
  String? behaviorTitleC;
  @HiveField(3)
  String? mobileAppC;
  @HiveField(4)
  String? pBISBehaviorIconURLC;
  @HiveField(5)
  String? pBISBehaviorSortOrderC;
  @HiveField(6)
  String? name;
  @HiveField(7)
  String? pBISSoundC;
  @HiveField(8)
  String? createdById;
  @HiveField(9)
  String? lastModifiedById;
  @HiveField(10)
  String? ownerId;

  PBISPlusCommonBehaviorModal(
      {this.id,
      this.activeStatusC,
      this.behaviorTitleC,
      this.mobileAppC,
      this.pBISBehaviorIconURLC,
      this.pBISBehaviorSortOrderC,
      this.name,
      this.pBISSoundC,
      this.createdById,
      this.lastModifiedById,
      this.ownerId});

  PBISPlusCommonBehaviorModal.fromJson(Map<String, dynamic> json) {
    id = json['Id'] ?? "";
    activeStatusC = json['Active_Status__c'] ?? '';
    behaviorTitleC = json['Behavior_Title__c'] ?? '';
    mobileAppC = json['Mobile_App__c'] ?? '';
    pBISBehaviorIconURLC = json['PBIS_Behavior_Icon_URL__c'] ?? '';
    pBISBehaviorSortOrderC = json['PBIS_Behavior_Sort_Order__c'] ?? '';
    name = json['Name'] ?? "";
    pBISSoundC = json['PBIS_Sound__c'] ?? '';
    createdById = json['CreatedById'] ?? "";
    lastModifiedById = json['LastModifiedById'] ?? '';
    ownerId = json['OwnerId'] ?? '';
  }

  PBISPlusCommonBehaviorModal.fromJsonForAdditionalBehavior(
      Map<String, dynamic> json) {
    id = json['Id'] ?? '';
    activeStatusC = json['Active_Status__c'] ?? "";
    behaviorTitleC = json['Name'] ?? '';
    mobileAppC = json['Mobile_App__c'] ?? '';
    pBISBehaviorIconURLC = json['Icon_URL__c'] ?? "";
    name = json['Name'] ?? "";
    pBISSoundC = json['PBIS_Sound__c'] ?? '';
    pBISBehaviorSortOrderC = json['Sort_Order__c'] ?? '';
    createdById = json['CreatedById'] ?? '';
    lastModifiedById = json['LastModifiedById'] ?? '';
    ownerId = json['OwnerId'] ?? '';
  }

  PBISPlusCommonBehaviorModal.fromJsonForTeacherCustomBehavior(
      Map<String, dynamic> json) {
    id = json['Id'].toString() ?? '';
    activeStatusC = json['Active_Status__c'] ?? "";
    behaviorTitleC = json['Name'] ?? '';
    mobileAppC = json['Mobile_App__c'] ?? '';
    pBISBehaviorIconURLC = json['Icon_URL'] ?? "";
    name = json['Name'] ?? "";
    pBISSoundC = json['PBIS_Sound__c'] ?? '';
    pBISBehaviorSortOrderC = json['Sorting_Order'] ?? '';
    createdById = json['CreatedAt'] ?? '';
    lastModifiedById = json['UpdatedAt'] ?? '';
    ownerId = json['OwnerId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Active_Status__c'] = this.activeStatusC;
    data['Behavior_Title__c'] = this.behaviorTitleC;
    data['Mobile_App__c'] = this.mobileAppC;
    data['PBIS_Behavior_Icon_URL__c'] = this.pBISBehaviorIconURLC;
    data['PBIS_Behavior_Sort_Order__c'] = this.pBISBehaviorSortOrderC;
    data['Name'] = this.name;
    data['PBIS_Sound__c'] = this.pBISSoundC;
    data['CreatedById'] = this.createdById;
    data['LastModifiedById'] = this.lastModifiedById;
    data['OwnerId'] = this.ownerId;
    return data;
  }

//------------------------------Will be removed later on-------------------------------
  static List<PBISPlusCommonBehaviorModal> demoBehaviorData = [
    PBISPlusCommonBehaviorModal(
      id: '1',
      activeStatusC: 'Active',
      behaviorTitleC: 'Title',
      mobileAppC: 'Mobile',
      pBISBehaviorIconURLC:
          'https://pbis-additional-icons.s3.us-east-2.amazonaws.com/icons8-apply-96.png',
      name: 'Name',
      pBISSoundC: 'Sound',
      pBISBehaviorSortOrderC: 'Sort Order',
      createdById: 'Created',
      lastModifiedById: 'Modified',
      ownerId: 'Owner',
    ),
    PBISPlusCommonBehaviorModal(
      id: '2',
      activeStatusC: 'Inactive',
      behaviorTitleC: 'Title',
      mobileAppC: 'App',
      pBISBehaviorIconURLC:
          'https://pbis-additional-icons.s3.us-east-2.amazonaws.com/icons8-airpods-pro-max-96.png',
      name: 'Object',
      pBISSoundC: 'Audio',
      pBISBehaviorSortOrderC: 'Order',
      createdById: 'Creator',
      lastModifiedById: 'Updater',
      ownerId: 'Owner',
    ),
    PBISPlusCommonBehaviorModal(
      id: '3',
      activeStatusC: 'Active',
      behaviorTitleC: 'Title',
      mobileAppC: 'Mobile',
      pBISBehaviorIconURLC:
          'https://pbis-additional-icons.s3.us-east-2.amazonaws.com/icons8-car-96.png',
      name: 'Name',
      pBISSoundC: 'Sound',
      pBISBehaviorSortOrderC: 'Sort Order',
      createdById: 'Created',
      lastModifiedById: 'Modified',
      ownerId: 'Owner',
    ),
    PBISPlusCommonBehaviorModal(
      id: '4',
      activeStatusC: 'Active',
      behaviorTitleC: 'Title',
      mobileAppC: 'Mobile',
      pBISBehaviorIconURLC:
          'https://pbis-additional-icons.s3.us-east-2.amazonaws.com/icons8-folded-hands-light-skin-tone-96.png',
      name: 'Name',
      pBISSoundC: 'Sound',
      pBISBehaviorSortOrderC: 'Sort Order',
      createdById: 'Created',
      lastModifiedById: 'Modified',
      ownerId: 'Owner',
    ),
    PBISPlusCommonBehaviorModal(
      id: '5',
      activeStatusC: 'Active',
      behaviorTitleC: 'Title',
      mobileAppC: 'Mobile',
      pBISBehaviorIconURLC:
          'https://pbis-additional-icons.s3.us-east-2.amazonaws.com/icons8-feedback-96.png',
      name: 'Name',
      pBISSoundC: 'Sound',
      pBISBehaviorSortOrderC: 'Sort Order',
      createdById: 'Created',
      lastModifiedById: 'Modified',
      ownerId: 'Owner',
    ),
    PBISPlusCommonBehaviorModal(
      id: '6',
      activeStatusC: 'Active',
      behaviorTitleC: 'Title',
      mobileAppC: 'Mobile',
      pBISBehaviorIconURLC:
          'https://pbis-additional-icons.s3.us-east-2.amazonaws.com/icons8-defend-family-96.png',
      name: 'Name',
      pBISSoundC: 'Sound',
      pBISBehaviorSortOrderC: 'Sort Order',
      createdById: 'Created',
      lastModifiedById: 'Modified',
      ownerId: 'Owner',
    ),
  ];
}
