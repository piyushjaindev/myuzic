import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  GradientButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF35EDFB),
            Color(0xFF2D9BEF),
            Color(0xFF9B2DEF),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(80.0)),
      ),
      child: ElevatedButton(
        onPressed: onPressed as void Function()?,
        child: Text(label),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
        ),
      ),
    );
  }
}
