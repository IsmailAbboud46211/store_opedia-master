import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:shopesapp/data/enums/message_type.dart';
import 'package:shopesapp/logic/cubites/post/show_favorite_posts_cubit.dart';
import 'package:shopesapp/logic/cubites/post/toggle_post_favorite_cubit.dart';
import 'package:shopesapp/logic/cubites/post/delete_post_cubit.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/presentation/pages/edit_post.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_icon_text.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_toast.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/widgets/product/delete_post_alert_dialog.dart';
import 'package:shopesapp/presentation/widgets/product/product_info.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

import '../../../global/functions/switch_to_arabic.dart';
import '../../../data/data base/shared_preferences_repository.dart';
import '../../../logic/cubites/post/filter_cubit.dart';
import '../../../logic/cubites/post/post_favorite_cubit.dart';
import '../../../logic/cubites/post/posts_cubit.dart';
import '../../../logic/cubites/shop/show_favorite_stores_cubit.dart';
import '../../pages/map_page.dart';
import '../../shared/custom_widgets/custom_text.dart';
import '../dialogs/browsing_alert_dialog.dart';

// ignore: must_be_immutable
class ProductPost extends StatefulWidget {
  final dynamic post;

  bool? profileDisplay;
  ProductPost({Key? key, required this.post, this.profileDisplay = false})
      : super(key: key);

  @override
  State<ProductPost> createState() => _ProductPostState();
}

class _ProductPostState extends State<ProductPost> {
  @override
  void initState() {
    BlocProvider.of<ShowFavoriteStoresCubit>(context)
        .showMyFavoriteStores(ownerID: globalSharedPreference.getString("ID")!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    final h = MediaQuery.of(context).size.height;

    Future postOptionsDialog() {
      return showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) {
            return Wrap(
              children: [
                Container(
                  padding: EdgeInsets.all(w * 0.1),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => context
                              .push(EditPostPage(
                                post: widget.post,
                              ))
                              .then((value) => context.pop()),
                          child: CustomIconTextRow(
                              fontSize: w * 0.04,
                              iconColor: Theme.of(context).primaryColorDark,
                              svgIcon: 'edit-svgrepo-com',
                              textColor: Theme.of(context).primaryColorDark,
                              text: LocaleKeys.edit_post.tr()),
                        ),
                        30.ph,
                        BlocProvider(
                          create: (context) => DeletePostCubit(),
                          child: BlocConsumer<DeletePostCubit, DeletePostState>(
                            listener: (context, state) {
                              if (state is DeletePostFailed) {
                                CustomToast.showMessage(
                                    size: size,
                                    message: state.message,
                                    context: context,
                                    messageType: MessageType.REJECTED);
                                setState(() {});
                                context.pop();
                              } else if (state is DeletePostSucceed) {
                                CustomToast.showMessage(
                                    size: size,
                                    message: LocaleKeys
                                        .post_has_been_deleted_successfully
                                        .tr(),
                                    context: context,
                                    messageType: MessageType.SUCCESS);
                                context.read<PostsCubit>().getOwnerPosts(
                                    ownerID:
                                        globalSharedPreference.getString('ID'),
                                    shopID: widget.post.shopID);
                                context.pop();
                              }
                            },
                            builder: (context, state) {
                              if (state is DeletePostProgress) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return InkWell(
                                onTap: () => buildDeletePostAlert(
                                  context: context,
                                  ownerID:
                                      globalSharedPreference.getString("ID") ??
                                          '0',
                                  shopID: globalSharedPreference
                                          .getString("shopID") ??
                                      '0',
                                  postID: widget.post.postID,
                                ),
                                child: CustomIconTextRow(
                                    fontSize: w * 0.04,
                                    iconColor:
                                        Theme.of(context).primaryColorDark,
                                    svgIcon: 'delete-svgrepo-com',
                                    textColor:
                                        Theme.of(context).primaryColorDark,
                                    text: LocaleKeys.delete_post.tr()),
                              );
                            },
                          ),
                        ),
                      ]),
                ),
              ],
            );
          });
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: widget.post.shopName,
                        bold: true,
                      ),
                      5.ph,
                      CustomText(
                        text: globalSharedPreference.getBool("isArabic") ==
                                false
                            ? widget.post.shopCategory
                            : switchCategoryToArabic(widget.post.shopCategory),
                        fontSize: w * 0.03,
                        textColor: Theme.of(context).hintColor,
                      ),
                    ],
                  )
                ],
              ),
              IconButton(
                  onPressed: () {
                    if (widget.profileDisplay!) {
                      postOptionsDialog();
                    } else {
                      context.push(MapPage(
                          currentLocation: LocationData.fromMap({
                        'latitude': widget.post.latitude,
                        'longitude': widget.post.longitude
                      })));
                    }
                  },
                  icon: !widget.profileDisplay!
                      ? const Icon(Icons.location_on_outlined)
                      : const Icon(Icons.edit))
            ],
          ),
        ),
        20.ph,
        Container(
          height: h / 5,
          color: AppColors.mainBlackColor,
          child: widget.post.photos != 'url'
              ? Image.network(widget.post.photos)
              : Image.asset('assets/images.jpg'),
        ),
        20.ph,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: widget.post.title),
                ],
              ),
              Row(
                children: [
                  BlocBuilder<TogglePostFavoriteCubit, TogglePostFavoriteState>(
                    builder: (context, state) {
                      PostFavoriteCubit postFavorite =
                          context.read<PostFavoriteCubit>();
                      return IconButton(
                          onPressed: () {
                            if (!SharedPreferencesRepository
                                .getBrowsingPostsMode()) {
                              postFavorite.isPostFavorite(widget.post)
                                  ? postFavorite
                                      .removeFromFavorites(widget.post)
                                  : postFavorite.addToFavorites(widget.post);

                              context
                                  .read<TogglePostFavoriteCubit>()
                                  .toggolePostFavorite(
                                      postID: widget.post.postID,
                                      userID: globalSharedPreference
                                          .getString("ID")!);
                              context.read<FilterCubit>().getAllPosts().then(
                                  (value) => context
                                      .read<ShowFavoritePostsCubit>()
                                      .showMyFavoritePosts(
                                          ownerID: globalSharedPreference
                                                  .getString("ID") ??
                                              '0'));
                            } else {
                              showBrowsingDialogAlert(context);
                            }
                          },
                          icon: !postFavorite.isPostFavorite(widget.post) ||
                                  !widget.post.isFavorit
                              ? const Icon(Icons.favorite_border_outlined)
                              : Icon(
                                  Icons.favorite,
                                  color: AppColors.mainRedColor,
                                ));
                    },
                  ),
                  10.px,
                  InkWell(
                      onTap: () => context.push(ProductInfo(
                            post: widget.post,
                          )),
                      child: const Icon(Icons.info_outline)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
