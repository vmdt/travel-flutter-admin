import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final double size;
  final VoidCallback onPress;
  final BoxDecoration? customStyle;

  const BackButtonWidget({
    Key? key,
    required this.size,
    required this.onPress,
    this.customStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: customStyle ??
            BoxDecoration(
              color: Colors.grey[300],
              borderRadius:
                  BorderRadius.circular(8.0), // SIZES.small tương đương
            ),
        padding: EdgeInsets.all(5.0),
        child: Icon(
          Icons.arrow_back, // Tương đương với Ionicons "chevron-back"
          size: size,
          color: Colors.black,
        ),
      ),
    );
  }
}
