import 'package:flutter/material.dart';

class AccessibleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double? width;

  const AccessibleButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: text,
      child: Container(
        width: width,
        constraints: const BoxConstraints(
          minHeight: 44, // Altura mínima para accesibilidad táctil
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: fontSize + 2),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
