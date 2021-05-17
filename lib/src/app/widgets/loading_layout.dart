import 'package:flutter/material.dart';

import 'package:mydictionaryapp/src/app/widgets/loading_indicator.dart';

class LoadingLayout extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  LoadingLayout({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> stack = [
      IgnorePointer(
        ignoring: isLoading,
        child: child,
      ),
    ];

    if (isLoading) {
      stack.add(
        SizedBox.expand(
          child: Container(
            color: Colors.black12,
            child: LoadingIndicator(),
          ),
        ),
      );
    }

    return Stack(
      children: stack,
    );
  }
}
