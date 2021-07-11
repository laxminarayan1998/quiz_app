import 'package:flutter/material.dart';

import '../constants.dart';

class DefaultButton extends StatelessWidget {
  final Function()? onPress;
  final String? text;
  const DefaultButton({
    Key? key,
    this.onPress,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27.0),
        // color: mainColor,
        gradient: kPrimaryGradientColor,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
        ),
        onPressed: onPress,
        child: Center(
          child: Text(
            '$text',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
