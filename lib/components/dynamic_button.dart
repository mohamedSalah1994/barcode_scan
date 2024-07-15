import 'package:flutter/material.dart';

class DynamicButton extends StatelessWidget {
  final Function()? onTap;

  final double paddingNum;
  final Future<Object?>? future;
  final Widget Function(BuildContext, AsyncSnapshot<Object?>) builder;
  const DynamicButton({
    super.key,
    required this.onTap,
    this.paddingNum = 20,
    required this.future,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(paddingNum),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: FutureBuilder(future: future, builder: builder),
      ),
    );
  }
}
