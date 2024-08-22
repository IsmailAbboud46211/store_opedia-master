// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../constant/profile_clipper.dart';

Widget buildProfileAppBar(BuildContext context) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      ClipPath(
          clipper: TsClip2(),
          child: Container(
            width: double.infinity,
            height: 200,
            color: Theme.of(context).colorScheme.primary,
          )),
      CircleAvatar(
        backgroundColor: Colors.grey.shade700,
        maxRadius: 65.0,
        child: CircleAvatar(
          maxRadius: 60,
          backgroundColor: Colors.grey.shade200,
          child: Icon(
            Icons.person_rounded,
            size: 100.0,
            color: Colors.grey.shade700,
          ),
        ),
      )
    ],
  );
}
