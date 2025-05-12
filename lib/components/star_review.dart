import 'package:flutter/material.dart';
import 'package:histocr_app/theme/app_colors.dart';

class StarReview extends StatelessWidget {
  final int rating;
  final double size;
  final Function(int)? onRatingChanged;

  final Icon starOutline;
  final Icon starSolid;

  StarReview({
    super.key,
    this.rating = 0,
    required this.size,
    this.onRatingChanged,
  })  : starOutline = Icon(
          Icons.star_border_rounded,
          size: size,
          color: accentColor,
        ),
        starSolid = Icon(
          Icons.star_rounded,
          size: size,
          color: accentColor,
        );

  Widget buildStar(BuildContext context, int index) {
    Icon icon = index >= rating ? starOutline : starSolid;
    return InkResponse(
      onTap: () {
        onRatingChanged?.call(index + 1);
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => buildStar(context, index),
      ),
    );
  }
}
