import 'package:flutter/material.dart';
import 'package:resources/resources.dart';

class IconText extends StatelessWidget {
  const IconText({
    required this.text,
    this.icon,
    super.key,
  });

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: text,
        style: const TextStyle(
          height: 1.5,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: FontFamily.euclidFlex,
          fontSize: 18,
        ),
        children: [
          WidgetSpan(
            child: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
