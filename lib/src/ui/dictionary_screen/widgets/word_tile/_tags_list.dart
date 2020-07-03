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
      children: tags.map(_buildTagItem).toList(),
    );
  }

  Widget _buildTagItem(Tag tag) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 0.5),
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: tag.color.withOpacity(0.5),
      ),
      alignment: Alignment.center,
      child: Text(
        tag.tag,
        softWrap: false,
        overflow: TextOverflow.fade,
      ),
    );
  }
}
