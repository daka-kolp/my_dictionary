part of '../new_word_screen.dart';

class _TitleTile extends StatelessWidget {
  final String title;
  final bool isRequired;

  const _TitleTile({
    Key key,
    @required this.title,
    bool isRequired,
  })  : this.isRequired = isRequired ?? false,
        assert(title != null),
        super(key: key);

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
                style: theme.textTheme.subtitle1.copyWith(
                  color: theme.errorColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
