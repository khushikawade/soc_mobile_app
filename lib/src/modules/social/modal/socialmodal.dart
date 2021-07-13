import 'dart:ffi';

import 'package:flutter/material.dart';

class SocialModel {
  const SocialModel({
    required this.tittle,
    required this.pubget,
    required this.description,
  });

  final tittle;
  final pubget; //TIMESTAMP
  final description;
}
