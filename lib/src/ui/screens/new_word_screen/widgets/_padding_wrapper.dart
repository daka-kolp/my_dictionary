part of '../new_word_screen.dart';

class _PaddingWrapper extends StatelessWidget {
  final Widget child;

  const _PaddingWrapper({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: child,
    );
  }
}
