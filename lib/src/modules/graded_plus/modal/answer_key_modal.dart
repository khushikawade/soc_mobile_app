import 'package:flutter/cupertino.dart';

class AnswerKeyModal {
  String? title;
  Color? color;
  AnswerKeyModal({
    required this.title,
    required this.color,
  });
// A (B5FFC5)
// B (FCD1CB)
// C (E6E4F9)
// D (FEE8D0)
// E (EBD2FF)
// F (B5E0FF) Optional
  static List<AnswerKeyModal> answerKeyModelList = [
    AnswerKeyModal(title: 'A', color: Color(0xffB5FFC5)),
    AnswerKeyModal(title: 'B', color: Color(0xffFCD1CB)),
    AnswerKeyModal(title: 'C', color: Color(0xffE6E4F9)),
    AnswerKeyModal(title: 'D', color: Color(0xffFEE8D0)),
    AnswerKeyModal(title: 'E', color: Color(0xffEBD2FF)),
    //AnswerKeyModal(title: 'F', color: Color(0xffB5E0FF)) //Optional
  ];
}
