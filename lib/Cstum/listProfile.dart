import 'package:flutter/material.dart';

Widget listProfile(IconData icon, String text1, String? text2) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
        ),
        const SizedBox(
          width: 24,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text1,
              style: const TextStyle(
                color: Color(0xFF111236),
                fontFamily: "Montserrat",
                fontSize: 14,
              ),
            ),
            Text(
              text2 ?? '', // Display 'N/A' if text2 is null
              style: const TextStyle(
                color: Color(0xFF111236),
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
