import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/logic/cubites/post/filter_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/store_cubit.dart';
import 'package:shopesapp/presentation/pages/suggested_stores.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/shared/fonts.dart';
import 'package:shopesapp/presentation/shared/utils.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../constant/categories.dart';
import '../../data/enums/filter_type.dart';
import '../../data/enums/message_type.dart';
import '../../main.dart';
import '../shared/custom_widgets/custom_toast.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  // CategoriesScroller categoriesScroller = const CategoriesScroller();
  List<Widget> itemList = [];

  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  List<String> currentCategories = categories;
  set setCurrentCategories(List<String> categories) {
    currentCategories = categories;
  }

  void getCategoriesData() {
    List<Widget> listItems = [];

    for (var element in currentCategories) {
      listItems.add(Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            color: AppColors.mainWhiteColor,
            boxShadow: [
              BoxShadow(
                  color: AppColors.mainBlackColor.withAlpha(100),
                  /*  color: globalSharedPreference.getBool("isDarkMode") == false
                      ? AppColors.mainBlackColor.withAlpha(100)
                      : AppColors.mainBlackColor.withAlpha(75),*/
                  blurRadius: 10)
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomText(
                  text: element,
                  fontSize: 25,
                  textColor: AppColors.mainBlackColor,
                  bold: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocProvider(
                          create: (context) => FilterCubit(),
                          child: BlocConsumer<FilterCubit, FilterState>(
                            listener: (context, state) {
                              if (state is FilterFailed) {
                                // context.pop();
                                CustomToast.showMessage(
                                    size: const Size(300, 100),
                                    message: state.message,
                                    messageType: MessageType.REJECTED,
                                    context: context);
                                BotToast.closeAllLoading();
                              } else if (state is FilteredSuccessfully) {
                                CustomToast.showMessage(
                                    size: const Size(300, 100),
                                    message: LocaleKeys
                                        .filter_applay_successfully
                                        .tr(),
                                    messageType: MessageType.SUCCESS,
                                    context: context);
                                context.pop();

                                context.push(const SuggestedStoresView());
                                BotToast.closeAllLoading();
                              }
                            },
                            builder: (context, state) {
                              if (state is FilterProgress) {
                                customLoader(
                                  const Size(400, 400),
                                );
                              }
                              return InkWell(
                                  onTap: () {
                                    context
                                        .read<StoreCubit>()
                                        .categoryFilterStores(
                                          category: element,
                                          id: globalSharedPreference
                                                  .getString("ID") ??
                                              '0',
                                        );
                                    context.push(SuggestedStoresView(
                                      filter: FilterType.CATEGORY,
                                      category: element,
                                    ));
                                  },
                                  child: CustomText(
                                    text: LocaleKeys.done.tr(),
                                    textColor: Theme.of(context).hintColor,
                                    // bold: true,
                                  ));
                            },
                          )
                          //harp),
                          ),
                      30.px,
                      BlocProvider(
                        create: (context) => FilterCubit(),
                        child: BlocConsumer<FilterCubit, FilterState>(
                          listener: (context, state) {
                            if (state is CategoriesFilteredSuccessfully) {
                              currentCategories = state.subCategories;
                              setCurrentCategories = currentCategories;
                              CustomToast.showMessage(
                                  size: const Size(400, 100),
                                  message: LocaleKeys.filter_applay_successfully
                                      .tr(),
                                  context: context);
                            }
                            if (state is NoSubCategories) {
                              CustomToast.showMessage(
                                  size: const Size(300, 100),
                                  message: LocaleKeys.no_sub_categories.tr(),
                                  context: context);
                            }
                            if (state is FilterFailed) {
                              CustomToast.showMessage(
                                size: const Size(300, 100),
                                message:
                                    LocaleKeys.failed_fetch_the_categories.tr(),
                                messageType: MessageType.REJECTED,
                                context: context,
                              );
                            }
                          },
                          builder: (context, state) {
                            return BlocBuilder<FilterCubit, FilterState>(
                              builder: (context, state) {
                                if (state is FilterProgress) {
                                  return const Center(
                                      child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator()));
                                }

                                return InkWell(
                                  onTap: () {
                                    context
                                        .read<FilterCubit>()
                                        .filterPostsWithCategory(
                                            onlyShowSubcategories: true,
                                            category: element);
                                  },
                                  child: CustomText(
                                    text: LocaleKeys.sub_categories.tr(),
                                    textColor: Theme.of(context).hintColor,
                                    // bold: true,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 15.0, bottom: 25),
              child: Icon(
                categoryIcon(element),
                color: AppColors.mainBlackColor,
              ),
            ),
            // Image.asset(
            //   'assets/verified.png',
            //   height: double.infinity,
            //   width: 100,
            // ),
          ]),
        ),
      ));
    }
    setState(() {
      itemList = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getCategoriesData();
    controller.addListener(() {
      double value = controller.offset / 119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    Widget categoriesScroller() {
      return ListView.builder(
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            child: FittedBox(
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
              child: Row(
                children: [
                  BlocBuilder<FilterCubit, FilterState>(
                    builder: (context, state) {
                      return InkWell(
                        onTap: () {
                          context.read<FilterCubit>().filterPostsWithCategory(
                              onlyShowSubcategories: true,
                              category: currentCategories[index]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Theme.of(context).colorScheme.primary),
                          width: w * 0.4,
                          // margin: const EdgeInsets.only(right: 20),
                          height: h * 0.25,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.,
                                children: [
                                  CustomText(
                                    text: categories[index],
                                    fontSize: AppFonts.primaryFontSize,
                                    textColor: AppColors.mainWhiteColor,
                                  ),
                                  10.ph,
                                  CustomText(
                                    text: '',
                                    fontSize: AppFonts.secondaryFontSize,
                                    textColor: AppColors.mainWhiteColor,
                                  )
                                ]),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        //  backgroundColor: AppColors.mainWhiteColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: BlocProvider(
          create: (context) => FilterCubit(),
          child: BlocConsumer<FilterCubit, FilterState>(
            listener: (context, state) {
              if (state is CategoriesFilteredSuccessfully) {
                currentCategories = state.subCategories;
                setCurrentCategories = currentCategories;
                getCategoriesData();

                CustomToast.showMessage(
                    size: const Size(300, 100),
                    message: LocaleKeys.fetched.tr(),
                    context: context);
              }
              if (state is NoSubCategories) {
                CustomToast.showMessage(
                    size: const Size(300, 100),
                    message: LocaleKeys.no_sub_categories.tr(),
                    context: context);
              }
              if (state is FilterFailed) {
                CustomToast.showMessage(
                  size: const Size(300, 100),
                  message: LocaleKeys.failed_fetch_the_categories.tr(),
                  messageType: MessageType.REJECTED,
                  context: context,
                );
                getCategoriesData();
              }
            },
            builder: (context, state) {
              return SizedBox(
                height: h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: w * 0.15),
                      child: CustomText(
                        text: LocaleKeys.main_Categories.tr(),
                        textColor: Theme.of(context).hintColor,
                        bold: true,
                        fontSize: w * 0.05,
                      ),
                    ),
                    30.ph,
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: closeTopContainer ? 0 : 1,
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: w,
                          alignment: Alignment.topCenter,
                          height: closeTopContainer ? 0 : h * 0.2,
                          child: categoriesScroller()),
                    ),
                    30.ph,
                    BlocBuilder<FilterCubit, FilterState>(
                      builder: (context, state) {
                        if (state is FilterProgress) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is FilterFailed) {
                          return Center(
                            child: CustomText(
                                text: LocaleKeys
                                    .failed_to_fetch_subcategories_please_try_again
                                    .tr()),
                          );
                        } else if (state is NoSubCategories) {
                          Center(
                            child: Text(LocaleKeys.no_sub_categories.tr()),
                          );
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: itemList.length,
                            controller: controller,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              double scale = 1.0;
                              if (topContainer > 0.5) {
                                scale = index + 0.5 - topContainer;
                                if (scale < 0) {
                                  scale = 0;
                                } else if (scale > 1) {
                                  scale = 1;
                                }
                              }
                              return Opacity(
                                opacity: scale,
                                child: Transform(
                                  alignment: Alignment.topCenter,
                                  transform: Matrix4.identity()
                                    ..scale(scale, scale),
                                  child: Align(
                                      heightFactor: 0.7,
                                      alignment: Alignment.topCenter,
                                      child: itemList[index]),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
