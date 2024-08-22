import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/data/models/post.dart';
import 'package:shopesapp/logic/cubites/shop/show_favorite_stores_cubit.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_divider.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/widgets/suggested_store/suggested_store.dart';
import 'package:shopesapp/presentation/widgets/switch_shop/error.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../data/models/shop.dart';
import '../../data/data base/shared_preferences_repository.dart';
import '../../logic/cubites/post/show_favorite_posts_cubit.dart';
import '../../logic/cubites/shop/favorite_cubit.dart';
import '../widgets/product/product_post.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  late TabController tabController;

  late List favoritePostsList = SharedPreferencesRepository.getFavoritePosts();
  late List favoriteStoresList =
      SharedPreferencesRepository.getFavoriteStores();
  @override
  void initState() {
    context.read<ShowFavoriteStoresCubit>().showMyFavoriteStores(
        ownerID: globalSharedPreference.getString("ID") ?? '0');
    context.read<ShowFavoritePostsCubit>().showMyFavoritePosts(
        ownerID: globalSharedPreference.getString("ID") ?? '0');

    super.initState();
    tabController = TabController(length: 2, vsync: TickerProviderImpl());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ShowFavoritePostsCubit>().showMyFavoritePosts(
            ownerID: globalSharedPreference.getString("ID")!);
      },
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(controller: tabController, tabs: [
            Tab(
              child: CustomText(
                text: LocaleKeys.favorite_products.tr(),
                textColor: AppColors.mainWhiteColor,
              ),
            ),
            Tab(
              child: CustomText(
                text: LocaleKeys.favorite_stores.tr(),
                textColor: AppColors.mainWhiteColor,
              ),
            ),
          ]),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ShowFavoriteStoresCubit>().showMyFavoriteStores(
                  ownerID: globalSharedPreference.getString("ID")!,
                );
          },
          child: TabBarView(
            controller: tabController,
            children: [
              RefreshIndicator(
                  onRefresh: () async {
                    context.read<ShowFavoritePostsCubit>().showMyFavoritePosts(
                          ownerID: globalSharedPreference.getString("ID")!,
                        );
                  },
                  child: !SharedPreferencesRepository.getBrowsingPostsMode()
                      ? BlocConsumer<ShowFavoritePostsCubit,
                          ShowFavoritePostsState>(
                          listener: (context, state) {
                            if (state is ShowFavoritePostsSuccessed) {
                              favoritePostsList = state.favoritePosts;
                              SharedPreferencesRepository.setFavoritePosts(
                                  favoritePostsList: favoritePostsList);
                            }
                          },
                          builder: (context, state) {
                            return BlocBuilder<ShowFavoritePostsCubit,
                                ShowFavoritePostsState>(
                              builder: (context, state) {
                                if (state is ShowFavoritePostsProgress) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (state is ShowFavoritePostsSuccessed) {
                                  favoritePostsList = context
                                      .read<ShowFavoritePostsCubit>()
                                      .favoritePosts;
                                  return SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      40.ph,
                                      ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: context
                                            .read<ShowFavoritePostsCubit>()
                                            .favoritePosts
                                            .length,
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: size.height * 0.01),
                                              child: const Divider(
                                                thickness: 7,
                                              ));
                                        },
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ProductPost(
                                              post: Post.fromMap(context
                                                  .read<
                                                      ShowFavoritePostsCubit>()
                                                  .favoritePosts[index]));
                                        },
                                      ),
                                    ],
                                  ));
                                }
                                if (state is NoFavoritePosts) {
                                  return Center(
                                    child: CustomText(
                                        text: LocaleKeys.no_favorite_posts_yet
                                            .tr()),
                                  );
                                }
                                return Center(
                                  child: Text(LocaleKeys
                                      .some_thing_went_wrong_check_your_internet_connection_and_try_again
                                      .tr()),
                                );
                              },
                            );
                          },
                        )
                      : const Center(
                          child: CustomText(
                              text:
                                  'you can\'t have favorite posts in browsing mode '))),
              RefreshIndicator(
                onRefresh: () async {
                  context.read<ShowFavoriteStoresCubit>().showMyFavoriteStores(
                        ownerID: globalSharedPreference.getString("ID")!,
                      );
                },
                child: !SharedPreferencesRepository.getBrowsingPostsMode()
                    ? BlocBuilder<ShowFavoriteStoresCubit,
                        ShowFavoriteStoresState>(
                        builder: (context, state) {
                          if (state is ShowFavoriteStoresProgress) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (state is ShowFavoriteStoresSuccessed) {
                            favoriteStoresList = state.favoriteStores;
                            return SingleChildScrollView(
                                child: Column(
                              children: [
                                40.ph,
                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.favoriteStores.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: size.height * 0.01),
                                        child: const Divider(
                                          thickness: 7,
                                        ));
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SuggestedStore(
                                        shop: Shop.fromMap(
                                            state.favoriteStores[index]));
                                  },
                                ),
                              ],
                            ));
                          }
                          if (state is NoFavoriteStores) {
                            return Center(
                              child: CustomText(
                                  text: LocaleKeys.no_favorite_stores_yet.tr()),
                            );
                          }
                          return buildError(size);
                        },
                      )
                    : BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, state) {
                          favoriteStoresList = state.favoriteShops;

                          return favoriteStoresList.isNotEmpty
                              ? SingleChildScrollView(
                                  child: Column(
                                  children: [
                                    40.ph,
                                    ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: favoriteStoresList.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const CustomDivider();
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return SuggestedStore(
                                            shop: Shop.fromJson(
                                                favoriteStoresList[index]));
                                      },
                                    ),
                                  ],
                                ))
                              : const Center(
                                  child: CustomText(
                                      text: 'No Favorite stores Yet'),
                                );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
