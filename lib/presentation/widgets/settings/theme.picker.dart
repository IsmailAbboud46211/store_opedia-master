import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../../constant/themes.dart';
import '../../../logic/cubites/cubit/settings/Themes/themes_cubit.dart';
import '../../shared/custom_widgets/custom_text.dart';

void showThemePicker(BuildContext context) async {
  var size = MediaQuery.of(context).size;
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(LocaleKeys.select_the_theme.tr()),
          content: Row(children: [
            CircleAvatar(
              radius: size.width * 0.035,
              backgroundColor:
                  colorList[context.read<ThemesCubit>().getTheme()],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(
                text: "|",
                textColor: Theme.of(context).hintColor,
              ),
            ),
            buildIconButton(context, 0),
            buildIconButton(context, 1),
            buildIconButton(context, 2),
          ]),
        );
      });
}

Widget buildIconButton(BuildContext context, int index) => IconButton(
    onPressed: () {
      context.read<ThemesCubit>().changeTheme(index);

      Navigator.pop(context);
    },
    icon: Icon(
      Icons.circle_rounded,
      color: colorList[index],
    ));
