import 'package:flutter/material.dart';

class IdeeynButtonStyle {
  IdeeynButtonStyle._();

  /// custom box button. in case need circular one, just change the borderradius
  static ButtonStyle custom({
    Color backgroundColor = const Color.fromARGB(240, 255, 255, 255),
    Color rippleColor = const Color.fromRGBO(97, 97, 97, 1),
    Color contentColor = Colors.black,
    Color contentColorPressed = Colors.white,
    EdgeInsets padding = EdgeInsets.zero,
    double borderRadius = 10,
    BorderSide border = const BorderSide(color: Colors.black45, width: 0.5),
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(backgroundColor),
      overlayColor: WidgetStatePropertyAll(rippleColor),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.pressed)
              ? contentColorPressed
              : contentColor;
        },
      ),
      splashFactory: InkRipple.splashFactory,
      padding: WidgetStatePropertyAll(padding),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius), side: border)),
      elevation: const WidgetStatePropertyAll(0.5),
    );
  }
}
