import 'package:flutter/material.dart';
import 'package:quiz_app/Dashboard%20Screen/Widgets/score_widget.dart';

import '../../constants.dart';

class ScoreBoard extends StatelessWidget {
  final List? scores;
  const ScoreBoard({
    Key? key,
    this.scores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SCORE HISTORY (${scores!.length})',
              style: TextStyle(
                fontSize: 12,
                color: kSubTextColorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: defaultPadding),
            ...List.generate(
              scores!.length,
              (index) => ScoreWidget(
                index: index + 1,
                score: scores![index]['score'],
                time: scores![index]['timestamp'],
              ),
            ).toList()
          ],
        ),
      ),
    );
  }
}
