import 'package:block_english/utils/constants.dart';
import 'package:flutter/material.dart';

class RoundCornerRouteButton extends StatelessWidget {
  const RoundCornerRouteButton({
    super.key,
    required this.text,
    required this.routeName,
    required this.width,
    required this.height,
    required this.type,
    this.cancel = false,
  });

  final String text;
  final String routeName;
  final double width;
  final double height;
  final ButtonType type;
  final bool cancel;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ButtonType.filled => FilledButton(
          onPressed: () {
            cancel
                ? Navigator.of(context).pop()
                : Navigator.of(context).pushNamed(routeName);
          },
          style: FilledButton.styleFrom(minimumSize: Size(width, height)),
          child: (Text(text)),
        ),
      ButtonType.outlined => OutlinedButton(
          onPressed: () {
            cancel
                ? Navigator.of(context).pop()
                : Navigator.of(context).pushNamed(routeName);
          },
          style: OutlinedButton.styleFrom(minimumSize: Size(width, height)),
          child: (Text(text)),
        ),
    };
  }
}
