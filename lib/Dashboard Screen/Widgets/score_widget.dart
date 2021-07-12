import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class ScoreWidget extends StatelessWidget {
  final int? index;
  final int? score;
  final Timestamp? time;
  const ScoreWidget({
    Key? key,
    this.score,
    this.time,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding * 2,
        vertical: defaultPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27.0),
        color: kTextColorLight.withOpacity(.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0x06ffffff),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '$index.',
            style: TextStyle(
              fontSize: 16,
              color: kSubTextColorLight,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '$score Points',
            style: TextStyle(
              fontSize: 16,
              color: kTextColorLight,
            ),
          ),
          Spacer(),
          Text(
            '${DateFormat('dd MMM').format(DateTime.parse(time!.toDate().toString()))}',
            style: TextStyle(
              fontSize: 16,
              color: kTextColorLight,
            ),
          ),
        ],
      ),
    );
  }
}
