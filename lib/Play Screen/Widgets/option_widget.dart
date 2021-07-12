import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/Controller/auth_controller.dart';

import '../../constants.dart';
import '../../size_config.dart';

class OptionWidget extends StatelessWidget {
  final AuthController authController = Get.find();
  final String? text;
  final Function()? onPress;
  final String? isCorrect;
  OptionWidget({
    Key? key,
    this.text,
    this.onPress,
    this.isCorrect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.only(top: defaultPadding),
        padding: EdgeInsets.symmetric(
            vertical: defaultPadding / 1.2, horizontal: defaultPadding * 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            width: 2.0,
            color: isCorrect! == ''
                ? mainColor.withOpacity(.6)
                : isCorrect! == 'CORRECT'
                    ? Colors.green
                    : Colors.red,
          ),
        ),
        child: Row(
          children: [
            Text(
              '$text',
              style: TextStyle(
                fontSize: getProportionateScreenWidth(12),
                color: kTextColorLight,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(defaultPadding / 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCorrect! == ''
                    ? Colors.transparent
                    : isCorrect! == 'CORRECT'
                        ? Colors.green
                        : Colors.red,
                border: Border.all(
                  width: 2.0,
                  color: isCorrect! == ''
                      ? mainColor
                      : isCorrect! == 'CORRECT'
                          ? Colors.green
                          : Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
