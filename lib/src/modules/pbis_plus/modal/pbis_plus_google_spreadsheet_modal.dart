// class PbisPlusGoogleSpreadSheetModal {
//   String? spreadsheetId;
//   List<Replies>? replies;

//   PbisPlusGoogleSpreadSheetModal({this.spreadsheetId, this.replies});

//   PbisPlusGoogleSpreadSheetModal.fromJson(Map<String, dynamic> json) {
//     spreadsheetId = json['spreadsheetId'];
//     if (json['replies'] != null) {
//       replies = <Replies>[];
//       json['replies'].forEach((v) {
//         replies!.add(new Replies.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['spreadsheetId'] = this.spreadsheetId;
//     if (this.replies != null) {
//       data['replies'] = this.replies!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Replies {
//   AddSheet? addSheet;

//   Replies({this.addSheet});

//   Replies.fromJson(Map<String, dynamic> json) {
//     addSheet = json['addSheet'] != null
//         ? new AddSheet.fromJson(json['addSheet'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.addSheet != null) {
//       data['addSheet'] = this.addSheet!.toJson();
//     }
//     return data;
//   }
// }

// class AddSheet {
//   Properties? properties;

//   AddSheet({this.properties});

//   AddSheet.fromJson(Map<String, dynamic> json) {
//     properties = json['properties'] != null
//         ? new Properties.fromJson(json['properties'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.properties != null) {
//       data['properties'] = this.properties!.toJson();
//     }
//     return data;
//   }
// }

// class Properties {
//   int? sheetId;
//   String? title;
//   int? index;
//   String? sheetType;
//   GridProperties? gridProperties;

//   Properties(
//       {this.sheetId,
//       this.title,
//       this.index,
//       this.sheetType,
//       this.gridProperties});

//   Properties.fromJson(Map<String, dynamic> json) {
//     sheetId = json['sheetId'];
//     title = json['title'];
//     index = json['index'];
//     sheetType = json['sheetType'];
//     gridProperties = json['gridProperties'] != null
//         ? new GridProperties.fromJson(json['gridProperties'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['sheetId'] = this.sheetId;
//     data['title'] = this.title;
//     data['index'] = this.index;
//     data['sheetType'] = this.sheetType;
//     if (this.gridProperties != null) {
//       data['gridProperties'] = this.gridProperties!.toJson();
//     }
//     return data;
//   }
// }

// class GridProperties {
//   int? rowCount;
//   int? columnCount;

//   GridProperties({this.rowCount, this.columnCount});

//   GridProperties.fromJson(Map<String, dynamic> json) {
//     rowCount = json['rowCount'];
//     columnCount = json['columnCount'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['rowCount'] = this.rowCount;
//     data['columnCount'] = this.columnCount;
//     return data;
//   }
// }
