import 'package:flutter/material.dart';

class TitleTile extends StatelessWidget {
  final String title;
  final bool isRequired;

  const TitleTile({
    Key? key,
    required this.title,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      color: theme.accentColor.withOpacity(0.3),
      child: RichText(
        text: TextSpan(
          text: title,
          style: theme.textTheme.subtitle1,
          children: <TextSpan>[
            if (isRequired)
              TextSpan(
                text: ' * ',
                style: theme.textTheme.subtitle1!.copyWith(
                  color: theme.errorColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
