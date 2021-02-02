part of 'translations_list_form_field.dart';

class _TranslationListTile extends StatelessWidget {
  final Translation translation;
  final ValueChanged<Translation> onRemove;

  const _TranslationListTile({
    Key key,
    @required this.translation,
    @required this.onRemove,
  })  : assert(translation != null),
        assert(onRemove != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 48.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: theme.primaryColor.withOpacity(0.3),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildTranslationText(theme),
          _buildRemoveButton(),
        ],
      ),
    );
  }

  Widget _buildTranslationText(ThemeData theme) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          translation.translation,
          style: theme.textTheme.subtitle1,
        ),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.remove),
        ),
        onTap: () => onRemove(translation),
      ),
    );
  }
}
