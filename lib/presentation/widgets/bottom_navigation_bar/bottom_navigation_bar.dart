import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:shopesapp/data/enums/bottom_navigation.dart';

import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../main.dart';
import '../../shared/colors.dart';
import 'bottom_nav_clipper.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget(
      {Key? key, required this.bottomNavigationEnum, required this.onTap})
      : super(key: key);
  final BottomNavigationEnum bottomNavigationEnum;
  final Function(BottomNavigationEnum, int) onTap;

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(alignment: Alignment.bottomCenter, children: [
      CustomPaint(
        painter: BottomNavShadowPainter(
            shadow: Shadow(blurRadius: 5, color: AppColors.mainTextColor),
            clipper: BottomNavClipper()),
        child: ClipPath(
          clipper: BottomNavClipper(),
          child: Container(
            width: size.width,
            height: size.height * 0.09,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      ),
      Padding(
          padding: EdgeInsets.only(bottom: 0.04 * size.height),
          child: InkWell(
            onTap: () {
              widget.onTap(BottomNavigationEnum.HOME, 2);
            },
            child: CircleAvatar(
              backgroundColor:
                  widget.bottomNavigationEnum == BottomNavigationEnum.HOME
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.mainTextColor,
              radius: size.width * 0.085,
              child: Icon(
                Icons.home,
                color: AppColors.mainWhiteColor,
              ),
            ),
          )),
      Positioned(
        bottom: size.height * 0.013,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              navItem(
                  text: LocaleKeys.settings.tr(),
                  icon: Icons.settings,
                  isSelected:
                      widget.bottomNavigationEnum == BottomNavigationEnum.MORE,
                  onTap: () {
                    widget.onTap(BottomNavigationEnum.MORE, 0);
                  },
                  size: size),
              navItem(
                  icon: Icons.store,
                  text: LocaleKeys.stores.tr(),
                  isSelected: widget.bottomNavigationEnum ==
                      BottomNavigationEnum.STORES,
                  onTap: () {
                    widget.onTap(BottomNavigationEnum.STORES, 1);
                  },
                  size: size),
              SizedBox(
                width: size.width * 0.25,
              ),
              navItem(
                  icon: Icons.favorite,
                  text: LocaleKeys.favorites.tr(),
                  isSelected: widget.bottomNavigationEnum ==
                      BottomNavigationEnum.FAVORITES,
                  onTap: () {
                    widget.onTap(BottomNavigationEnum.FAVORITES, 3);
                  },
                  size: size),
              navItem(
                  icon: Icons.person,
                  text: LocaleKeys.pofile.tr(),
                  isSelected: widget.bottomNavigationEnum ==
                      BottomNavigationEnum.PROFILE,
                  onTap: () {
                    widget.onTap(BottomNavigationEnum.PROFILE, 4);
                  },
                  size: size),
            ],
          ),
        ),
      )
    ]);
  }

  Widget navItem({
    required IconData icon,
    required String text,
    required bool isSelected,
    required Function() onTap,
    required Size size,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : AppColors.secondaryFontColor,
          ),
          globalSharedPreference.getBool("isArabic") == false
              ? SizedBox(
                  height: size.width * 0.02,
                )
              : SizedBox(
                  height: size.width * 0.001,
                ),
          Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.secondaryFontColor,
            ),
          )
        ],
      ),
    );
  }
}
