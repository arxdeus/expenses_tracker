import 'package:flutter/material.dart';
import 'package:resources/_assets/fonts.gen.dart';

class BlockTitle extends StatelessWidget {
  const BlockTitle({
    required this.text,
    this.onTap,
    super.key,
  });

  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 14,
            child: FittedBox(
              child: Text(
                text,
                style: TextStyle(
                  height: 1,
                  fontFamily: FontFamily.euclidFlex,
                  color: Colors.black,
                  fontSize: 256,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Spacer(
            flex: 4,
          ),
          Expanded(
            flex: 3,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.chevron_right_outlined,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
