part of 'word_tile.dart';

class _TagsList extends StatelessWidget {
  final List<Tag> tags;

  const _TagsList({
    Key key,
    @required this.tags,
  })  : assert(tags != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tags.map((tag) => _buildTagItem(context, tag)).toList(),
    );
  }

  Widget _buildTagItem(
    BuildContext context,
    Tag tag,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: tag.color.withOpacity(0.5),
      ),
      alignment: Alignment.center,
      child: Text(
        tag.tag,
        style: Theme.of(context).textTheme.overline,
        softWrap: false,
        overflow: TextOverflow.fade,
      ),
    );
  }
}
