// ignore_for_file: camel_case_types

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/global/functions/switch_to_arabic.dart';
import 'package:shopesapp/data/models/shop.dart';
import 'package:shopesapp/data/data%20base/shared_preferences_repository.dart';
import 'package:shopesapp/global/functions/translate_time.dart';
import 'package:shopesapp/logic/cubites/post/posts_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/toggole_follow_shop_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/following_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/get_owner_shops_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/get_shops_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/rate_shop_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/shop_follwers_counter_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/work_time_cubit.dart';
import 'package:shopesapp/presentation/pages/add_post_page.dart';
import 'package:shopesapp/presentation/pages/edit_store.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_divider.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_icon_text.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custoum_rate.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shopesapp/presentation/widgets/dialogs/awosem_dialog.dart';
import 'package:shopesapp/presentation/widgets/product/product_post.dart';
import 'package:shopesapp/presentation/widgets/switch_shop/error.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../main.dart';
import '../widgets/dialogs/browsing_alert_dialog.dart';
import '../widgets/home/no_posts_yet.dart';

// ignore: must_be_immutable
class StorePage extends StatefulWidget {
  StorePage({
    Key? key,
    this.shop,
    this.profileDisplay = false,
  }) : super(key: key);
  dynamic shop;
  bool? profileDisplay;
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    context.read<PostsCubit>().getOwnerPosts(
        ownerID: globalSharedPreference.getString('ID'),
        shopID: widget.shop!.shopID);
    context.read<GetShopsCubit>().getShop(widget.shop!.shopID);
    super.initState();
  }

  void updateStoreState() {
    setState(() {
      context.read<WorkTimeCubit>().testOpenTime(
          openTime: globalSharedPreference.getString("startWorkTime"),
          closeTime: globalSharedPreference.getString("endWorkTime"));
      context.read<GetOwnerShopsCubit>().getOwnerShopsRequest(
          ownerID: globalSharedPreference.getString('ID'), message: 'all');
      context.read<PostsCubit>().getOwnerPosts(
          ownerID: globalSharedPreference.getString('ID'),
          shopID: widget.shop!.shopID);
      widget.shop =
          context.read<GetShopsCubit>().getShop(widget.shop!.shopID) as Shop;
    });
  }

  List<dynamic> postsList = [];
  List<dynamic> ownerShpos = [];
  int? followesNumber;
  @override
  Widget build(BuildContext context) {
    List<String> splitStartTime = widget.shop!.startWorkTime.split(":");
    String startWorkTime = "${splitStartTime[0]}:${splitStartTime[1]}";
    List<String> splitEndWorkTime = widget.shop!.endWorkTime.split(":");
    String endtWorkTime = "${splitEndWorkTime[0]}:${splitEndWorkTime[1]}";
    String arabicStartWorkTime = translateTimetoArabic(startWorkTime);
    String arabicEndWorkTime = translateTimetoArabic(endtWorkTime);

    var size = MediaQuery.of(context).size;

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: w * 0.06, end: w * 0.01),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                children: [
                  SizedBox(
                    height: h / 5,
                    width: w,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(w * 0.05),
                        child: widget.shop!.shopCoverImage != 'url'
                            ? Image.network(widget.shop!.shopCoverImage!)
                            : const Image(
                                image: AssetImage('assets/cover_photo.jpg'))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: h * 0.15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.mainWhiteColor,
                              radius: w * 0.12,
                              child: CircleAvatar(
                                radius: w * 0.11,
                                backgroundColor: AppColors.mainTextColor,
                                backgroundImage:
                                    widget.shop!.shopProfileImage == 'url'
                                        ? const AssetImage(
                                            'assets/profile_photo.jpg',
                                          )
                                        : NetworkImage(
                                                widget.shop!.shopProfileImage!)
                                            as ImageProvider,
                              ),
                            ),
                            BlocBuilder<WorkTimeCubit, WorkTimeState>(
                              builder: (context, state) {
                                return Visibility(
                                  visible: state.isOpen == true &&
                                      widget.shop?.isActive == true,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: w * 0.2, top: w * 0.16),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: w * 0.025,
                                          backgroundColor:
                                              AppColors.mainWhiteColor,
                                          child: CircleAvatar(
                                            radius: w * 0.02,
                                            backgroundColor: Colors.green,
                                          ),
                                        ),
                                        2.px,
                                        CustomText(
                                          text: LocaleKeys.open_now.tr(),
                                          textColor: Colors.green,
                                          fontSize: w * 0.03,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<WorkTimeCubit, WorkTimeState>(
                              builder: (context, state) {
                                return Visibility(
                                  visible: state.isOpen != true &&
                                      widget.shop?.isActive == true,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: w * 0.2, top: w * 0.16),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: w * 0.025,
                                          backgroundColor:
                                              AppColors.mainWhiteColor,
                                          child: CircleAvatar(
                                            radius: w * 0.02,
                                            backgroundColor: Colors.red,
                                          ),
                                        ),
                                        2.px,
                                        CustomText(
                                          text: LocaleKeys.close_now.tr(),
                                          textColor: Colors.red,
                                          fontSize: w * 0.03,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Visibility(
                              visible: widget.shop?.isActive == false,
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: w * 0.2, top: w * 0.16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: w * 0.025,
                                      backgroundColor: AppColors.mainWhiteColor,
                                      child: CircleAvatar(
                                        radius: w * 0.02,
                                        backgroundColor: Colors.blueGrey,
                                      ),
                                    ),
                                    2.px,
                                    CustomText(
                                      text: LocaleKeys.deactive_now.tr(),
                                      textColor: Colors.blueGrey,
                                      fontSize: w * 0.03,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: w * 0.01),
                          child: Row(
                            children: [
                              CustomText(
                                text: widget.shop!.shopName,
                                bold: true,
                                fontSize: w * 0.05,
                                textColor: Theme.of(context).primaryColorDark,
                              ),
                              10.px,
                              BlocBuilder<RateShopCubit, RateShopState>(
                                builder: (context, state) {
                                  if (state is RateShopSucceded) {
                                    return CustomRate(
                                      rateValue: state.rate,
                                      store: widget.shop!,
                                      enableRate: true,
                                    );
                                  }
                                  return CustomRate(
                                    rateValue: widget.shop!.rate,
                                    store: widget.shop!,
                                    enableRate: true,
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              10.ph,
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Visibility(
                    visible:
                        globalSharedPreference.getBool("isDarkMode") == false &&
                            globalSharedPreference.getBool("isArabic") == false,
                    child: CustomPaint(
                        painter: profilePainter(),
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: w / 2,
                          ),
                          child: SizedBox(
                            width: w / 4,
                            height: h * 0.34,
                          ),
                        )),
                  ),
                  globalSharedPreference.getBool("isArabic") == false
                      ? Visibility(
                          visible: widget.profileDisplay ?? false,
                          child: Positioned(
                              right: w * 0.06, bottom: w * 0, child: _getFAB()))
                      : Visibility(
                          visible: widget.profileDisplay ?? false,
                          child: Positioned(
                              left: w * 0.095,
                              bottom: w * 0,
                              child: _getFAB())),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      0.ph,
                      Row(
                        children: [
                          Icon(
                            Icons.tag,
                            color: Colors.grey.shade300,
                          ),
                          10.px,
                          CustomText(
                            text: globalSharedPreference.getBool("isArabic") ==
                                    false
                                ? widget.shop!.shopCategory
                                : switchCategoryToArabic(
                                    widget.shop!.shopCategory),
                            textColor: Theme.of(context).hintColor,
                          ),
                        ],
                      ),
                      15.ph,
                      Visibility(
                        visible: widget.shop!.shopDescription!.isNotEmpty,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: w * 0.08),
                          child: CustomText(
                              textColor: Theme.of(context).primaryColorDark,
                              fontSize: 15,
                              text: widget.shop!.shopDescription ??
                                  LocaleKeys.defult_description.tr()),
                        ),
                      ),
                      20.ph,
                      Row(
                        children: [
                          BlocBuilder<GetShopsCubit, GetShopsState>(
                            builder: (context, state) {
                              int? followesNumber;
                              if (state is GetShopsSucceed) {
                                followesNumber =
                                    BlocProvider.of<GetShopsCubit>(context)
                                        .shop!
                                        .followesNumber!;
                              }
                              return CustomText(
                                text:
                                    '${followesNumber ?? widget.shop!.followesNumber} ${LocaleKeys.followers.tr()}',
                                textColor: AppColors.mainBlueColor,
                              );
                            },
                          ),
                          70.px,
                          BlocBuilder<FollowingCubit, FollowingState>(
                            builder: (context, state) {
                              var followingCubit =
                                  context.read<FollowingCubit>();
                              var shop =
                                  SharedPreferencesRepository.getSavedShop(
                                          widget.shop!) ??
                                      widget.shop!;
                              return InkWell(
                                onTap: () {
                                  if (!SharedPreferencesRepository
                                      .getBrowsingPostsMode()) {
                                    !widget.shop!.isFollow!
                                        ? {
                                            context
                                                .read<
                                                    ShopFollwersCounterCubit>()
                                                .incrementFollowers(shop),
                                            followingCubit.follow(shop),
                                          }
                                        : {
                                            context
                                                .read<
                                                    ShopFollwersCounterCubit>()
                                                .decrementFollowers(shop),
                                            followingCubit.unFollow(shop),
                                          };
                                    BlocProvider.of<ToggoleFollowShopCubit>(
                                            context)
                                        .toggoleFolowShop(
                                            shopID: widget.shop!.shopID,
                                            ownerID: globalSharedPreference
                                                    .getString("ID") ??
                                                '0')
                                        .then(
                                          (value) => context
                                              .read<GetShopsCubit>()
                                              .getShop(widget.shop!.shopID),
                                        );
                                  } else {
                                    showBrowsingDialogAlert(context);
                                  }
                                },
                                child: Visibility(
                                  visible: !widget.profileDisplay!,
                                  child: CustomText(
                                    text: widget.shop!.isFollow!
                                        ? LocaleKeys.following.tr()
                                        : LocaleKeys.follow.tr(),
                                    textColor: AppColors.mainBlueColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const CustomDivider(),
                      Visibility(
                        visible: widget.shop!.isActive == true,
                        child: CustomIconTextRow(
                          textColor: Theme.of(context).primaryColorDark,
                          svgIcon: 'clock-square-svgrepo-com',
                          text: globalSharedPreference.getBool("isArabic") ==
                                  false
                              ? '$startWorkTime - $endtWorkTime'
                              : '$arabicStartWorkTime - $arabicEndWorkTime',
                        ),
                      ),
                      Visibility(
                        visible: widget.shop!.isActive == false,
                        child: CustomIconTextRow(
                            textColor: Theme.of(context).primaryColorDark,
                            svgIcon: 'clock-square-svgrepo-com',
                            text: "---  - ---"),
                      ),
                      20.ph,
                      Visibility(
                        visible: widget.shop!.shopPhoneNumber != null,
                        child: Column(
                          children: [
                            CustomIconTextRow(
                                textColor: Theme.of(context).primaryColorDark,
                                svgIcon: 'phone-svgrepo-com',
                                text: widget.shop!.isActive == true
                                    ? "${widget.shop!.shopPhoneNumber}"
                                    : "------------"),
                            20.ph,
                          ],
                        ),
                      ),
                      CustomIconTextRow(
                          textColor: Theme.of(context).primaryColorDark,
                          svgIcon: 'mail-svgrepo-com',
                          text: widget.shop!.ownerEmail),
                      20.ph,
                      CustomIconTextRow(
                        textColor: Theme.of(context).primaryColorDark,
                        svgIcon: 'map-point-wave-svgrepo-com',
                        text:
                            globalSharedPreference.getBool("isArabic") == false
                                ? widget.shop!.location
                                : switchLocationToArabic(widget.shop!.location),
                      ),
                      const CustomDivider(),
                      Visibility(
                        visible: widget.shop!.socialUrl!.isNotEmpty &&
                            (widget.shop!.socialUrl![0].length != 0 ||
                                widget.shop!.socialUrl![1].length != 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: LocaleKeys.social_Account.tr(),
                              textColor: Theme.of(context).primaryColorDark,
                              fontSize: w * 0.04,
                              bold: true,
                            ),
                            30.ph,
                            Visibility(
                              visible: widget.shop!.socialUrl!.isNotEmpty &&
                                  widget.shop!.socialUrl![0].length != 0,
                              child: CustomIconTextRow(
                                  textColor: Theme.of(context).primaryColorDark,
                                  svgIcon: 'instagram-2-1-logo-svgrepo-com',
                                  text: widget.shop!.socialUrl!.isNotEmpty
                                      ? widget.shop!.socialUrl![0]
                                      : ''),
                            ),
                            20.ph,
                            Visibility(
                              visible: widget.shop!.socialUrl!.isNotEmpty &&
                                  widget.shop!.socialUrl![1].length != 0,
                              child: CustomIconTextRow(
                                  textColor: Theme.of(context).primaryColorDark,
                                  svgIcon: 'facebook-3-logo-svgrepo-com',
                                  text: widget.shop!.socialUrl!.isNotEmpty
                                      ? widget.shop!.socialUrl![1]
                                      : ''),
                            ),
                            const CustomDivider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
          BlocConsumer<GetOwnerShopsCubit, GetOwnerShopsState>(
            listener: (context, state) {
              if (state is GetOwnerShopsFiled) {
                buildAwsomeDialog(context, LocaleKeys.faild.tr(),
                        state.message.toUpperCase(), LocaleKeys.ok.tr(),
                        type: DialogType.error)
                    .show();
              } else if (state is GetOwnerShopsSucceed) {}
            },
            builder: (context, state) {
              if (state is GetOwnerShopsProgress) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is GetOwnerShopsSucceed) {
                ownerShpos =
                    BlocProvider.of<GetOwnerShopsCubit>(context).ownerShops;
                return Visibility(
                  visible: ownerShpos.length > 1,
                  child: SizedBox(
                    height: h / 4,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(start: w * 0.04),
                      child: Column(
                        children: [
                          20.ph,
                          CustomText(
                            text: LocaleKeys.related_stores.tr(),
                            textColor: Theme.of(context).primaryColorDark,
                            fontSize: w * 0.04,
                            bold: true,
                          ),
                          20.ph,
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: ownerShpos.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return 20.px;
                              },
                              itemBuilder: (BuildContext context, int index) {
                                if (ownerShpos[index]['shopID'] !=
                                    widget.shop!.shopID) {
                                  return InkWell(
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                            radius: w * 0.1,
                                            backgroundColor:
                                                AppColors.mainTextColor,
                                            backgroundImage: ownerShpos[index]
                                                        ["shopProfileImage"] ==
                                                    'url'
                                                ? const AssetImage(
                                                    'assets/profile_photo.jpg',
                                                  ) as ImageProvider
                                                : NetworkImage(ownerShpos[index]
                                                    ["shopProfileImage"]),
                                            child: ownerShpos[index]
                                                        ["shopProfileImage"] ==
                                                    'url'
                                                ? ClipOval(
                                                    child: Image.asset(
                                                      'assets/store_placeholder.png',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )
                                                : null),
                                        5.ph,
                                        CustomText(
                                          text: ownerShpos[index]['shopName'],
                                          textColor: Theme.of(context)
                                              .primaryColorDark,
                                        )
                                      ],
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return buildError(size);
            },
          ),
          Visibility(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: h * 0.001),
                child: const Divider(
                  thickness: 7,
                )),
          ),
          Visibility(
            visible: !SharedPreferencesRepository.getBrowsingPostsMode(),
            child: BlocConsumer<PostsCubit, PostsState>(
              listener: (context, state) {
                if (state is ErrorFetchingPosts) {
                  buildAwsomeDialog(context, LocaleKeys.faild.tr(),
                          state.message.toUpperCase(), LocaleKeys.ok.tr(),
                          type: DialogType.error)
                      .show();
                } else if (state is PostsFetchedSuccessfully) {}
              },
              builder: (context, state) {
                if (state is FeatchingPostsProgress) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NoPostsYet) {
                  return Center(
                      child: buildNoPostsYet(
                          size, LocaleKeys.no_posts_yet_follow_alert.tr()));
                } else if (state is PostsFetchedSuccessfully) {
                  postsList = BlocProvider.of<PostsCubit>(context).ownerPosts;
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: postsList.length,
                    separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: h * 0.01),
                        child: const Divider(
                          thickness: 7,
                        )),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductPost(
                        post: postsList[index],
                        profileDisplay: widget.profileDisplay ?? false,
                      );
                    },
                  );
                }
                return buildError(size);
              },
            ),
          ),
          50.ph,
        ],
      ),
    ));
  }

  Widget _getFAB() {
    return SpeedDial(
      direction: globalSharedPreference.getBool("isArabic") == true
          ? SpeedDialDirection.right
          : SpeedDialDirection.up,
      animatedIcon: AnimatedIcons.list_view,
      animatedIconTheme:
          IconThemeData(size: 22, color: AppColors.mainWhiteColor),
      backgroundColor: Theme.of(context).colorScheme.primary,
      visible: true,
      curve: Curves.easeIn,
      childMargin: const EdgeInsets.only(bottom: 30, left: 10),
      spacing: 10,
      spaceBetweenChildren: 5,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.add),
          onTap: () {
            context.push(const AddPostPage());
          },
          label: LocaleKeys.add_Post.tr(),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.mainWhiteColor,
            fontSize: 16,
          ),
          labelBackgroundColor: Theme.of(context).colorScheme.primary,
        ),
        SpeedDialChild(
          child: const Icon(Icons.edit),
          onTap: () {
            context.push(EditStore(function: updateStoreState));
          },
          label: LocaleKeys.edit_stroe_informations.tr(),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.mainWhiteColor,
            fontSize: 16,
          ),
          labelBackgroundColor: Theme.of(context).colorScheme.primary,
        )
      ],
    );
  }
}

class profilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blueGrey.shade200,
          AppColors.mainWhiteColor,
        ],
      ).createShader(rect);
    Path path0 = Path();
    path0.moveTo(size.width * 0.6200000, 0);
    path0.quadraticBezierTo(size.width * 0.9050000, 0, size.width, 0);
    path0.lineTo(size.width, size.height);
    path0.quadraticBezierTo(size.width * 0.7168750, size.height,
        size.width * 0.6225000, size.height);
    path0.cubicTo(
        size.width * 0.6593750,
        size.height * 0.8975000,
        size.width * 0.7000000,
        size.height * 0.6305000,
        size.width * 0.7000000,
        size.height * 0.4980000);
    path0.cubicTo(
        size.width * 0.6968750,
        size.height * 0.3665000,
        size.width * 0.6375000,
        size.height * 0.0155000,
        size.width * 0.6200000,
        0);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
