import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopesapp/global/functions/switch_to_arabic.dart';
import 'package:shopesapp/data/models/post.dart';
import 'package:shopesapp/logic/cubites/post/post_favorite_cubit.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_divider.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/shared/utils.dart';

import '../../../data/data base/shared_preferences_repository.dart';
import '../../../logic/cubites/post/toggle_post_favorite_cubit.dart';
import '../dialogs/browsing_alert_dialog.dart';

class ProductInfo extends StatefulWidget {
  const ProductInfo({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(color: Theme.of(context).primaryColorDark),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Row(
            children: [
              20.px,
              CircleAvatar(
                radius: w * 0.07,
                backgroundColor: AppColors.mainTextColor,
                backgroundImage: widget.post.shopProfileImage == 'url'
                    ? const AssetImage(
                        'assets/profile_photo.jpg',
                      )
                    : NetworkImage(widget.post.shopProfileImage!)
                        as ImageProvider,
              ),
              10.px,
              CustomText(text: widget.post.shopName!),
            ],
          ),
          20.ph,
          SizedBox(
            height: h / 5,
            child: Image.network(widget.post.photos),
          ),
          20.ph,
          Row(
            children: [
              30.px,
              BlocBuilder<PostFavoriteCubit, PostFavoriteState>(
                builder: (context, state) {
                  PostFavoriteCubit postFavorite =
                      context.read<PostFavoriteCubit>();
                  return IconButton(
                      onPressed: () {
                        if (!SharedPreferencesRepository
                            .getBrowsingPostsMode()) {
                          postFavorite.isPostFavorite(widget.post)
                              ? postFavorite.removeFromFavorites(widget.post)
                              : postFavorite.addToFavorites(widget.post);

                          context
                              .read<TogglePostFavoriteCubit>()
                              .toggolePostFavorite(
                                  postID: widget.post.postID,
                                  userID:
                                      globalSharedPreference.getString("ID") ??
                                          '0');
                        } else {
                          showBrowsingDialogAlert(context);
                        }
                      },
                      icon: !widget.post.isFavorit!
                          ? const Icon(Icons.favorite_border_outlined)
                          : Icon(
                              Icons.favorite,
                              color: AppColors.mainRedColor,
                            ));
                },
              ),
            ],
          ),
          const CustomDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.09),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 42.0),
                  child: CustomText(
                    text: widget.post.title,
                    fontSize: w * 0.04,
                  ),
                ),
                20.ph,
                Row(
                  children: [
                    Icon(
                      Icons.tag,
                      color: AppColors.secondaryFontColor,
                    ),
                    20.px,
                    CustomText(
                      text: globalSharedPreference.getBool("isArabic") == false
                          ? widget.post.shopCategory!
                          : switchCategoryToArabic(widget.post.shopCategory!),
                      textColor: Theme.of(context).hintColor,
                    )
                  ],
                ),
                20.ph,
                Row(
                  children: [
                    const Icon(
                      Icons.price_change,
                      color: Colors.green,
                    ),
                    20.px,
                    CustomText(
                      text: widget.post.price,
                      textColor: Theme.of(context).hintColor,
                    )
                  ],
                ),
                20.ph,
                Visibility(
                  visible: widget.post.description!.isNotEmpty,
                  child: Row(
                    children: [
                      Icon(
                        Icons.short_text_rounded,
                        color: Theme.of(context).hintColor,
                      ),
                      20.px,
                      Expanded(
                        child: CustomText(
                          text: widget.post.description!,
                          textColor: Theme.of(context).hintColor,
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                    visible: widget.post.description!.isNotEmpty, child: 20.ph),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.mainBlueColor,
                    ),
                    20.px,
                    CustomText(
                      text: globalSharedPreference.getBool("isArabic") == false
                          ? widget.post.location!
                          : switchLocationToArabic(widget.post.location!),
                      textColor:
                          globalSharedPreference.getBool("isDarkMode") ?? false
                              ? AppColors.secondaryDarkFontColor
                              : AppColors.secondaryFontColor,
                    )
                  ],
                ),
                Align(
                  alignment: globalSharedPreference.getBool("isArabic") == false
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => connectionDialog(),
                    ),
                    child: Icon(
                      Icons.question_mark_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: w * 0.15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget connectionDialog() {
    return Dialog(
      shadowColor: AppColors.mainBlackColor,
      surfaceTintColor: Colors.transparent,
      alignment: globalSharedPreference.getBool("isArabic") == false
          ? Alignment.bottomRight
          : Alignment.bottomLeft,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetPadding: globalSharedPreference.getBool("isArabic") == false
          ? const EdgeInsets.only(bottom: 250, right: 36, left: 315)
          : const EdgeInsets.only(bottom: 250, right: 315, left: 36),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => cLaunchUrl(emailLaunchUri(widget.post)),
                child: const Icon(
                  Icons.mail_outline_outlined,
                  size: 30,
                ),
              ),
              40.ph,
              InkWell(
                onTap: () => cLaunchUrl(Uri.parse(
                  'https://wa.me/${widget.post.ownerPhoneNumber}',
                )),
                child: SvgPicture.asset(
                  'assets/whatsapp-svgrepo-com.svg',
                  width: 35,
                  height: 35,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

Uri emailLaunchUri(Post post) => Uri(
      scheme: 'mailto',
      path: '${globalSharedPreference.getString('email')}',
      query: encodeQueryParameters(<String, String>{
        'subject':
            '${globalSharedPreference.getString('shopName')}\nproduct title: ${post.title}\ndescription!?: ${post.description!}',
      }),
    );
