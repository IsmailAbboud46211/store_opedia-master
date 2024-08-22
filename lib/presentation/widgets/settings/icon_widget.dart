import 'package:flutter/material.dart';

Widget iconWidget({required IconData icon, required Color color}) => Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
