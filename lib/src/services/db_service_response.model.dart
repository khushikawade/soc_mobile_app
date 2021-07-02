import 'package:equatable/equatable.dart';

class ResponseModel extends Equatable {
  final statusCode;
  final data;

  ResponseModel({this.statusCode, this.data});

  List<Object?> get props => [statusCode, data];
}
