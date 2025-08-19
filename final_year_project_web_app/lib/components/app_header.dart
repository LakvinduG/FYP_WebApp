import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String logoAssetPath;
  final double titleFontSize;
  final double logoWidth;
  final double logoHeight;

  const AppHeader({
    Key? key,
    this.title = 'Shelf Life',
    this.logoAssetPath = 'assets/images/logoM002.png',
    this.titleFontSize = 50,
    this.logoWidth = 200,
    this.logoHeight = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF613EEA),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 10),
          Image.asset(
            logoAssetPath,
            width: logoWidth,
            height: logoHeight,
          ),
        ],
      ),
    );
  }
}
