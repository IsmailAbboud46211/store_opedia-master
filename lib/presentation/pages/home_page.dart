import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/logic/cubites/post/filter_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/search_store_cubit.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/widgets/suggested_store/page_hader.dart';
import 'package:shopesapp/presentation/widgets/product/product_post.dart';
import 'package:shopesapp/presentation/widgets/switch_shop/error.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../data/enums/message_type.dart';
import '../../data/models/post.dart';
import '../../data/models/shop.dart';
import '../../data/data base/shared_preferences_repository.dart';
import '../../logic/cubites/cubit/settings/internet_cubit.dart';
import '../../main.dart';
import '../shared/custom_widgets/custom_divider.dart';
import '../shared/custom_widgets/custom_toast.dart';
import '../shared/custom_widgets/user_input.dart';
import '../widgets/home/no_Internet.dart';
import '../widgets/home/no_posts_yet.dart';
import '../widgets/suggested_store/no_shop_yet.dart';
import '../widgets/suggested_store/suggested_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> postsList = [];
  @override
  void initState() {
    super.initState();

    if (postsList.isEmpty) {
      context.read<FilterCubit>().getAllPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FilterCubit>().getAllPosts();
      },
      child: Scaffold(
        body: BlocConsumer<InternetCubit, InternetState>(
          listener: (context, state) {
            if (state is InternetDisconnected) {
              CustomToast.showMessage(
                  context: context,
                  size: size,
                  message: LocaleKeys.no_internet.tr(),
                  messageType: MessageType.REJECTED);
            }
          },
          builder: (context, state) {
            if (state is InternetDisconnected) {
              return buildNoInternet(size);
            }
            return ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Column(
                    children: [
                      const PageHeader(
                        homePage: true,
                      ),
                      UserInput(
                        onChanged: (value) {
                          BlocProvider.of<SearchStoreCubit>(context)
                              .searchStore(
                                  ownerID:
                                      globalSharedPreference.getString("ID") ??
                                          '0',
                                  search: value);
                        },
                        text: LocaleKeys.search.tr(),
                        prefixIcon: const Icon(Icons.search),
                        controller: searchController,
                      ),
                    ],
                  ),
                ),
                30.ph,
                searchController.text.isNotEmpty
                    ? BlocBuilder<SearchStoreCubit, SearchStoreState>(
                        builder: (context, state) {
                        if (state is SearchStoreProgress) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is NoSearchResult) {
                          return buildNoShopsYet(size);
                        } else if (state is SearchStoreSuccessed) {
                          return ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.searchResult.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const CustomDivider();
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return SuggestedStore(
                                shop: Shop.fromMap(state.searchResult[index]),
                              );
                            },
                          );
                        }
                        return Center(
                          child: Text(LocaleKeys.no_search_result.tr()),
                        );
                      })
                    : (SharedPreferencesRepository.getBrowsingPostsMode())
                        ? Center(
                            child: buildNoPostsYet(
                                size, LocaleKeys.browsing_mode_home.tr()),
                          )
                        : BlocBuilder<FilterCubit, FilterState>(
                            builder: (context, state) {
                            if (state is FilterProgress) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is NoPostYet) {
                              return buildNoPostsYet(size,
                                  LocaleKeys.no_posts_yet_follow_alert.tr());
                            } else if (state is DontFollowStoreYet) {
                              return buildNoPostsYet(
                                  size,
                                  LocaleKeys
                                      .you_dont_have_any_followed_store_yet
                                      .tr());
                            } else if (state is FilteredSuccessfully) {
                              postsList = BlocProvider.of<FilterCubit>(context)
                                  .filteredPosts;
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: postsList.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.01),
                                      child: const Divider(
                                        thickness: 7,
                                      ));
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return ProductPost(
                                    post: Post.fromMap(postsList[index]),
                                  );
                                },
                              );
                            }
                            return buildError(size);
                          }),
              ],
            );
          },
        ),
      ),
    );
  }
}
