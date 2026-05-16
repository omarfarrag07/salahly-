import 'package:flutter/material.dart';
import 'package:kafa2a/config/colors_manager.dart';

class DefaultSubmitButton extends StatelessWidget {
  const DefaultSubmitButton(
      {super.key, required this.label, required this.onPressed});
  final String label;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.blue),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
