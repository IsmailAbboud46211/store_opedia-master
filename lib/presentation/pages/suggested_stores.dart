import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/data/models/shop.dart';
import 'package:shopesapp/logic/cubites/cubit/settings/internet_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/store_cubit.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_divider.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/widgets/suggested_store/page_hader.dart';
import 'package:shopesapp/presentation/widgets/suggested_store/suggested_store.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../data/enums/filter_type.dart';
import '../../data/data base/shared_preferences_repository.dart';
import '../../logic/cubites/shop/search_store_cubit.dart';
import '../../main.dart';
import '../shared/custom_widgets/user_input.dart';
import '../widgets/home/no_posts_yet.dart';
import '../widgets/suggested_store/no_shop_yet.dart';
import '../widgets/switch_shop/error.dart';

class SuggestedStoresView extends StatefulWidget {
  const SuggestedStoresView({
    this.filter,
    Key? key,
    this.city,
    this.category,
    this.latitude,
    this.longitude,
  }) : super(key: key);
  final FilterType? filter;
  final String? city;
  final String? category;
  final double? latitude;
  final double? longitude;

  @override
  State<SuggestedStoresView> createState() => SuggestedStoresViewState();
}

class SuggestedStoresViewState extends State<SuggestedStoresView> {
  List<dynamic> suggestedStoresList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void didUpdateWidget(covariant SuggestedStoresView oldWidget) {
    if (widget.filter != oldWidget.filter) updatePage();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    if (suggestedStoresList.isEmpty) {
      switch (widget.filter) {
        case FilterType.All:
          context.read<StoreCubit>().getAllStores();
          break;
        case FilterType.RATE:
          context.read<StoreCubit>().filterStores(
              id: globalSharedPreference.getString("ID") ?? '0', type: 'rate');
          break;
        case FilterType.NEW:
          context.read<StoreCubit>().filterStores(
              id: globalSharedPreference.getString("ID") ?? '0', type: 'new');
          break;
        case FilterType.OLD:
          context.read<StoreCubit>().filterStores(
              id: globalSharedPreference.getString("ID") ?? '0', type: 'old');
          break;
        case FilterType.CATEGORY:
          context.read<StoreCubit>().categoryFilterStores(
                category: widget.category ?? '',
                id: globalSharedPreference.getString("ID") ?? '0',
              );
          break;
        case FilterType.CITY:
          context.read<StoreCubit>().cilyFilterStores(
              id: globalSharedPreference.getString("ID") ?? '0',
              address: widget.city ?? '');

          break;
        case FilterType.LOCATION:
          context.read<StoreCubit>().locationFilterStores(
                id: globalSharedPreference.getString("ID") ?? '0',
                longitude: widget.latitude ?? 37.43296265331129,
                latitude: widget.longitude ?? -122.08832357078792,
              );
          break;
        default:
          context.read<StoreCubit>().getAllStores();

          break;
      }
    }

    super.initState();
  }

  updatePage() {
    if (suggestedStoresList.isEmpty) {
      switch (widget.filter) {
        case FilterType.All:
          context.read<StoreCubit>().getAllStores();
          break;
        case FilterType.RATE:
          context.read<StoreCubit>().filterStores(
              id: globalSharedPreference.getString("ID") ?? '0', type: 'rate');
          break;
        case FilterType.NEW:
          context.read<StoreCubit>().filterStores(
              id: globalSharedPreference.getString("ID") ?? '0', type: 'new');
          break;
        case FilterType.OLD:
          context.read<StoreCubit>().filterStores(
              id: globalSharedPreference.getString("ID") ?? '0', type: 'old');
          break;
        case FilterType.CATEGORY:
          break;
        case FilterType.CITY:
          context.read<StoreCubit>().cilyFilterStores(
              id: globalSharedPreference.getString("ID") ?? '0',
              address: widget.city ?? '');

          break;
        case FilterType.LOCATION:
          context.read<StoreCubit>().locationFilterStores(
                id: globalSharedPreference.getString("ID") ?? '0',
                longitude: widget.latitude ?? 37.43296265331129,
                latitude: widget.longitude ?? -122.08832357078792,
              );
          break;
        default:
          context.read<StoreCubit>().getAllStores();

          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<StoreCubit>().getAllStores();
      },
      child: Scaffold(body: BlocBuilder<InternetCubit, InternetState>(
        builder: (context, state) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      children: [
                        const PageHeader(),
                        UserInput(
                          onChanged: (value) {
                            BlocProvider.of<SearchStoreCubit>(context)
                                .searchStore(
                                    ownerID: globalSharedPreference
                                            .getString("ID") ??
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
                          return buildError(size);
                        })
                      : BlocBuilder<StoreCubit, StoreState>(
                          builder: (context, state) {
                          if (state is FeatchingShopsProgress) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is NoShopsYet) {
                            return buildNoShopsYet(size);
                          } else if (state is FeatchingShopsSucceed) {
                            suggestedStoresList =
                                context.read<StoreCubit>().shops;
                            return suggestedStoresList.isEmpty
                                ? buildNoShopsYet(size)
                                : ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: suggestedStoresList.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const CustomDivider();
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SuggestedStore(
                                        shop: Shop.fromMap(
                                            suggestedStoresList[index]),
                                      );
                                    },
                                  );
                          }
                          if (!SharedPreferencesRepository
                              .getBrowsingPostsMode()) {
                            return buildNoPostsYet(
                              size,
                              LocaleKeys.browsing_mode_home.tr(),
                            );
                          }
                          return buildError(size);
                        }),
                ],
              ));
        },
      )),
    );
  }
}
