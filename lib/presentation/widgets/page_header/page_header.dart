// ignore_for_file: use_build_context_synchronously

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:shopesapp/constant/cities.dart';
import 'package:shopesapp/data/enums/message_type.dart';
import 'package:shopesapp/logic/cubites/post/filter_cubit.dart';
import 'package:shopesapp/presentation/widgets/location/location_service.dart';
import 'package:shopesapp/presentation/pages/categories_page.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_divider.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_sort_row.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_toast.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/user_input.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/shared/utils.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../constant/categories.dart';
import '../../../main.dart';
import '../../pages/map_page.dart';

class PageHeader extends StatefulWidget {
  const PageHeader({Key? key}) : super(key: key);

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  String? selectedSortIcon;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    final h = MediaQuery.of(context).size.height;
    void setIcon(String icon) {
      selectedSortIcon = icon;
    }

    Widget sortDialog() {
      return Dialog(
        alignment: Alignment.topLeft,
        insetPadding: EdgeInsets.only(top: h * 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            30.ph,
            BlocProvider(
                create: (context) => FilterCubit(),
                child: BlocConsumer<FilterCubit, FilterState>(
                  listener: (context, state) {
                    if (state is FilterFailed) {
                      setState(() {
                        setIcon('assets/location-1-svgrepo-com.svg');
                      });
                      context.pop();
                      CustomToast.showMessage(
                          size: size,
                          message: state.message,
                          messageType: MessageType.REJECTED,
                          context: context);
                      BotToast.closeAllLoading();
                    } else if (state is FilteredSuccessfully) {
                      setState(() {
                        setIcon('assets/location-1-svgrepo-com.svg');
                      });
                      CustomToast.showMessage(
                          size: size,
                          message: LocaleKeys.filter_applay_successfully.tr(),
                          messageType: MessageType.SUCCESS,
                          context: context);
                      context.pop();

                      BotToast.closeAllLoading();
                    }
                  },
                  builder: (context, state) {
                    if (state is FilterProgress) {
                      customLoader(size);
                    }
                    return InkWell(
                      onTap: () {
                        context.read<FilterCubit>().filterPostsWithLocation(
                            location:
                                globalSharedPreference.getString('location') ??
                                    '');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_sharp,
                            ),
                            20.px,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: LocaleKeys.location.tr(),
                                  bold: true,
                                ),
                                8.ph,
                                CustomText(
                                    text: LocaleKeys
                                        .nearest_posts_will_be_seen_first
                                        .tr()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
            BlocProvider(
                create: (context) => FilterCubit(),
                child: BlocConsumer<FilterCubit, FilterState>(
                  listener: (context, state) {
                    if (state is FilterFailed) {
                      context.pop();
                      CustomToast.showMessage(
                          size: size,
                          message: state.message,
                          messageType: MessageType.REJECTED,
                          context: context);
                      BotToast.closeAllLoading();
                    } else if (state is NoPostYet) {
                      context.pop();
                      CustomToast.showMessage(
                          size: size,
                          message: LocaleKeys.no_posts_yet_follow_alert.tr(),
                          messageType: MessageType.REJECTED,
                          context: context);
                      BotToast.closeAllLoading();
                    } else if (state is FilteredSuccessfully) {
                      CustomToast.showMessage(
                          size: size,
                          message: LocaleKeys.filter_applay_successfully.tr(),
                          messageType: MessageType.SUCCESS,
                          context: context);
                      context.pop();

                      BotToast.closeAllLoading();
                    }
                  },
                  builder: (context, state) {
                    if (state is FilterProgress) {
                      customLoader(size);
                    }
                    return InkWell(
                      onTap: () {
                        context.read<FilterCubit>().getOldestPosts();
                      },
                      child: CustomSortRow(
                        title: LocaleKeys.oldest.tr(),
                        subtitle:
                            LocaleKeys.oldest_posts_will_be_seen_first.tr(),
                      ),
                    );
                  },
                )),
            BlocProvider(
                create: (context) => FilterCubit(),
                child: BlocConsumer<FilterCubit, FilterState>(
                  listener: (context, state) {
                    if (state is FilterFailed) {
                      context.pop();
                      CustomToast.showMessage(
                          size: size,
                          message: state.message,
                          messageType: MessageType.REJECTED,
                          context: context);
                      BotToast.closeAllLoading();
                    } else if (state is NoPostYet) {
                      context.pop();
                      CustomToast.showMessage(
                          size: size,
                          message: LocaleKeys.no_posts_yet_follow_alert.tr(),
                          messageType: MessageType.REJECTED,
                          context: context);
                      BotToast.closeAllLoading();
                    } else if (state is FilteredSuccessfully) {
                      CustomToast.showMessage(
                          size: size,
                          message: LocaleKeys.filter_applay_successfully.tr(),
                          messageType: MessageType.SUCCESS,
                          context: context);
                      context.pop();

                      BotToast.closeAllLoading();
                    }
                  },
                  builder: (context, state) {
                    if (state is FilterProgress) {
                      customLoader(size);
                    }
                    return InkWell(
                      onTap: () {
                        context.read<FilterCubit>().getAllPosts();
                      },
                      child: CustomSortRow(
                        title: LocaleKeys.newest.tr(),
                        subtitle:
                            LocaleKeys.nearest_posts_will_be_seen_first.tr(),
                      ),
                    );
                  },
                )),
            30.ph
          ],
        ),
      );
    }

    Widget filterDialog() {
      return Dialog(
        alignment: Alignment.topLeft,
        insetPadding: EdgeInsets.only(top: h * 0.08),
        child: SizedBox(
          width: w,
          height: h,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView(
              children: [
                30.ph,
                InkWell(
                    onTap: () {
                      context.push(const CategoriesPage());
                    },
                    child: CustomText(
                      textAlign: TextAlign.center,
                      text: LocaleKeys
                          .click_here_to_Identify_your_request_more_specifically
                          .tr(),
                      textColor: AppColors.secondaryFontColor,
                    )),
                10.ph,
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: globalSharedPreference.getBool("isArabic") == false
                      ? categoriesEnglish.length
                      : categoriesArabic.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return BlocProvider(
                        create: (context) => FilterCubit(),
                        child: BlocConsumer<FilterCubit, FilterState>(
                          listener: (context, state) {
                            if (state is FilterFailed) {
                              context.pop();
                              CustomToast.showMessage(
                                  size: size,
                                  message: state.message,
                                  messageType: MessageType.REJECTED,
                                  context: context);
                              BotToast.closeAllLoading();
                            } else if (state is FilteredSuccessfully) {
                              CustomToast.showMessage(
                                  size: size,
                                  message: LocaleKeys.filter_applay_successfully
                                      .tr(),
                                  messageType: MessageType.SUCCESS,
                                  context: context);
                              context.pop();

                              BotToast.closeAllLoading();
                            }
                          },
                          builder: (context, state) {
                            if (state is FilterProgress) {
                              customLoader(size);
                            }
                            return InkWell(
                                onTap: () {
                                  context
                                      .read<FilterCubit>()
                                      .filterPostsWithCategory(
                                          category: globalSharedPreference
                                                      .getBool("isArabic") ==
                                                  false
                                              ? categoriesEnglish[index]
                                              : categoriesArabic[index]);
                                },
                                child: CustomSortRow(
                                  title: globalSharedPreference
                                              .getBool("isArabic") ==
                                          false
                                      ? categoriesEnglish[index]
                                      : categoriesArabic[index],
                                  cIcon: Icon(
                                    categoryIcon(globalSharedPreference
                                                .getBool("isArabic") ==
                                            false
                                        ? categoriesEnglish[index]
                                        : categoriesArabic[index]),
                                    size: 20,
                                  ),
                                ));
                          },
                        ));
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return const CustomDivider();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget cityDialog() {
      return Dialog(
        alignment: Alignment.topRight,
        insetPadding: EdgeInsets.only(top: h * 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          width: w / 2,
          height: h / 1.5,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              top: w * 0.03,
            ),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(start: w * 0.05),
                  child: CustomText(
                    text: LocaleKeys.choose_a_city.tr(),
                    bold: true,
                    textColor: AppColors.secondaryFontColor,
                  ),
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: globalSharedPreference.getBool("isArabic") == false
                      ? citisEnglish.length
                      : citiesArabic.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return BlocProvider(
                        create: (context) => FilterCubit(),
                        child: BlocConsumer<FilterCubit, FilterState>(
                          listener: (context, state) {
                            if (state is FilterFailed) {
                              context.pop();
                              CustomToast.showMessage(
                                  size: size,
                                  message: state.message,
                                  messageType: MessageType.REJECTED,
                                  context: context);
                              BotToast.closeAllLoading();
                            } else if (state is FilteredSuccessfully) {
                              CustomToast.showMessage(
                                  size: size,
                                  message: LocaleKeys.filter_applay_successfully
                                      .tr(),
                                  messageType: MessageType.SUCCESS,
                                  context: context);
                              context.pop();
                              BotToast.closeAllLoading();
                            }
                          },
                          builder: (context, state) {
                            if (state is FilterProgress) {
                              customLoader(size);
                            }
                            return InkWell(
                              onTap: () {
                                context
                                    .read<FilterCubit>()
                                    .filterPostsWithLocation(
                                        location: globalSharedPreference
                                                    .getBool("isArabic") ==
                                                false
                                            ? citisEnglish[index]
                                            : citiesArabic[index]);
                              },
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.only(start: w * 0.06),
                                child: CustomText(
                                    text: globalSharedPreference
                                                .getBool("isArabic") ==
                                            false
                                        ? citisEnglish[index]
                                        : citiesArabic[index]),
                              ),
                            );
                          },
                        ));
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return const CustomDivider();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    TextEditingController searchController = TextEditingController();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: w * 0.05),
            child: Row(
              children: [
                InkWell(
                    onTap: () => showDialog(
                          context: context,
                          builder: (context) => filterDialog(),
                        ),
                    child: SvgPicture.asset(
                      'assets/filter-edit-svgrepo-com.svg',
                      width: w * 0.07,
                      height: w * 0.07,
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: w * 0.64),
                  child: InkWell(
                      onTap: () => showDialog(
                            context: context,
                            builder: (context) => sortDialog(),
                          ),
                      child: SvgPicture.asset(
                        selectedSortIcon ?? 'assets/sort-svgrepo-com.svg',
                        width: w * 0.07,
                        height: w * 0.07,
                      )),
                ),
                InkWell(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => cityDialog(),
                  ),
                  child: SvgPicture.asset(
                    'assets/city-buildings-svgrepo-com.svg',
                    width: w * 0.07,
                    height: w * 0.07,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: selectedSortIcon == 'assets/location-1-svgrepo-com.svg',
            child: InkWell(
                onTap: () async {
                  LocationData? currentLocation =
                      await LocationService().getUserCurrentLocation();
                  if (currentLocation != null) {
                    context.push(
                      MapPage(
                        currentLocation: currentLocation,
                      ),
                    );
                  }
                },
                child: Text(LocaleKeys.show_on_map.tr())),
          ),
          UserInput(
            text: LocaleKeys.search.tr(),
            prefixIcon: const Icon(Icons.search),
            controller: searchController,
          )
        ],
      ),
    );
  }
}
