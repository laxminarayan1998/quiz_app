import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';

class Question extends StatelessWidget {
  final String? question;
  Question({
    Key? key,
    this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$question',
      style: TextStyle(
        fontSize: getProportionateScreenWidth(22),
        color: kTextColorLight,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
