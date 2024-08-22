// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:shopesapp/data/data%20base/shared_preferences_repository.dart';
import 'package:shopesapp/logic/cubites/post/posts_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/show_favorite_stores_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/toggole_favorite_shop_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/favorite_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/following_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/get_owner_shops_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/rate_shop_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/work_time_cubit.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/presentation/pages/map_page.dart';
import 'package:shopesapp/presentation/pages/store_page.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_icon_text.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custoum_rate.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../global/functions/switch_to_arabic.dart';
import '../../../data/models/shop.dart';
import '../../../logic/cubites/shop/toggole_follow_shop_cubit.dart';
import '../../../logic/cubites/shop/shop_follwers_counter_cubit.dart';
import '../../../logic/cubites/shop/store_cubit.dart';
import '../dialogs/browsing_alert_dialog.dart';

class SuggestedStore extends StatefulWidget {
  SuggestedStore({Key? key, required this.shop}) : super(key: key);
  Shop shop;
  @override
  State<SuggestedStore> createState() => _SuggestedStoreState();
}

class _SuggestedStoreState extends State<SuggestedStore> {
  late FavoriteCubit read;
  late FollowingCubit followingCubit;

  @override
  void initState() {
    read = context.read<FavoriteCubit>();
    followingCubit = context.read<FollowingCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
      child: Row(
        children: [
          CircleAvatar(
            radius: w * 0.12,
            backgroundColor: AppColors.mainBlueColor,
            backgroundImage: widget.shop.shopProfileImage == 'url'
                ? const AssetImage(
                    'assets/profile_photo.jpg',
                  )
                : NetworkImage(widget.shop.shopProfileImage!) as ImageProvider,
          ),
          20.px,
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: w / 3,
                    child: CustomText(
                      text: widget.shop.shopName,
                      fontSize: w * 0.040,
                      bold: true,
                    ),
                  ),
                  60.px,
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (context) {
                            return Wrap(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(w * 0.1),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            context.pop();
                                            context
                                                .read<PostsCubit>()
                                                .getOwnerPosts(
                                                  ownerID:
                                                      globalSharedPreference
                                                          .getString("ID"),
                                                  shopID: widget.shop.shopID,
                                                );
                                            context
                                                .read<WorkTimeCubit>()
                                                .testOpenTime(
                                                    openTime: widget
                                                        .shop.startWorkTime,
                                                    closeTime: widget
                                                        .shop.endWorkTime);
                                            context
                                                .read<GetOwnerShopsCubit>()
                                                .getOwnerShopsRequest(
                                                    ownerID:
                                                        widget.shop.ownerID,
                                                    message: 'all');
                                            context.push(StorePage(
                                              shop: widget.shop,
                                            ));
                                          },
                                          child: CustomIconTextRow(
                                              fontSize: w * 0.04,
                                              iconColor: Theme.of(context)
                                                  .primaryColorDark,
                                              icon: Icons.storefront,
                                              textColor: Theme.of(context)
                                                  .primaryColorDark,
                                              text:
                                                  LocaleKeys.view_Profile.tr()),
                                        ),
                                        BlocBuilder<FavoriteCubit,
                                            FavoriteState>(
                                          builder: (context, state) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 30.0),
                                              child: InkWell(
                                                onTap: () {
                                                  if (!SharedPreferencesRepository
                                                      .getBrowsingPostsMode()) {
                                                    !read.isShopFavorite(
                                                            widget.shop)
                                                        ? read.addToFavorites(
                                                            widget.shop)
                                                        : read
                                                            .removeFromFavorites(
                                                                widget.shop);
                                                    BlocProvider.of<
                                                                ToggoleFavoriteShopCubit>(
                                                            context)
                                                        .toggoleFavoriteShop(
                                                            shopID: widget
                                                                .shop.shopID,
                                                            ownerID: globalSharedPreference
                                                                    .getString(
                                                                        "ID") ??
                                                                '0')
                                                        .then((value) => context
                                                            .read<StoreCubit>()
                                                            .getAllStores());
                                                    context
                                                        .read<
                                                            ShowFavoriteStoresCubit>()
                                                        .showMyFavoriteStores(
                                                            ownerID: globalSharedPreference
                                                                    .getString(
                                                                        "ID") ??
                                                                '0');
                                                  } else {
                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 1),
                                                        () =>
                                                            showBrowsingDialogAlert(
                                                                context));
                                                  }
                                                },
                                                child: CustomIconTextRow(
                                                    fontSize: w * 0.04,
                                                    iconColor: Theme.of(context)
                                                        .primaryColorDark,
                                                    textColor: Theme.of(context)
                                                        .primaryColorDark,
                                                    icon: Icons.star,
                                                    text: !widget
                                                            .shop.isFavorit!
                                                        ? LocaleKeys
                                                            .add_to_Favorites
                                                            .tr()
                                                        : LocaleKeys
                                                            .remove_from_fav
                                                            .tr()),
                                              ),
                                            );
                                          },
                                        ),
                                        BlocBuilder<FollowingCubit,
                                            FollowingState>(
                                          builder: (context, state) {
                                            return InkWell(
                                              onTap: () {
                                                if (!SharedPreferencesRepository
                                                    .getBrowsingPostsMode()) {
                                                  !widget.shop.isFollow!
                                                      ? {
                                                          context
                                                              .read<
                                                                  ShopFollwersCounterCubit>()
                                                              .incrementFollowers(
                                                                  widget.shop),
                                                          followingCubit.follow(
                                                              widget.shop),
                                                        }
                                                      : {
                                                          context
                                                              .read<
                                                                  ShopFollwersCounterCubit>()
                                                              .decrementFollowers(
                                                                  widget.shop),
                                                          followingCubit
                                                              .unFollow(
                                                                  widget.shop),
                                                        };
                                                  BlocProvider.of<
                                                              ToggoleFollowShopCubit>(
                                                          context)
                                                      .toggoleFolowShop(
                                                          shopID: widget
                                                              .shop.shopID,
                                                          ownerID:
                                                              globalSharedPreference
                                                                      .getString(
                                                                          "ID") ??
                                                                  '0')
                                                      .then((value) => context
                                                          .read<StoreCubit>()
                                                          .getAllStores());
                                                  context.pop();
                                                } else {
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 1),
                                                      () =>
                                                          showBrowsingDialogAlert(
                                                              context));
                                                }
                                              },
                                              child: CustomIconTextRow(
                                                  fontSize: w * 0.04,
                                                  iconColor: Theme.of(context)
                                                      .primaryColorDark,
                                                  textColor: Theme.of(context)
                                                      .primaryColorDark,
                                                  icon: Icons
                                                      .person_add_alt_1_rounded,
                                                  text: widget.shop.isFollow!
                                                      ? '${LocaleKeys.un_follow.tr()} ${widget.shop.shopName}'
                                                      : '${LocaleKeys.follow.tr()} ${widget.shop.shopName}'),
                                            );
                                          },
                                        )
                                      ]),
                                ),
                              ],
                            );
                          });
                    },
                  )
                ],
              ),
              5.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<RateShopCubit, RateShopState>(
                    builder: (context, state) {
                      return CustomRate(
                        store: widget.shop,
                        enableRate: false,
                        rateValue: widget.shop.rate,
                      );
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        LocationData storeLocation = LocationData.fromMap({
                          'latitude': widget.shop.latitude,
                          'longitude': widget.shop.longitude
                        });
                        context.push(MapPage(currentLocation: storeLocation));
                      },
                      icon: Icon(Icons.location_on, size: w * 0.04)),
                  SizedBox(
                    width: w / 8,
                    child: CustomText(
                      text: globalSharedPreference.getBool("isArabic") == false
                          ? widget.shop.location
                          : switchLocationToArabic(widget.shop.location),
                      fontSize: w * 0.031,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  )),
                                  insetPadding: EdgeInsets.symmetric(
                                      vertical: h * 0.3, horizontal: h * 0.01),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(w * 0.06),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CustomText(
                                                  text: LocaleKeys
                                                      .store_category
                                                      .tr(),
                                                  bold: true,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      context.pop();
                                                    },
                                                    icon:
                                                        const Icon(Icons.close))
                                              ],
                                            ),
                                            const Divider(),
                                            10.ph,
                                            CustomText(
                                              text: globalSharedPreference
                                                          .getBool(
                                                              "isArabic") ==
                                                      false
                                                  ? widget.shop.shopCategory
                                                  : switchCategoryToArabic(
                                                      widget.shop.shopCategory),
                                              textColor:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                      },
                      icon: Icon(Icons.comment, size: w * 0.04)),
                  CustomText(
                    text: LocaleKeys.category.tr(),
                    fontSize: w * 0.031,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
